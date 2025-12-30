import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/services/riwayat_service.dart';
import '../../../routes/app_pages.dart';
import '../../../models/hiking_model.dart';
import '../../../services/hiking_service.dart';
import '../../reservasi/controllers/reservasi_controller.dart';
import 'hiking_controller.dart';

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

  Future<void> submitCheckIn() async {
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
      print('🏔️ === Starting Check-In Process ===');
      
      // ✨ 1. Process check-in form (updates hiking table)
      await _hikingService.processCheckInForm(
        hikingId: currentHiking.value!.id,
        checkInItems: items.value,
        checkInCheckboxes: checkboxes.toList(),
      );
      print('✅ Step 1: Hiking table updated');

      // ✨ 2. Refresh hiking service to get latest data
      await _hikingService.loadFromSupabase();
      print('✅ Step 2: Hiking data refreshed');

      // ✨ 3. Get updated hiking with checkInDate
      final updatedHiking = _hikingService.getHikingById(currentHiking.value!.id);
      print('📋 Updated hiking data:');
      print('   CheckInDate: ${updatedHiking?.checkInDate}');
      print('   ReservasiId: ${updatedHiking?.reservasiId}');
      
      // ✨ 4. Update riwayat table dengan checkInDate
      if (updatedHiking != null && updatedHiking.checkInDate != null) {
        final riwayatService = Get.isRegistered<RiwayatService>()
            ? Get.find<RiwayatService>()
            : Get.put(RiwayatService(), permanent: true);
        
        try {
          // Update checkInDate di tabel riwayat
          await riwayatService.updateCheckInDate(
            updatedHiking.reservasiId,
            updatedHiking.checkInDate!,
          );
          print('✅ Step 3: Riwayat table updated with checkInDate');
        } catch (e) {
          print('⚠️ Error updating riwayat checkInDate: $e');
        }
      }

      // ✨ 5. Update data di ReservasiController
      if (updatedHiking != null) {
        try {
          final reservasiC = Get.find<ReservasiController>();
          final idx = reservasiC.riwayat.indexWhere(
            (item) => (item['id'] ?? '') == updatedHiking.reservasiId,
          );

          if (idx != -1) {
            reservasiC.riwayat[idx]['checkInDate'] = updatedHiking.checkInDate;
            reservasiC.riwayat[idx]['hikingStatus'] = 'hiking';
            print('✅ Step 4: ReservasiController updated');
          }
        } catch (e) {
          print('⚠️ Error updating reservasi: $e');
        }
      }

      // ✨ 6. Refresh riwayat service
      if (Get.isRegistered<RiwayatService>()) {
        final riwayatService = Get.find<RiwayatService>();
        await riwayatService.loadFromSupabase();
        print('✅ Step 5: Riwayat data refreshed from database');
      }

      // ✨ 7. Ensure HikingController exists
      if (!Get.isRegistered<HikingController>()) {
        try {
          Get.put(HikingController(), permanent: true);
        } catch (_) {}
      }

      print('🎉 === Check-In Process Complete ===');
      
      // ✨ 8. Navigate to hiking tab
      Get.offAllNamed(Routes.hiking, arguments: {'tab': 1});

      Get.snackbar(
        'Berhasil',
        'Check-in berhasil! Status berubah ke Mendaki',
        backgroundColor: Colors.green,
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