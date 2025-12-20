// lib/app/modules/register/views/fill_data_register_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../widgets/fill_data_register_app_bar_widget.dart';
import '../widgets/fill_data_register_form_widget.dart';

class FillDataRegisterView extends GetView<RegisterController> {
  const FillDataRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const FillDataRegisterAppBarWidget(),
      body: const SafeArea(
        child: SingleChildScrollView(child: FillDataRegisterFormWidget()),
      ),
    );
  }
}
