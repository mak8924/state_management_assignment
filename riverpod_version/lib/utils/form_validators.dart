class FormValidators {
  static String? requiredText(String? v, String label) =>
      v == null || v.trim().isEmpty ? '$label is required.' : null;

  static String? loginIdentifier(String? v) {
    final e = requiredText(v, 'Email or academic ID');
    if (e != null) return e;
    return v!.trim().length < 5 ? 'Enter at least 5 characters.' : null;
  }

  static String? loginPassword(String? v) {
    final e = requiredText(v, 'Password');
    if (e != null) return e;
    return v!.length < 6 ? 'Password must be at least 6 characters.' : null;
  }

  static String? fullName(String? v) {
    final e = requiredText(v, 'Full name');
    if (e != null) return e;
    return v!.trim().length < 3 ? 'Name must contain at least 3 characters.' : null;
  }

  static String? academicId(String? v) {
    final e = requiredText(v, 'Academic ID');
    if (e != null) return e;
    return RegExp(r'^\d{9,10}$').hasMatch(v!.trim()) ? null : 'Academic ID must contain 9 or 10 digits.';
  }

  static String? email(String? v) {
    final e = requiredText(v, 'University email');
    if (e != null) return e;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v!.trim()) ? null : 'Enter a valid email.';
  }

  static String? strongPassword(String? v) {
    final e = requiredText(v, 'Password');
    if (e != null) return e;
    return v!.length >= 8 && RegExp(r'[A-Z]').hasMatch(v) && RegExp(r'\d').hasMatch(v)
        ? null : 'Use 8+ characters, one uppercase letter and one digit.';
  }

  static String? confirmPassword(String? v, String password) {
    final e = requiredText(v, 'Confirm password');
    if (e != null) return e;
    return v == password ? null : 'Passwords do not match.';
  }

  static String? resetCode(String? v) {
    final e = requiredText(v, 'Reset code');
    if (e != null) return e;
    return RegExp(r'^\d{6}$').hasMatch(v!.trim()) ? null : 'Enter the 6-digit code.';
  }
}
