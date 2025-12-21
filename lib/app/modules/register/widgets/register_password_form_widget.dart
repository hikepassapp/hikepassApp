import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import 'custom_text_field_widget.dart';
import 'custom_button_widget.dart';
import 'password_requirements_widget.dart';

class RegisterPasswordFormWidget extends GetView<RegisterController> {
  const RegisterPasswordFormWidget({super.key});

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
            'untuk keamanan data kamu, jangan lupa untuk tidak membagikan password kamu ke siapa pun',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          Obx(
            () => CustomTextField(
              label: 'Kata sandi',
              hint: 'Masukkan Password',
              controller: controller.passwordController,
              obscureText: controller.obscurePassword.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.obscurePassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ulang Kata Sandi',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              controller: controller.confirmPasswordController,
              obscureText: controller.obscureConfirmPassword.value,
              decoration: InputDecoration(
                hintText: 'Masukkan Password',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureConfirmPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF059669),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const PasswordRequirements(
            requirements: [
              'Minimal harus 8 karakter',
              'Gabungan huruf besar dan kecil',
              'Gunakan kombinasi huruf dan angka',
            ],
          ),
          const Spacer(),
          Obx(
            () => CustomButton(
              text: 'Simpan Kata Sandi',
              onPressed: controller.savePassword,
              isLoading: controller.isLoading.value,
            ),
          ),
        ],
      ),
    );
  }
}
