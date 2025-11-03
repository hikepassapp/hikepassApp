import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginPasswordFormWidget extends GetView<LoginController> {
  const LoginPasswordFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          'Untuk pengguna lama Hikepass, kamu bisa masuk dengan akun lama-mu. Jangan bagikan kata sandi anda kepada siapapun demi keamanan data anda.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        SizedBox(height: 32),
        
        // Password Label
        Text(
          'Kata Sandi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1a1a1a),
          ),
        ),
        SizedBox(height: 8),
        
        // Password Input
        Obx(() => TextField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: 'Masukkan Password',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey[600],
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF26A69A),
                    width: 2,
                  ),
                ),
              ),
            )),
        SizedBox(height: 12),
        
        // Forgot Password Link
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Get.toNamed('/forgot-password'),
            child: Text(
              'Lupa Kata Sandi',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF26A69A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        
        // Remember Me Checkbox
        Obx(() => Row(
              children: [
                Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: (value) => controller.toggleRememberMe(),
                  activeColor: Color(0xFF26A69A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Text(
                  'Ingat Saya',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            )),
        SizedBox(height: 24),
        
        // Submit Button
        SizedBox(
          width: double.infinity,
          child: Obx(() => ElevatedButton(
                onPressed: controller.isLoginLoading.value
                    ? null
                    : () => controller.login(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF26A69A),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoginLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Lanjutkan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              )),
        ),
      ],
    );
  }
}