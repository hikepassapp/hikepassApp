// lib/app/modules/register/views/register_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../widgets/register_app_bar_widget.dart';
import '../widgets/register_content_widget.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const RegisterAppBarWidget(),
      body: const SafeArea(child: RegisterContentWidget()),
    );
  }
}
