import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  final selectedRole = ''.obs;

  void selectRole(String role) {
    selectedRole.value = role;

    if (role == 'pendaki') {
      // Navigate to pendaki login/register
      Get.toNamed('/pendaki/auth');
    } else if (role == 'pengelola') {
      // Navigate to pengelola login/register
      Get.toNamed('/pengelola/auth');
    }
  }
}
