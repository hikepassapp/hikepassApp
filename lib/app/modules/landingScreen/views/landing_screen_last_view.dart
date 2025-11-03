import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landing_screen_controller.dart';
// Impor Widgets
import '../widgets/landing_app_bar_widget.dart';
import '../widgets/landing_hero_card_widget.dart';
import '../widgets/landing_button_widget.dart';

import '../widgets/landing_button_widget.dart';
class LandingScreenLastView extends GetView<LandingScreenController> {
  const LandingScreenLastView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/landingLast.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundColor: Colors.grey, radius: 5),
                  SizedBox(width: 5),
                  CircleAvatar(backgroundColor: Colors.grey, radius: 5),
                  SizedBox(width: 5),
                  CircleAvatar(backgroundColor: Colors.white, radius: 5),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 390,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Jelajahi Petualangan Baru dengan Menjaga Gunung Tetap Lestari',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Masuk dan nikmati pengalaman yang terbaik'),
                      SizedBox(height: 20),
                      LandingButton(
                        text: 'Masuk Sebagai Pendaki',
                        onTap: controller.skip,
                        backgroundColor: const Color(0xFF179778),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
