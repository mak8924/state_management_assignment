import 'package:get/get.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/password_reset_request.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  AuthController({required this._repository});
  final AuthRepository _repository;

  final isLoading = false.obs;
  final currentUser = Rxn<UserModel>();
  final demoOtp = RxnString();

  void _error(Object e) {
    Get.snackbar('Error', e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<bool> login(LoginRequest request) async {
    isLoading.value = true;
    try {
      currentUser.value = await _repository.login(request);
      return true;
    } catch (e) {
      _error(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    isLoading.value = true;
    try {
      await _repository.register(request);
      return true;
    } catch (e) {
      _error(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendCode(PasswordResetRequest request) async {
    isLoading.value = true;
    try {
      demoOtp.value = await _repository.sendPasswordResetCode(request);
      return true;
    } catch (e) {
      _error(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetPassword(ResetPasswordRequest request) async {
    isLoading.value = true;
    try {
      await _repository.resetPassword(request);
      demoOtp.value = null;
      return true;
    } catch (e) {
      _error(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
