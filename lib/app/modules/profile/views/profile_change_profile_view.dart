import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_change_header_widget.dart';
import '../widgets/profile_change_form_widget.dart';
import '../widgets/profile_change_confirmation_dialog_widget.dart';

class ProfileChangeProfileView extends GetView<ProfileController> {
  const ProfileChangeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ProfileChangeHeaderWidget(),
            SizedBox(height: 60),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: Color(0xFF26A69A)),
                  );
                }
                return ProfileChangeFormWidget(
                  onSubmit: () => _showConfirmationDialog(context),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    Get.dialog(
      ProfileChangeConfirmationDialogWidget(onConfirm: _updateProfile),
    );
  }

  void _updateProfile() async {
    try {
      // Call controller's updateProfile method
      final success = await controller.updateProfile();

      if (success) {
        // Success - navigate to profile page
        Get.back(); // Go back to profile page

        Get.snackbar(
          'Berhasil',
          'Profil berhasil diperbarui',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
          icon: Icon(Icons.check_circle, color: Colors.green[900]),
        );
      } else {
        // Failed - stay on edit page
        Get.snackbar(
          'Gagal',
          'Gagal memperbarui profil. Silakan coba lagi.',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
          icon: Icon(Icons.error, color: Colors.red[900]),
        );
      }
    } catch (e) {
      // Failed - stay on edit page
      Get.snackbar(
        'Gagal',
        'Gagal memperbarui profil. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.error, color: Colors.red[900]),
      );
    }
  }
}
