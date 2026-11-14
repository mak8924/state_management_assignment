import 'package:flutter/material.dart';

const primaryColor = Color(0xFF315C8C);
const pageColor = Color(0xFFF4F7FB);

InputDecoration fieldDecoration(String label, IconData icon, {Widget? suffix}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: primaryColor),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: Color(0xFFDCE4EF)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
  );
}

Widget pageLayout(Widget child) => Scaffold(
  backgroundColor: pageColor,
  body: SafeArea(child: Center(child: SingleChildScrollView(
    padding: const EdgeInsets.all(22),
    child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: child),
  ))),
);

Widget pageHeader(String title, String subtitle) => Column(children: [
  Container(width: 66, height: 66,
    decoration: BoxDecoration(color: primaryColor.withValues(alpha: .1), borderRadius: BorderRadius.circular(18)),
    child: const Icon(Icons.school_rounded, color: primaryColor, size: 36)),
  const SizedBox(height: 16),
  Text(title, textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF20334A))),
  const SizedBox(height: 7),
  Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.blueGrey)),
]);

Widget pageCard(Widget child) => Container(
  padding: const EdgeInsets.all(22),
  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 20, offset: const Offset(0, 7))]),
  child: child,
);

Widget submitButton(String label, bool loading, VoidCallback onPressed) => SizedBox(
  width: double.infinity, height: 52,
  child: ElevatedButton(
    onPressed: loading ? null : onPressed,
    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
    child: loading ? const SizedBox(width: 22, height: 22,
      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(label),
  ),
);
