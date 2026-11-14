import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/password_reset_request.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../repositories/auth_repository_impl.dart';

class AuthState {
  final bool isLoading;
  final UserModel? currentUser;
  final String? demoOtp;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.currentUser,
    this.demoOtp,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    UserModel? currentUser,
    String? demoOtp,
    String? errorMessage,
    bool clearOtp = false,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      demoOtp: clearOtp ? null : demoOtp ?? this.demoOtp,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  late AuthRepository _repository;

  @override
  AuthState build() {
    _repository = AuthRepositoryImpl();
    return const AuthState();
  }

  Future<bool> login(LoginRequest request) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.login(request);
      state = state.copyWith(isLoading: false, currentUser: user);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.register(request);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
      return false;
    }
  }

  Future<bool> sendCode(PasswordResetRequest request) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final code = await _repository.sendPasswordResetCode(request);
      state = state.copyWith(isLoading: false, demoOtp: code);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
      return false;
    }
  }

  Future<bool> resetPassword(ResetPasswordRequest request) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.resetPassword(request);
      state = state.copyWith(isLoading: false, clearOtp: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
      return false;
    }
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
