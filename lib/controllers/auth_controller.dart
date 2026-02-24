import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    currentUser.value = await _authService.getCurrentUser();
    isLoading.value = false;
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      currentUser.value = user;
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar('Error', 'Failed to sign in');
    }
    isLoading.value = false;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    currentUser.value = null;
    Get.offAllNamed('/login');
  }
}
