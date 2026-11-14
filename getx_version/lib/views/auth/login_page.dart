import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../models/login_request.dart';
import '../../utils/form_validators.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import 'widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _password = TextEditingController();
  final _auth = Get.find<AuthController>();
  bool _obscure = true, _remember = false;

  @override
  void dispose() { _id.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    final ok = await _auth.login(LoginRequest(
      emailOrAcademicId: _id.text.trim(), password: _password.text, rememberMe: _remember));
    if (ok) Get.snackbar('Welcome', 'Login successful.', snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) => pageLayout(Column(children: [
    pageHeader('Student Login', 'Sign in to continue to your account'),
    const SizedBox(height: 24),
    pageCard(Form(key: _key, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextFormField(controller: _id, decoration: fieldDecoration('Email or Academic ID', Icons.person_outline),
        validator: FormValidators.loginIdentifier),
      const SizedBox(height: 15),
      TextFormField(controller: _password, obscureText: _obscure,
        decoration: fieldDecoration('Password', Icons.lock_outline, suffix: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined))),
        validator: FormValidators.loginPassword),
      Row(children: [
        Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? false)),
        const Text('Remember me'), const Spacer(),
        TextButton(onPressed: () => Get.to(() => const ForgotPasswordPage()), child: const Text('Forgot password?')),
      ]),
      Obx(() => submitButton('Login', _auth.isLoading.value, _submit)),
    ]))),
    TextButton(onPressed: () => Get.to(() => const RegisterPage()),
      child: const Text("Don't have an account? Create one")),
  ]));
}
