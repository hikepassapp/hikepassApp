import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';

enum HikeType { checkIn, checkOut }

class HikingItem {
  final String id;
  final String title;
  final String subtitle;
  final DateTime startDate;
  final DateTime endDate;
  final String imagePath;
  final HikeType type;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  HikingItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startDate,
    required this.endDate,
    required this.imagePath,
    required this.type,
    this.checkInDate,
    this.checkOutDate,
  });

  HikingItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? startDate,
    DateTime? endDate,
    String? imagePath,
    HikeType? type,
    DateTime? checkInDate,
    DateTime? checkOutDate,
  }) {
    return HikingItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
    );
  }
}

class HikingController extends GetxController {
  final tabIndex = 0.obs;
  final TextEditingController listController = TextEditingController();
  final RxList<HikingItem> _allItems = <HikingItem>[].obs;

  // Item yang sedang diproses di form
  final Rxn<HikingItem> selectedItem = Rxn<HikingItem>();

  // Check-in form fields
  final RxList<bool> checkInCheckboxes = List.generate(6, (_) => false).obs;
  final RxString checkInItems = ''.obs;

  // Check-out form fields
  final RxList<bool> checkOutCheckboxes = List.generate(3, (_) => false).obs;
  final RxString checkOutItems = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _allItems.addAll([
      HikingItem(
        id: 'malabar-20251104',
        title: 'Puncak Besar Malabar',
        subtitle: 'Jalur Panorama',
        startDate: DateTime(2025, 11, 4),
        endDate: DateTime(2025, 11, 5),
        imagePath: 'assets/images/reservasi_panorama.png',
        type: HikeType.checkIn,
      ),
    ]);
  }

  List<HikingItem> get filtered {
    final type = tabIndex.value == 0 ? HikeType.checkIn : HikeType.checkOut;
    return _allItems.where((item) => item.type == type).toList();
  }

  bool get isCheckInValid =>
      checkInCheckboxes.every((checked) => checked) && checkInItems.trim().isNotEmpty;

  bool get isCheckOutValid =>
      checkOutCheckboxes.every((checked) => checked) && checkOutItems.trim().isNotEmpty;

  void switchTab(int index) {
    if (tabIndex.value != index) tabIndex.value = index;
  }

  // Set item yang akan diproses sebelum membuka form
  void selectItem(HikingItem item) {
    selectedItem.value = item;
  }

  // Submit dari form Check-In
  void submitCheckInAndGoToCheckout() {
    if (!isCheckInValid) {
      Get.snackbar('Perhatian', 'Mohon lengkapi semua persyaratan check-in',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final current = selectedItem.value;
    if (current != null) {
      final idx = _allItems.indexWhere((e) => e.id == current.id);
      if (idx != -1) {
        _allItems[idx] = _allItems[idx].copyWith(
          type: HikeType.checkOut,
          checkInDate: DateTime.now(),
        );
      }
      selectedItem.value = null;
    }

    // Reset form
    checkInCheckboxes.assignAll(List.generate(6, (_) => false));
    checkInItems.value = '';
    listController.clear();

    Get.back();

    Get.snackbar('Berhasil', 'Check-in berhasil dilakukan',
        backgroundColor: AppColors.primary, colorText: Colors.white);

    switchTab(1); // Pindah ke tab Check-Out
  }

  // Submit dari form Check-Out
  void submitCheckOutAndFinish() {
    if (!isCheckOutValid) {
      Get.snackbar('Perhatian', 'Mohon lengkapi semua persyaratan check-out',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final current = selectedItem.value;
    if (current != null) {
      final idx = _allItems.indexWhere((e) => e.id == current.id);
      if (idx != -1) {
        _allItems[idx] = _allItems[idx].copyWith(
          checkOutDate: DateTime.now(),
        );
        // Simpan ke history atau hapus (untuk sementara hapus)
        _allItems.removeAt(idx);
      }
      selectedItem.value = null;
    }

    // Reset form
    checkOutCheckboxes.assignAll(List.generate(3, (_) => false));
    checkOutItems.value = '';
    listController.clear();

    Get.back();

    Get.snackbar('Selesai', 'Check-out berhasil dicatat',
        backgroundColor: AppColors.primary, colorText: Colors.white);

    // Navigate to history (placeholder)
    // Get.toNamed(Routes.history);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
