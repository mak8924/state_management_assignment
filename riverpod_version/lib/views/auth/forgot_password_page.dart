import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/password_reset_request.dart';
import '../../providers/auth_provider.dart';
import '../../utils/form_validators.dart';
import 'login_page.dart';
import 'reset_password_page.dart';
import 'widgets.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _key = GlobalKey<FormState>();
  final _id = TextEditingController();

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;

    final value = _id.text.trim();
    final ok = await ref.read(authProvider.notifier).sendCode(
      PasswordResetRequest(emailOrAcademicId: value),
    );

    if (!mounted) return;
    final error = ref.read(authProvider).errorMessage;

    if (ok) {
      showAppMessage(
        context,
        'Code generated',
        'Your demo reset code is ready.',
        success: true,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(emailOrAcademicId: value),
        ),
      );
    } else {
      showAppMessage(context, 'Error', error ?? 'Could not generate code.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return pageLayout(
      Column(
        children: [
          pageHeader(
            'Forgot Password?',
            'Recover access to your student account',
          ),
          const SizedBox(height: 24),
          pageCard(
            Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter the email address or academic ID linked to your account. A 6-digit demo code will be generated.',
                    style: TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _id,
                    decoration: fieldDecoration(
                      'Email or Academic ID',
                      Icons.person_outline,
                    ),
                    validator: FormValidators.loginIdentifier,
                  ),
                  const SizedBox(height: 18),
                  submitButton('Send reset code', auth.isLoading, _submit),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (_) => false,
            ),
            child: const Text('Back to login'),
          ),
        ],
      ),
    );
  }
}
