import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../models/hiking_model.dart';
import '../../../services/hiking_service.dart';

class CheckInFormController extends GetxController {
  late final HikingService _hikingService;

  final Rxn<HikingModel> currentHiking = Rxn<HikingModel>();
  final RxList<bool> checkboxes = List.generate(6, (_) => false).obs;
  final TextEditingController itemsController = TextEditingController();
  final RxString items = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _hikingService = Get.isRegistered<HikingService>()
        ? Get.find<HikingService>()
        : Get.put(HikingService(), permanent: true);
    final String? hikingId = Get.arguments as String?;
    if (hikingId != null) {
      final hiking = _hikingService.getHikingById(hikingId);
      if (hiking != null && hiking.checkInDate == null) {
        _hikingService.processInitialCheckIn(hikingId);
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
      _hikingService.processCheckInForm(
        hikingId: currentHiking.value!.id,
        checkInItems: items.value,
        checkInCheckboxes: checkboxes.toList(),
      );

      Get.offAllNamed(
        Routes.hiking,
        arguments: {'tab': 1},
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
