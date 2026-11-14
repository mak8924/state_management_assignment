import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/reset_password_request.dart';
import '../../providers/auth_provider.dart';
import '../../utils/form_validators.dart';
import 'login_page.dart';
import 'widgets.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String emailOrAcademicId;

  const ResetPasswordPage({
    super.key,
    required this.emailOrAcademicId,
  });

  @override
  ConsumerState<ResetPasswordPage> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _key = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _hide = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _code.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;

    final ok = await ref.read(authProvider.notifier).resetPassword(
      ResetPasswordRequest(
        emailOrAcademicId: widget.emailOrAcademicId,
        resetCode: _code.text.trim(),
        newPassword: _pass.text,
      ),
    );

    if (!mounted) return;
    final error = ref.read(authProvider).errorMessage;

    if (ok) {
      showAppMessage(
        context,
        'Success',
        'Password updated. You can now log in.',
        success: true,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    } else {
      showAppMessage(context, 'Error', error ?? 'Password reset failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return pageLayout(
      Column(
        children: [
          pageHeader(
            'Reset Password',
            'Enter your code and choose a new password',
          ),
          const SizedBox(height: 24),
          pageCard(
            Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (auth.demoOtp != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4D6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Demo OTP: ${auth.demoOtp}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  TextFormField(
                    controller: _code,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: fieldDecoration(
                      '6-digit reset code',
                      Icons.verified_user_outlined,
                    ),
                    validator: FormValidators.resetCode,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _pass,
                    obscureText: _hide,
                    decoration: fieldDecoration(
                      'New password',
                      Icons.lock_outline,
                      suffix: IconButton(
                        onPressed: () => setState(() => _hide = !_hide),
                        icon: Icon(
                          _hide ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: FormValidators.strongPassword,
                  ),
                  const SizedBox(height: 13),
                  TextFormField(
                    controller: _confirm,
                    obscureText: _hideConfirm,
                    decoration: fieldDecoration(
                      'Confirm new password',
                      Icons.lock_reset,
                      suffix: IconButton(
                        onPressed: () => setState(
                          () => _hideConfirm = !_hideConfirm,
                        ),
                        icon: Icon(
                          _hideConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        FormValidators.confirmPassword(v, _pass.text),
                  ),
                  const SizedBox(height: 17),
                  submitButton('Update password', auth.isLoading, _submit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
