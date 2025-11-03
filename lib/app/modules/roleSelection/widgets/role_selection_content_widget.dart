import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/role_selection_controller.dart';
import 'role_button_widget.dart';

class RoleSelectionContentWidget extends GetView<RoleSelectionController> {
  const RoleSelectionContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicator bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 24),
            
            // Title
            Text(
              'Jelajahi Petualangan Baru dengan Menjaga Gunung Tetap Lestari.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1a1a1a),
                height: 1.3,
              ),
            ),
            SizedBox(height: 12),
            
            // Subtitle
            Text(
              'Masuk dan nikmati pengalaman yang terbaik',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: 32),
            
            // Role Buttons
            RoleButtonWidget(
              title: 'Masuk Sebagai Pendaki',
              backgroundColor: Color(0xFF004D40),
              onTap: () => controller.selectRole('pendaki'),
            ),
            SizedBox(height: 16),
            
            RoleButtonWidget(
              title: 'Masuk Sebagai Pengelola',
              backgroundColor: Color(0xFF26A69A),
              onTap: () => controller.selectRole('pengelola'),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}