// lib/app/modules/register/views/otp_verification_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/info_box_widget.dart';

class RegisterOtpVerificationView extends GetView<RegisterController> {
  const RegisterOtpVerificationView({Key? key}) : super(key: key);

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
          'Verifikasi OTP',
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
                'Kami telah mengirimkan kode OTP ke email kamu',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  controller.emailController.text.isNotEmpty
                      ? controller.emailController.text
                      : 'youremail@gmail.com',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: '',
                hint: 'Masukkan Kode OTP',
                controller: controller.otpController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const InfoBox(message: 'Jangan bagikan kode ini kepada siapapun'),
              const Spacer(),
              Obx(
                () => CustomButton(
                  text: 'Daftar',
                  onPressed: controller.verifyOTP,
                  isLoading: controller.isLoading.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
