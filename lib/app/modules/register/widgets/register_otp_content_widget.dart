import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import 'custom_text_field_widget.dart';
import 'custom_button_widget.dart';
import 'info_box_widget.dart';

class RegisterOtpContentWidget extends GetView<RegisterController> {
  const RegisterOtpContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kami telah mengirimkan kode OTP ke email kamu',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            controller.emailController.text.isNotEmpty
                ? controller.emailController.text
                : 'youremail@gmail.com',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
    );
  }
}
