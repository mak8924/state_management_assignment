import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../models/password_reset_request.dart';
import '../../utils/form_validators.dart';
import 'login_page.dart';
import 'reset_password_page.dart';
import 'widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _key = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _auth = Get.find<AuthController>();

  @override
  void dispose() { _id.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    final value = _id.text.trim();
    final ok = await _auth.sendCode(PasswordResetRequest(emailOrAcademicId: value));
    if (ok) {
      Get.snackbar('Code generated', 'Your demo reset code is ready.',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFE5F6EA));
      Get.to(() => ResetPasswordPage(emailOrAcademicId: value));
    }
  }

  @override
  Widget build(BuildContext context) => pageLayout(Column(children: [
    pageHeader('Forgot Password?', 'Recover access to your student account'),
    const SizedBox(height: 24),
    pageCard(Form(key: _key, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('Enter the email address or academic ID linked to your account. A 6-digit demo code will be generated.',
        style: TextStyle(height: 1.5)),
      const SizedBox(height: 18),
      TextFormField(controller: _id, decoration: fieldDecoration('Email or Academic ID', Icons.person_outline),
        validator: FormValidators.loginIdentifier),
      const SizedBox(height: 18),
      Obx(() => submitButton('Send reset code', _auth.isLoading.value, _submit)),
    ]))),
    TextButton(onPressed: () => Get.offAll(() => const LoginPage()), child: const Text('Back to login')),
  ]));
}
