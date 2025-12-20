import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/routes/app_pages.dart';

class HikingHeader extends StatelessWidget {
  const HikingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/hiking.jpg',
            fit: BoxFit.cover,
          ),
          // Overlay gelap tipis
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Tombol back
          Positioned(
            top: 12,
            left: 12,
            child: IconButton(
              onPressed: () => Get.offAllNamed(Routes.bottomNavigation),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          // Judul
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Pendakian!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Kelola pendakianmu disini!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
