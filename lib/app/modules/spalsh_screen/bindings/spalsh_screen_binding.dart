import 'package:get/get.dart';

import '../controllers/spalsh_screen_controller.dart';

class SpalshScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpalshScreenController>(
      () => SpalshScreenController(),
    );
  }
}
