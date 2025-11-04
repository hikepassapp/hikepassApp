import 'package:get/get.dart';

import '../controllers/hiking_controller.dart';

class HikingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HikingController>(
      () => HikingController(),
    );
  }
}