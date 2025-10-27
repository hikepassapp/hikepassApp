import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LaporanController extends GetxController {
  final namaPelaporController = TextEditingController();
  final tanggalController = TextEditingController();
  final lokasiController = TextEditingController();
  final deskripsiController = TextEditingController();
  final fotoController = TextEditingController();

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
    // Implementasi pick image
    // Gunakan package image_picker
    Get.snackbar('Info', 'Fungsi pick image');
  }

  void submitLaporan() {
    if (namaPelaporController.text.isEmpty) {
      Get.snackbar('Error', 'Nama pelapor harus diisi');
      return;
    }
    if (tanggalController.text.isEmpty) {
      Get.snackbar('Error', 'Tanggal kejadian harus diisi');
      return;
    }
    if (lokasiController.text.isEmpty) {
      Get.snackbar('Error', 'Lokasi kejadian harus diisi');
      return;
    }
    if (deskripsiController.text.isEmpty) {
      Get.snackbar('Error', 'Deskripsi kejadian harus diisi');
      return;
    }

    // Proses submit laporan
    Get.snackbar('Success', 'Laporan berhasil dikirim');
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