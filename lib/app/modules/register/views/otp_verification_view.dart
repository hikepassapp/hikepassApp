// lib/app/modules/register/views/otp_verification_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../widgets/register_otp_app_bar_widget.dart';
import '../widgets/register_otp_content_widget.dart';

class RegisterOtpVerificationView extends GetView<RegisterController> {
  const RegisterOtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure RegisterController is registered so `controller` (GetView) won't throw
    if (!Get.isRegistered<RegisterController>()) {
      Get.put(RegisterController());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const RegisterOtpAppBarWidget(),
      body: const SafeArea(child: RegisterOtpContentWidget()),
    );
  }
}
