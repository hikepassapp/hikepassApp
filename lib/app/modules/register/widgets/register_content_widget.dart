import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import 'custom_text_field_widget.dart';
import 'custom_button_widget.dart';
import 'info_box_widget.dart';

class RegisterContentWidget extends GetView<RegisterController> {
  const RegisterContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Akun Hikepass!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Daftar akun hikepass untuk menikmati semua layanan dan fitur di hikepass',
            style: TextStyle(fontSize: 14, color: Colors.black54),
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
            message:
                'Pastikan email kamu aktif, yaa! kode verifikasi akun ke alamat yang akan dikirimkan',
          ),
          const Spacer(),
          Obx(
            () => CustomButton(
              text: 'Lanjutkan',
              onPressed: controller.registerEmail,
              isLoading: controller.isLoading.value,
            ),
          ),
        ],
      ),
    );
  }
}
