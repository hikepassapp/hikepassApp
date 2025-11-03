import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
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

  void submitLaporan() {
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
    } else {
      Get.snackbar(
        'Success',
        'Laporan berhasil dikirim',
        colorText: Colors.white,
        backgroundColor: AppColors.primary,
      );
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(Routes.bottomNavigation);
      });
    }
  }
}
