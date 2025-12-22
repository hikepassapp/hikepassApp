import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/models/laporan_model.dart';
import 'package:hikepass_app/app/services/laporan_service.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/theme/app_typography.dart';

class LaporanController extends GetxController {
  final namaPelaporController = TextEditingController();
  final tanggalController = TextEditingController();
  final lokasiController = TextEditingController();
  final deskripsiController = TextEditingController();
  final fotoController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  final LaporanService _laporanService = LaporanService();
  
  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isLoading = false.obs;
  DateTime? selectedDate;

  // Properties for list management
  RxList<LaporanModel> laporanList = <LaporanModel>[].obs;
  RxBool isLoadingList = false.obs;
  RxString listErrorMessage = ''.obs;

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate = picked;
      tanggalController.text =
          '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
    }
  }

  void pickImage() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('Pilih dari Galeri', style: AppTypography.lMedium),
              onTap: () {
                Get.back();
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('Ambil Foto', style: AppTypography.lMedium),
              onTap: () {
                Get.back();
                _pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 85,
        );

        if (image != null) {
          selectedImage.value = File(image.path);
          fotoController.text = image.name;
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal memilih foto',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    var status = await Permission.camera.request();

    if (status.isGranted) {
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 85,
        );

        if (image != null) {
          selectedImage.value = File(image.path);
          fotoController.text = image.name;
          Get.snackbar('Berhasil', 'Foto berhasil diambil');
        }
      } catch (e) {
        Get.snackbar('Error', 'Gagal mengambil foto');
      }
    } else {
      Get.snackbar('Error', 'Permission kamera ditolak');
    }
  }

  Future<void> submitLaporan() async {
    if (namaPelaporController.text.isEmpty ||
        tanggalController.text.isEmpty ||
        lokasiController.text.isEmpty ||
        deskripsiController.text.isEmpty ||
        fotoController.text.isEmpty) {
      Get.snackbar(
        'Laporan tidak lengkap',
        'Silahkan lengkapi semua data',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (selectedDate == null) {
      Get.snackbar(
        'Error',
        'Tanggal kejadian tidak valid',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;
      String? fotoUrl;
      if (selectedImage.value != null) {
        fotoUrl = await _laporanService.uploadFoto(selectedImage.value!);
      }
      final laporan = LaporanModel(
        namaPelapor: namaPelaporController.text.trim(),
        tanggalKejadian: selectedDate!,
        lokasiKejadian: lokasiController.text.trim(),
        deskripsiKejadian: deskripsiController.text.trim(),
        fotoUrl: fotoUrl,
      );

      // Simpan ke database
      await _laporanService.createLaporan(laporan);

      Get.snackbar(
        'Success',
        'Laporan berhasil dikirim',
        colorText: Colors.white,
        backgroundColor: AppColors.primary,
      );
      _resetForm();
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(Routes.laporanList);
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim laporan: ${e.toString()}',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // List management methods
  Future<void> loadAllLaporan() async {
    try {
      isLoadingList.value = true;
      listErrorMessage.value = '';
      
      final laporan = await _laporanService.getAllLaporan();
      laporanList.value = laporan;
    } catch (e) {
      listErrorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat laporan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> refreshLaporan() async {
    await loadAllLaporan();
  }

  void navigateToDetail(LaporanModel laporan) {
    Get.toNamed(
      Routes.laporanDetail, // Make sure this route exists in your app_pages.dart
      arguments: laporan,
    );
  }

  void _resetForm() {
    namaPelaporController.clear();
    tanggalController.clear();
    lokasiController.clear();
    deskripsiController.clear();
    fotoController.clear();
    selectedImage.value = null;
    selectedDate = null;
  }

  @override
  void onClose() {
    namaPelaporController.dispose();
    tanggalController.dispose();
    lokasiController.dispose();
    deskripsiController.dispose();
    fotoController.dispose();
    super.onClose();
  }
}