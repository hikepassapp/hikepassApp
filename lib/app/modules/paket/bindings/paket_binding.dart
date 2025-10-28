import 'package:get/get.dart';

import '../controllers/paket_controller.dart';

class PaketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaketController>(
      () => PaketController(),
    );
  }
}
