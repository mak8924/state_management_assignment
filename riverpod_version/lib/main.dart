import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/auth/login_page.dart';

void main() {
  runApp(const ProviderScope(child: StudentAuthRiverpodApp()));
}

class StudentAuthRiverpodApp extends StatelessWidget {
  const StudentAuthRiverpodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Authentication App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315C8C),
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
