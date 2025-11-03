// lib/app/modules/profile/views/terms_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/terms_header_widget.dart';
import '../widgets/terms_content_widget.dart';
import '../widgets/terms_action_button_widget.dart';

class TermsView extends GetView<ProfileController> {
  const TermsView({Key? key}) : super(key: key);

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
          'Syarat dan Ketentuan',
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
                    TermsHeaderWidget(),
                    SizedBox(height: 20),
                    TermsContentWidget(),
                    SizedBox(height: 80), // Space for button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: TermsActionButtonWidget(),
    );
  }
}
