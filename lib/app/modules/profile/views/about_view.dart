// lib/app/modules/profile/views/about_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/about_header_widget.dart';
import '../widgets/about_content_widget.dart';
import '../widgets/about_action_button_widget.dart';

class AboutView extends GetView<ProfileController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D9B7F),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D9B7F),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Tentang Tiket Pendakian',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AboutHeaderWidget(),
                    SizedBox(height: 20),
                    AboutContentWidget(),
                    SizedBox(height: 80), // Space for button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AboutActionButtonWidget(),
    );
  }
}
