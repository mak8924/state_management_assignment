class LoginRequest {
  final String emailOrAcademicId;
  final String password;
  final bool rememberMe;
  const LoginRequest({required this.emailOrAcademicId, required this.password, required this.rememberMe});
}
