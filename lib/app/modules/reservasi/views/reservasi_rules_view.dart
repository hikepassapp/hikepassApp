import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';
import '../widgets/confirmation_checkbox_widget.dart';
import '../widgets/permit_time_widget.dart';
import '../widgets/rules_header_widget.dart';
import '../widgets/rules_list_widget.dart';
import 'hikers_list_view.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'package:hikepass_app/app/shared/theme/app_typography.dart';

class ReservasiRulesView extends GetView<ReservasiController> {
  const ReservasiRulesView({super.key});

  void _handleContinuePressed(Map<String, dynamic> data) {
    if (!controller.isAgreed.value) {
      Get.snackbar(
        'Persetujuan Diperlukan',
        'Harap setuju dengan semua peraturan SOP sebelum melanjutkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    Get.to(() => const HikersListView(), arguments: data);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          'Aturan Pendakian',
          style: AppTypography.h3.copyWith(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: AppColors.secondary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      RulesHeader(),
                      SizedBox(height: 12),
                      RulesList(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const PermitTimeCard(),
                const SizedBox(height: 20),
                const ConfirmationCheckbox(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isAgreed.value
                  ? () => _handleContinuePressed(
                      Get.arguments as Map<String, dynamic>,
                    )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.isAgreed.value
                    ? AppColors.secondary
                    : Colors.grey[400],
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Lanjutkan',
                style: TextStyle(
                  color: controller.isAgreed.value
                      ? Colors.white
                      : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
