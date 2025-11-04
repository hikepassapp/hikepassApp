import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_email_content_widget.dart';
import '../widgets/login_help_widget.dart';

class LoginEmailView extends GetView<LoginController> {
  const LoginEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                child: Image.asset(
                  'assets/images/imgonBoarding.png',
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top:
                    MediaQuery.of(context).padding.top + 8, // nambah jarak aman
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      Get.offAllNamed(Routes.LANDING_SCREEN);
                    }
                  },
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(child: LoginEmailContentWidget()),
              ),
            ),
          ),

          const LoginHelpWidget(),
        ],
      ),
    );
  }
}
