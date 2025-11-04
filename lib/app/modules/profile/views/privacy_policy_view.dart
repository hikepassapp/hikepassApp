// lib/app/modules/profile/views/privacy_policy_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/privacy_header_widget.dart';
import '../widgets/privacy_content_widget.dart';
import '../widgets/privacy_action_button.dart';

class PrivacyPolicyView extends GetView<ProfileController> {
  const PrivacyPolicyView({super.key});

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
          'Kebijakan Privasi',
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
                    PrivacyHeaderWidget(),
                    SizedBox(height: 20),
                    PrivacyContentWidget(),
                    SizedBox(height: 80), // Space for button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PrivacyActionButtonWidget(),
    );
  }
}
