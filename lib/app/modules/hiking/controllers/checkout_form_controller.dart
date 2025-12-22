import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../models/hiking_model.dart';
import '../../../services/hiking_service.dart';
import '../../../services/riwayat_service.dart';
import '../../reservasi/controllers/reservasi_controller.dart';

class CheckOutFormController extends GetxController {
  late final HikingService _hikingService;

  final Rxn<HikingModel> currentHiking = Rxn<HikingModel>();
  final RxList<bool> checkboxes = List.generate(3, (_) => false).obs;
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

  Future<void> submitCheckOut() async {
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

      final historyData = await _hikingService.completeCheckOut(
        currentHiking.value!.id,
      );

      if (historyData != null) {
        try {
          final reservasiC = Get.find<ReservasiController>();
          final idx = reservasiC.riwayat.indexWhere(
            (item) => (item['id'] ?? '') == historyData['reservasiId'],
          );

          if (idx != -1) {
            final pending = reservasiC.riwayat[idx];
            historyData['reservasiCode'] = pending['code'];
            historyData['paymentCode'] = pending['paymentCode'];
            historyData['paymentDate'] = pending['paymentDate']?.toString();
            historyData['ticketPrice'] = pending['ticketPrice'];
            historyData['hikers'] = pending['hikers'];
            historyData['mountainName'] = pending['mountainName'];
            historyData['hikingTrail'] = pending['hikingTrail'];

            reservasiC.riwayat.removeAt(idx);
          } else {
            reservasiC.riwayat.removeWhere(
              (item) => (item['id'] ?? '') == historyData['reservasiId'],
            );
          }
        } catch (_) {

        }

        final riwayatService = Get.isRegistered<RiwayatService>()
            ? Get.find<RiwayatService>()
            : Get.put(RiwayatService(), permanent: true);
        final userId = historyData['userId'] as String?;
        await riwayatService.addFromHikingHistory(historyData, userId: userId);

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
