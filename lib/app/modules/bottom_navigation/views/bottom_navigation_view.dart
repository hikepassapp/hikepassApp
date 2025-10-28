import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/modules/home/controllers/home_controller.dart';
import '../../hiking/controllers/hiking_controller.dart';
import '../../hiking/views/hiking_view.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';
import '../../home/views/home_view.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/bottom_navigation_controller.dart';

class BottomNavigationView extends GetView<BottomNavigationController> {
  const BottomNavigationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          switch (controller.currentIndex.value) {
            case 0:
              if (!Get.isRegistered<HomeController>()) {
                Get.lazyPut(() => HomeController());
              }
              return const HomeView();
            case 1:
            case 2:
              if (!Get.isRegistered<HikingController>()) {
                Get.lazyPut(() => HikingController());
              }
              return const HikingView();
            case 3:
              if (!Get.isRegistered<ProfileController>()) {
                Get.lazyPut(() => ProfileController());
              }
              return const ProfileView();
            default:
              if (!Get.isRegistered<HomeController>()) {
                Get.lazyPut(() => HomeController());
              }
              return const HomeView();
          }
        }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(
            () => BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: controller.currentIndex.value,
              selectedLabelStyle: AppTypography.sMedium,
              unselectedLabelStyle: AppTypography.sRegular,
              unselectedItemColor: AppColors.gray,
              selectedItemColor: AppColors.primary,
              type: BottomNavigationBarType.fixed,
              onTap: (index) => controller.setIndex(index),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            controller.currentIndex.value == 0
                                ? 'assets/icons/home.png'
                                : 'assets/icons/unhome.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            controller.currentIndex.value == 1
                                ? 'assets/icons/chat.png'
                                : 'assets/icons/unchat.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  label: 'Pesan',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            controller.currentIndex.value == 2
                                ? 'assets/icons/hike.png'
                                : 'assets/icons/unhike.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  label: 'Pendakian',
                ),

                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            controller.currentIndex.value == 3
                                ? 'assets/icons/profile.png'
                                : 'assets/icons/unprofile.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
