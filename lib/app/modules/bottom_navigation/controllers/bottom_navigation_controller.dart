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
    
    // Handle initialIndex argument (e.g., from payment success page)
    final args = Get.arguments;
    if (args is Map && args['initialIndex'] != null) {
      final initialIndex = args['initialIndex'] as int;
      currentIndex.value = initialIndex;
    }
  }

  void setIndex(int index) {
    if (index == 1) {
      Get.toNamed(Routes.chat);
      return;
    }
    currentIndex.value = index;
    
    // Refresh hiking data when switching to hiking tab (index 2)
    if (index == 2 && Get.isRegistered<HikingController>()) {
      final hikingController = Get.find<HikingController>();
      hikingController.refreshHikingData();
    }
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
