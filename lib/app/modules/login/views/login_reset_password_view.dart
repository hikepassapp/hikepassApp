import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_reset_password_app_bar_widget.dart';
import '../widgets/login_reset_password_form_widget.dart';

class LoginResetPasswordView extends GetView<LoginController> {
  const LoginResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: LoginResetPasswordAppBarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(child: LoginResetPasswordFormWidget()),
      ),
    );
  }
}
