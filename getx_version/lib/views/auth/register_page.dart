import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../models/register_request.dart';
import '../../utils/form_validators.dart';
import 'login_page.dart';
import 'widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController(), _id = TextEditingController(),
      _email = TextEditingController(), _pass = TextEditingController(), _confirm = TextEditingController();
  final _auth = Get.find<AuthController>();
  bool _hide = true, _hideConfirm = true, _terms = false;

  @override
  void dispose() {
    _name.dispose(); _id.dispose(); _email.dispose(); _pass.dispose(); _confirm.dispose(); super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    if (!_terms) {
      Get.snackbar('Terms required', 'Please accept the terms and conditions.');
      return;
    }
    final ok = await _auth.register(RegisterRequest(
      fullName: _name.text.trim(), academicId: _id.text.trim(),
      email: _email.text.trim(), password: _pass.text));
    if (ok) {
      Get.snackbar('Success', 'Your account has been created.');
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) => pageLayout(Column(children: [
    pageHeader('Create Account', 'Register with your university details'),
    const SizedBox(height: 24),
    pageCard(Form(key: _key, child: Column(children: [
      TextFormField(controller: _name, decoration: fieldDecoration('Full name', Icons.badge_outlined),
        validator: FormValidators.fullName),
      const SizedBox(height: 13),
      TextFormField(controller: _id, keyboardType: TextInputType.number,
        decoration: fieldDecoration('Academic ID', Icons.numbers), validator: FormValidators.academicId),
      const SizedBox(height: 13),
      TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
        decoration: fieldDecoration('University email', Icons.email_outlined), validator: FormValidators.email),
      const SizedBox(height: 13),
      TextFormField(controller: _pass, obscureText: _hide,
        decoration: fieldDecoration('Password', Icons.lock_outline, suffix: IconButton(
          onPressed: () => setState(() => _hide = !_hide),
          icon: Icon(_hide ? Icons.visibility : Icons.visibility_off))),
        validator: FormValidators.strongPassword),
      const SizedBox(height: 13),
      TextFormField(controller: _confirm, obscureText: _hideConfirm,
        decoration: fieldDecoration('Confirm password', Icons.lock_reset, suffix: IconButton(
          onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
          icon: Icon(_hideConfirm ? Icons.visibility : Icons.visibility_off))),
        validator: (v) => FormValidators.confirmPassword(v, _pass.text)),
      CheckboxListTile(contentPadding: EdgeInsets.zero, value: _terms,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text('I agree to the terms and conditions.'),
        onChanged: (v) => setState(() => _terms = v ?? false)),
      const SizedBox(height: 10),
      Obx(() => submitButton('Create account', _auth.isLoading.value, _submit)),
    ]))),
    TextButton(onPressed: () => Get.offAll(() => const LoginPage()), child: const Text('Already have an account? Login')),
  ]));
}
