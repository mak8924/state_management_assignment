import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/register_request.dart';
import '../../providers/auth_provider.dart';
import '../../utils/form_validators.dart';
import 'login_page.dart';
import 'widgets.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _id = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _hide = true;
  bool _hideConfirm = true;
  bool _terms = false;

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;

    if (!_terms) {
      showAppMessage(
        context,
        'Terms required',
        'Please accept the terms and conditions.',
      );
      return;
    }

    final ok = await ref.read(authProvider.notifier).register(
      RegisterRequest(
        fullName: _name.text.trim(),
        academicId: _id.text.trim(),
        email: _email.text.trim(),
        password: _pass.text,
      ),
    );

    if (!mounted) return;
    final error = ref.read(authProvider).errorMessage;

    if (ok) {
      showAppMessage(
        context,
        'Success',
        'Your account has been created.',
        success: true,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    } else {
      showAppMessage(context, 'Error', error ?? 'Registration failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return pageLayout(
      Column(
        children: [
          pageHeader('Create Account', 'Register with your university details'),
          const SizedBox(height: 24),
          pageCard(
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: fieldDecoration(
                      'Full name',
                      Icons.badge_outlined,
                    ),
                    validator: FormValidators.fullName,
                  ),
                  const SizedBox(height: 13),
                  TextFormField(
                    controller: _id,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration(
                      'Academic ID',
                      Icons.numbers,
                    ),
                    validator: FormValidators.academicId,
                  ),
                  const SizedBox(height: 13),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: fieldDecoration(
                      'University email',
                      Icons.email_outlined,
                    ),
                    validator: FormValidators.email,
                  ),
                  const SizedBox(height: 13),
                  TextFormField(
                    controller: _pass,
                    obscureText: _hide,
                    decoration: fieldDecoration(
                      'Password',
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
                      'Confirm password',
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
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _terms,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'I agree to the terms and conditions.',
                    ),
                    onChanged: (v) =>
                        setState(() => _terms = v ?? false),
                  ),
                  const SizedBox(height: 10),
                  submitButton('Create account', auth.isLoading, _submit),
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
            child: const Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }
}
