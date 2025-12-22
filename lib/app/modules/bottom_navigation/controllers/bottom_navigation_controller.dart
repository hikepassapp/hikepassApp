import 'package:get/get.dart';
import 'package:hikepass_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:hikepass_app/app/modules/hiking/controllers/hiking_controller.dart';
import 'package:hikepass_app/app/modules/home/controllers/home_controller.dart';
import 'package:hikepass_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:hikepass_app/app/routes/app_pages.dart';

class BottomNavigationController extends GetxController {
  RxInt currentIndex = 0.obs;

  final screens = [Routes.home, Routes.chat, Routes.hiking, Routes.profile];

  @override
  void onInit() {
    super.onInit();
    // Use lazyPut with fenix to keep controllers alive
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => HikingController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }

  void setIndex(int index) {
    if (index == 1) {
      Get.toNamed(Routes.chat);
      return;
    }
    currentIndex.value = index;
  }

  @override
  void onClose() {
    // Clean up controllers when bottom navigation is closed
    Get.delete<HomeController>();
    Get.delete<ChatController>();
    Get.delete<HikingController>();
    Get.delete<ProfileController>();
    super.onClose();
  }
}
