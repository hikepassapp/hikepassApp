import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_change_password_app_bar_widget.dart';
import '../widgets/profile_change_password_form_widget.dart';

class ProfileChangePasswordView extends GetView<ProfileController> {
  const ProfileChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProfileChangePasswordAppBarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(child: ProfileChangePasswordFormWidget()),
      ),
    );
  }
}
