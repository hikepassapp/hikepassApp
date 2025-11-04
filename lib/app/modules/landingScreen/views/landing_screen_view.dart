import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/landing_screen_controller.dart';

// Impor Widgets
import '../widgets/landing_button_widget.dart';

class LandingScreenView extends GetView<LandingScreenController> {
  const LandingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/landing.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: controller.skip,
                        child: Text(
                          'Lewati',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(backgroundColor: Colors.white, radius: 5),
                      SizedBox(width: 5),
                      CircleAvatar(backgroundColor: Colors.grey, radius: 5),
                      SizedBox(width: 5),
                      CircleAvatar(backgroundColor: Colors.grey, radius: 5),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Daki Gunung,Jaga Alam',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Jelajahi keindahan puncak Indonesia sambil menjaga keasrian hutan dan lingkungan sekitar.',
                    textAlign: TextAlign.center,

                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 60),
                  Obx(
                    () =>
                        controller.currentPage.value !=
                            (controller.pageData.length - 1)
                        ? LandingButton(
                            text: 'Selanjutnya',
                            onTap: controller.nextPage,
                          )
                        : LandingButton(
                            text: 'Mulai Sekarang',
                            onTap: controller.getStarted,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
