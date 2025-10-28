// lib/app/modules/register/bindings/register_binding.dart

import 'package:get/get.dart';
import '../controllers/register_controller.dart';

// ini binding
class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
