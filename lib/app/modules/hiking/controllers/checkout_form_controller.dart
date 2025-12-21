import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../models/hiking_model.dart';
import '../../../services/hiking_service.dart';

class CheckOutFormController extends GetxController {
  final HikingService _hikingService = Get.find<HikingService>();

  final Rxn<HikingModel> currentHiking = Rxn<HikingModel>();
  final RxList<bool> checkboxes = List.generate(3, (_) => false).obs;
  final TextEditingController itemsController = TextEditingController();
  final RxString items = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get hiking ID from route arguments
    final String? hikingId = Get.arguments as String?;
    if (hikingId != null) {
      final hiking = _hikingService.getHikingById(hikingId);
      if (hiking != null && hiking.checkOutDate == null) {
        _hikingService.processInitialCheckOut(hikingId);
      }

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

  void submitCheckOut() {
    if (!isFormValid) {
      Get.snackbar(
        'Perhatian',
        'Mohon lengkapi semua persyaratan check-out',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (currentHiking.value != null) {
      // Save check-out data
      _hikingService.processCheckOutForm(
        hikingId: currentHiking.value!.id,
        checkOutItems: items.value,
        checkOutCheckboxes: checkboxes.toList(),
      );

      // Complete check-out and prepare history data
      final historyData = _hikingService.completeCheckOut(
        currentHiking.value!.id,
      );

      if (historyData != null) {
        // Navigate to history feature
        // TODO: Pass historyData to history feature when it's ready
        Get.offAllNamed(Routes.riwayat);

        Get.snackbar(
          'Selesai',
          'Check-out berhasil dicatat',
          backgroundColor: const Color(0xFF179778),
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void onClose() {
    itemsController.dispose();
    super.onClose();
  }
}
