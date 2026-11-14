class PasswordResetSessionModel {
  final String emailOrAcademicId, resetCode;
  final DateTime expiresAt;
  const PasswordResetSessionModel({required this.emailOrAcademicId, required this.resetCode, required this.expiresAt});
}
