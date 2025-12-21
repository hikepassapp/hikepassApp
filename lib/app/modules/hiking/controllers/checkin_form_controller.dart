import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/hiking_model.dart';
import '../../../services/hiking_service.dart';

class CheckInFormController extends GetxController {
  final HikingService _hikingService = Get.find<HikingService>();

  final Rxn<HikingModel> currentHiking = Rxn<HikingModel>();
  final RxList<bool> checkboxes = List.generate(6, (_) => false).obs;
  final TextEditingController itemsController = TextEditingController();
  final RxString items = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get hiking ID from route arguments
    final String? hikingId = Get.arguments as String?;
    if (hikingId != null) {
      currentHiking.value = _hikingService.getHikingById(hikingId);
    }

    // Listen to text changes
    itemsController.addListener(() {
      items.value = itemsController.text;
    });
  }

  bool get isFormValid =>
      checkboxes.every((checked) => checked) && items.trim().isNotEmpty;

  void toggleCheckbox(int index, bool? value) {
    if (index >= 0 && index < checkboxes.length) {
      checkboxes[index] = value ?? false;
    }
  }

  void submitCheckIn() {
    if (!isFormValid) {
      Get.snackbar(
        'Perhatian',
        'Mohon lengkapi semua persyaratan check-in',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (currentHiking.value != null) {
      // Save check-in data
      _hikingService.processCheckInForm(
        hikingId: currentHiking.value!.id,
        checkInItems: items.value,
        checkInCheckboxes: checkboxes.toList(),
      );

      // Navigate to initial check-out page
      Get.offNamed(
        '/hiking/initial-checkout',
        arguments: currentHiking.value!.id,
      );

      Get.snackbar(
        'Berhasil',
        'Check-in berhasil dilakukan',
        backgroundColor: const Color(0xFF179778),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    itemsController.dispose();
    super.onClose();
  }
}
