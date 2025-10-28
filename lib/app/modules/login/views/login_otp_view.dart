import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_otp_app_bar_widget.dart';
import '../widgets/login_otp_content_widget.dart';

class LoginOtpView extends GetView<LoginController> {
  const LoginOtpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: LoginOtpAppBarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: LoginOtpContentWidget(),
        ),
      ),
    );
  }
}
