import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../models/hiking_model.dart';
import '../../../services/hiking_service.dart';
import '../../../services/riwayat_service.dart';

class CheckOutFormController extends GetxController {
  final HikingService _hikingService = Get.find<HikingService>();

  final Rxn<HikingModel> currentHiking = Rxn<HikingModel>();
  final RxList<bool> checkboxes = List.generate(3, (_) => false).obs;
  final TextEditingController itemsController = TextEditingController();
  final RxString items = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final String? hikingId = Get.arguments as String?;
    if (hikingId != null) {
      final hiking = _hikingService.getHikingById(hikingId);
      if (hiking != null && hiking.checkOutDate == null) {
        _hikingService.processInitialCheckOut(hikingId);
      }

      currentHiking.value = _hikingService.getHikingById(hikingId);
      
    }

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
      _hikingService.processCheckOutForm(
        hikingId: currentHiking.value!.id,
        checkOutItems: items.value,
        checkOutCheckboxes: checkboxes.toList(),
      );

      final historyData = _hikingService.completeCheckOut(
        currentHiking.value!.id,
      );

      if (historyData != null) {
        // Ensure RiwayatService available then store the new history item
        final riwayatService = Get.isRegistered<RiwayatService>()
            ? Get.find<RiwayatService>()
            : Get.put(RiwayatService(), permanent: true);
        riwayatService.addFromHikingHistory(historyData);

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
