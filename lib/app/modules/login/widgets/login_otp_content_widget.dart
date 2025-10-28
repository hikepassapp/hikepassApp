import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginOtpContentWidget extends StatefulWidget {
  const LoginOtpContentWidget({super.key});

  @override
  State<LoginOtpContentWidget> createState() => _LoginOtpContentWidgetState();
}

class _LoginOtpContentWidgetState extends State<LoginOtpContentWidget> {
  final TextEditingController emailController = TextEditingController(
    text: 'youremail@gmail.com',
  );
  final TextEditingController otpController = TextEditingController();

  bool isOtpValid = false;
  String otpError = '';

  void validateOtp(String value) {
    if (value.length == 6) {
      setState(() {
        isOtpValid = true;
        otpError = '';
      });
    } else if (value.isNotEmpty) {
      setState(() {
        isOtpValid = false;
        otpError = 'Kode OTP harus terdiri dari 6 angka';
      });
    } else {
      setState(() {
        isOtpValid = false;
        otpError = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Deskripsi
        const Text(
          'Kami telah mengirimkan kode OTP ke email kamu',
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 10),

        // Email
        Text(
          emailController.text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 24),

        // Input OTP
        TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: validateOtp,
          decoration: InputDecoration(
            hintText: 'Masukkan Kode OTP',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        const SizedBox(height: 10),

        // Pesan error atau sukses
        if (otpError.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    otpError,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                  ),
                ),
              ],
            ),
          )
        else if (isOtpValid)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4CAF50)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF4CAF50), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Jangan bagikan kode ini kepada siapapun!',
                    style: TextStyle(color: Color(0xFF2E7D32), fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 32),

        // Tombol lanjutkan
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isOtpValid
                ? () {
                    Get.snackbar(
                      'Sukses',
                      'Kode OTP terverifikasi!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green[100],
                      colorText: Colors.green[900],
                    );

                    // Navigasi ke halaman utama (BottomNavigation)
                    Future.delayed(const Duration(seconds: 1), () {
                      Get.offAllNamed('/bottom-navigation');
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26A69A),
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
            ),
            child: const Text(
              'Lanjutkan',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
