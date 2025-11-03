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
    Get.put(HomeController());
    Get.put(ChatController());
    Get.put(HikingController());
    Get.put(ProfileController());
  }

  void setIndex(int index) {
    if (index == 1) {
      Get.toNamed(Routes.chat);
      return;
    }
    currentIndex.value = index;
  }
}
