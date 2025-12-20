import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_otp_reset_password_app_bar_widget.dart';
import '../widgets/login_otp_reset_password_content_widget.dart';

class LoginOtpResetPasswordView extends GetView<LoginController> {
  const LoginOtpResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: LoginOtpResetPasswordAppBarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: LoginOtpResetPasswordContentWidget(),
        ),
      ),
    );
  }
}
