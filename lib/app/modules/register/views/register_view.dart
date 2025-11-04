// lib/app/modules/register/views/register_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/info_box_widget.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Daftar Akun',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Akun Hikepass!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Daftar akun hikepass untuk menikmati semua layanan dan fitur di hikepass',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Alamat Email',
                hint: 'Masukkan Alamat Email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const InfoBox(
                message: 'Pastikan email kamu aktif, yaa! kode verifikasi akun ke alamat yang akan dikirimkan',
              ),
              const Spacer(),
              Obx(() => CustomButton(
                text: 'Lanjutkan',
                onPressed: controller.registerEmail,
                isLoading: controller.isLoading.value,
              )),
            ],
          ),
        ),
      ),
    );
  }
}