// lib/app/modules/register/views/password_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../widgets/register_password_app_bar_widget.dart';
import '../widgets/register_password_form_widget.dart';

class RegisterPasswordView extends GetView<RegisterController> {
  const RegisterPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available even if this view is opened directly
    if (!Get.isRegistered<RegisterController>()) {
      Get.put(RegisterController());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const RegisterPasswordAppBarWidget(),
      body: const SafeArea(child: RegisterPasswordFormWidget()),
    );
  }
}
