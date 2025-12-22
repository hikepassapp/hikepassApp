import 'package:get/get.dart';
import '../../../models/informasi_model.dart';
import '../../../repositories/informasi_repository.dart';
import 'package:flutter/foundation.dart';

class InformasiController extends GetxController {
  final InformasiRepository _informasiRepository = InformasiRepository();

  // Current tab index
  final currentTabIndex = 0.obs;

  // Data untuk setiap kategori
  final Rx<InformasiModel?> peraturanData = Rx<InformasiModel?>(null);
  final Rx<InformasiModel?> tipsData = Rx<InformasiModel?>(null);
  final Rx<InformasiModel?> umumData = Rx<InformasiModel?>(null);

  // Loading states
  final isLoadingPeraturan = true.obs;
  final isLoadingTips = true.obs;
  final isLoadingUmum = true.obs;

  // Error messages
  final peraturanErrorMessage = ''.obs;
  final tipsErrorMessage = ''.obs;
  final umumErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllInformasi();
  }

  // Load semua informasi sekaligus
  Future<void> loadAllInformasi() async {
    await Future.wait([
      loadPeraturan(),
      loadTips(),
      loadUmum(),
    ]);
  }

  // Load Peraturan
  Future<void> loadPeraturan() async {
    try {
      isLoadingPeraturan.value = true;
      peraturanErrorMessage.value = '';

      debugPrint('🔄 Fetching Peraturan...');

      final data = await _informasiRepository.getInformasiByKategori('peraturan');
      
      if (data != null) {
        peraturanData.value = data;
        debugPrint('✅ Peraturan loaded: ${data.contents.length} items');
      } else {
        debugPrint('⚠️ No Peraturan data found');
      }

      isLoadingPeraturan.value = false;
    } catch (e) {
      isLoadingPeraturan.value = false;
      peraturanErrorMessage.value = e.toString();

      debugPrint('❌ Error Peraturan: ${e.toString()}');

      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Gagal memuat data peraturan: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  // Load Tips
  Future<void> loadTips() async {
    try {
      isLoadingTips.value = true;
      tipsErrorMessage.value = '';

      debugPrint('🔄 Fetching Tips...');

      final data = await _informasiRepository.getInformasiByKategori('tips');
      
      if (data != null) {
        tipsData.value = data;
        debugPrint('✅ Tips loaded: ${data.contents.length} items');
      } else {
        debugPrint('⚠️ No Tips data found');
      }

      isLoadingTips.value = false;
    } catch (e) {
      isLoadingTips.value = false;
      tipsErrorMessage.value = e.toString();

      debugPrint('❌ Error Tips: ${e.toString()}');

      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Gagal memuat data tips: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  // Load Umum
  Future<void> loadUmum() async {
    try {
      isLoadingUmum.value = true;
      umumErrorMessage.value = '';

      debugPrint('🔄 Fetching Umum...');

      final data = await _informasiRepository.getInformasiByKategori('umum');
      
      if (data != null) {
        umumData.value = data;
        debugPrint('✅ Umum loaded: ${data.contents.length} items');
      } else {
        debugPrint('⚠️ No Umum data found');
      }

      isLoadingUmum.value = false;
    } catch (e) {
      isLoadingUmum.value = false;
      umumErrorMessage.value = e.toString();

      debugPrint('❌ Error Umum: ${e.toString()}');

      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Gagal memuat data umum: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  // Refresh data berdasarkan tab yang aktif
  Future<void> refreshCurrentTab() async {
    switch (currentTabIndex.value) {
      case 0:
        await loadPeraturan();
        break;
      case 1:
        await loadTips();
        break;
      case 2:
        await loadUmum();
        break;
    }
  }

  // Refresh semua data
  Future<void> refreshAllData() async {
    await loadAllInformasi();
  }

  // Change tab
  void onTabChanged(int index) {
    currentTabIndex.value = index;
  }

  // Get current data based on tab
  InformasiModel? get currentData {
    switch (currentTabIndex.value) {
      case 0:
        return peraturanData.value;
      case 1:
        return tipsData.value;
      case 2:
        return umumData.value;
      default:
        return peraturanData.value;
    }
  }

  // Get current loading state
  bool get isCurrentTabLoading {
    switch (currentTabIndex.value) {
      case 0:
        return isLoadingPeraturan.value;
      case 1:
        return isLoadingTips.value;
      case 2:
        return isLoadingUmum.value;
      default:
        return false;
    }
  }

  // Get current error message
  String get currentErrorMessage {
    switch (currentTabIndex.value) {
      case 0:
        return peraturanErrorMessage.value;
      case 1:
        return tipsErrorMessage.value;
      case 2:
        return umumErrorMessage.value;
      default:
        return '';
    }
  }

  // Check if current tab has data
  bool get hasCurrentData {
    final data = currentData;
    return data != null && data.contents.isNotEmpty;
  }
}