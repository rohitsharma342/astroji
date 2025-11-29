import 'package:get/get.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  void checkAuthStatus() {
    isLoading.value = true;
    
    Future.delayed(const Duration(seconds: 1), () {
      currentUser.value = User(
        id: 'user_1',
        name: 'John Doe',
        email: 'john.doe@email.com',
        phone: '+91 9876543210',
        dateOfBirth: DateTime(1990, 5, 15),
        timeOfBirth: '10:30 AM',
        placeOfBirth: 'Mumbai, India',
      );
      isLoggedIn.value = true;
      isLoading.value = false;
    });
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      currentUser.value = User(
        id: 'user_1',
        name: 'John Doe',
        email: email,
        phone: '+91 9876543210',
        dateOfBirth: DateTime(1990, 5, 15),
        timeOfBirth: '10:30 AM',
        placeOfBirth: 'Mumbai, India',
      );
      isLoggedIn.value = true;
      Get.snackbar('Success', 'Login successful');
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.snackbar('Success', 'Logged out successfully');
  }
}