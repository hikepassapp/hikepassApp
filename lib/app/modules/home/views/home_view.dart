import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import '../../../widgets/curved_top_clipper.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/weather_card_widget.dart';
import '../widgets/menu_grid_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.secondary,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeaderWidget(),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: const Color(0xFFF5F5F5),
                  ),
                  ClipPath(
                    clipper: CurvedTopClipper(),
                    child: Container(
                      width: double.infinity,
                      height: 150, 
                      color: AppColors.secondary, 
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Obx(
                          () => WeatherCardWidget(
                            temperature: controller.temperature.value,
                            weatherCondition: controller.weatherCondition.value,
                            location: controller.location.value,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const MenuGridWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}