import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_menu_section_widget.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Header Background
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/imagesProfile.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Akun Saya',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(16, 80, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          ProfileMenuSectionWidget(
                            title: 'Pengaturan Akun',
                            items: [
                              ProfileMenuItem(
                                icon: Icons.person_outline,
                                title: 'Ubah Profil',
                                onTap: () => Get.toNamed('/edit-profile'),
                              ),
                              ProfileMenuItem(
                                icon: Icons.lock_outline,
                                title: 'Ubah Kata Sandi',
                                onTap: () => Get.toNamed('/change-password'),
                              ),
                              ProfileMenuItem(
                                icon: Icons.description_outlined,
                                title: 'Syarat dan Ketentuan',
                                onTap: () => Get.toNamed(Routes.terms),
                              ),
                              ProfileMenuItem(
                                icon: Icons.privacy_tip_outlined,
                                title: 'Kebijakan Privasi',
                                onTap: () => Get.toNamed(Routes.privacyPolicy),
                              ),
                            ],
                          ),

                          SizedBox(height: 24),

                          // Aktivitas Pendakian Section
                          ProfileMenuSectionWidget(
                            title: 'Aktivitas Pendakian',
                            items: [
                              ProfileMenuItem(
                                icon: Icons.info_outline,
                                title: 'Tentang Tiket Pendakian',
                                onTap: () => Get.toNamed(Routes.about),
                              ),
                            ],
                          ),

                          SizedBox(height: 24),

                          // Logout Button
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => controller.logout(),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      SizedBox(width: 16),
                                      Text(
                                        'Keluar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Profile Card Overlay
              Positioned(
                top: 140,
                left: 16,
                right: 16,
                child: Obx(
                  () => controller.isLoading.value
                      ? Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF26A69A),
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Avatar (Display Only)
                              Obx(
                                () => Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage:
                                        controller.avatarUrl.value.isNotEmpty
                                        ? NetworkImage(
                                            controller.avatarUrl.value,
                                          )
                                        : null,
                                    child: controller.avatarUrl.value.isEmpty
                                        ? Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.grey[600],
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              // User Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.namaLengkap.value.isNotEmpty
                                          ? controller.namaLengkap.value
                                          : 'User',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      controller.email.value.isNotEmpty
                                          ? controller.email.value
                                          : '-',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
