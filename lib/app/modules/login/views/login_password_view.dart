import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_password_app_bar_widget.dart';
import '../widgets/login_password_form_widget.dart';

class LoginPasswordView extends GetView<LoginController> {
  const LoginPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: LoginPasswordAppBarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: LoginPasswordFormWidget(),
        ),
      ),
    );
  }
}