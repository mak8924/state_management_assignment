import 'dart:math';
import '../models/account_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/password_reset_request.dart';
import '../models/password_reset_session_model.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final List<AccountModel> _accounts = [];
  final List<PasswordResetSessionModel> _sessions = [];
  final Random _random = Random.secure();

  AccountModel? _find(String id) {
    for (final a in _accounts) {
      if (a.user.email.toLowerCase() == id.trim().toLowerCase() ||
        a.user.academicId == id.trim()) {
      return a;
    }
    }
    return null;
  }

  @override
  Future<UserModel> register(RegisterRequest r) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_find(r.email) != null || _find(r.academicId) != null) {
      throw Exception('Email or academic ID already exists.');
    }
    final user = UserModel(fullName: r.fullName.trim(), academicId: r.academicId.trim(), email: r.email.trim().toLowerCase());
    _accounts.add(AccountModel(user: user, password: r.password));
    return user;
  }

  @override
  Future<UserModel> login(LoginRequest r) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final a = _find(r.emailOrAcademicId);
    if (a == null || a.password != r.password) throw Exception('Invalid email/academic ID or password.');
    // rememberMe is accepted; persistence is not implemented in this in-memory demo.
    return a.user;
  }

  @override
  Future<String> sendPasswordResetCode(PasswordResetRequest r) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_find(r.emailOrAcademicId) == null) throw Exception('Account not found.');
    _sessions.removeWhere((s) => s.emailOrAcademicId.toLowerCase() == r.emailOrAcademicId.trim().toLowerCase());
    final code = (100000 + _random.nextInt(900000)).toString();
    _sessions.add(PasswordResetSessionModel(
      emailOrAcademicId: r.emailOrAcademicId.trim(),
      resetCode: code,
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    ));
    return code;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest r) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final a = _find(r.emailOrAcademicId);
    if (a == null) throw Exception('Account not found.');
    PasswordResetSessionModel? session;
    for (final s in _sessions) {
      if (s.emailOrAcademicId.toLowerCase() == r.emailOrAcademicId.trim().toLowerCase()) {
        session = s;
        break;
      }
    }
    if (session == null || session.resetCode != r.resetCode.trim() ||
        DateTime.now().isAfter(session.expiresAt)) {
      throw Exception('Invalid or expired reset code.');
    }
    a.password = r.newPassword;
    _sessions.remove(session);
  }
}
