import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/login_request.dart';
import '../../providers/auth_provider.dart';
import '../../utils/form_validators.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import 'widgets.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _key = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _remember = false;

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;

    final ok = await ref.read(authProvider.notifier).login(
      LoginRequest(
        emailOrAcademicId: _id.text.trim(),
        password: _password.text,
        rememberMe: _remember,
      ),
    );

    if (!mounted) return;
    final error = ref.read(authProvider).errorMessage;

    if (ok) {
      showAppMessage(context, 'Welcome', 'Login successful.', success: true);
    } else {
      showAppMessage(context, 'Error', error ?? 'Login failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return pageLayout(
      Column(
        children: [
          pageHeader('Student Login', 'Sign in to continue to your account'),
          const SizedBox(height: 24),
          pageCard(
            Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _id,
                    decoration: fieldDecoration(
                      'Email or Academic ID',
                      Icons.person_outline,
                    ),
                    validator: FormValidators.loginIdentifier,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: fieldDecoration(
                      'Password',
                      Icons.lock_outline,
                      suffix: IconButton(
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: FormValidators.loginPassword,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _remember,
                        onChanged: (v) =>
                            setState(() => _remember = v ?? false),
                      ),
                      const Text('Remember me'),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordPage(),
                          ),
                        ),
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ),
                  submitButton('Login', auth.isLoading, _submit),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            ),
            child: const Text("Don't have an account? Create one"),
          ),
        ],
      ),
    );
  }
}
