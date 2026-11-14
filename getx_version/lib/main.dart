import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/initial_binding.dart';
import 'views/auth/login_page.dart';

void main() => runApp(const StudentAuthGetXApp());

class StudentAuthGetXApp extends StatelessWidget {
  const StudentAuthGetXApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'Student Authentication - GetX',
    debugShowCheckedModeBanner: false,
    initialBinding: InitialBinding(),
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315C8C)),
    ),
    home: const LoginPage(),
  );
}
