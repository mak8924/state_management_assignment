class ResetPasswordRequest {
  final String emailOrAcademicId, resetCode, newPassword;
  const ResetPasswordRequest({required this.emailOrAcademicId, required this.resetCode, required this.newPassword});
}
