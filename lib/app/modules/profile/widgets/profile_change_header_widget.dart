import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileChangeHeaderWidget extends GetView<ProfileController> {
  const ProfileChangeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Image
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
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),

        // Back Button
        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),

        // Title
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Ubah Profil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Avatar
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                print('=== Avatar Area Tapped ===');
                if (!controller.isUploadingAvatar.value) {
                  controller.showImagePickerOptions();
                }
              },
              child: Obx(
                () => Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFF26A69A), width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 58,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: controller.avatarUrl.value.isNotEmpty
                            ? NetworkImage(controller.avatarUrl.value)
                            : null,
                        child: controller.avatarUrl.value.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                    ),
                    if (controller.isUploadingAvatar.value)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ),
                    if (!controller.isUploadingAvatar.value)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(0xFF26A69A),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
