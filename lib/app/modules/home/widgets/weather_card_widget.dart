// app/modules/home/widgets/weather_card_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/modules/home/widgets/cached_network_image_helper.dart';
import '../../../shared/theme/app_typography.dart';
import '../controllers/home_controller.dart';

class WeatherCardWidget extends GetView<HomeController> {
  const WeatherCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state
      if (controller.isLoading.value) {
        return _buildLoadingCard();
      }

      // Error state
      if (controller.errorMessage.value.isNotEmpty) {
        return _buildErrorCard();
      }

      // Success state
      return _buildWeatherCard();
    });
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildWeatherIcon() {
    return SafeNetworkImage(
      imageUrl: controller.weatherIcon.value.isNotEmpty
          ? controller.getWeatherIconUrl()
          : '',
      width: 140,
      height: 140,
      fit: BoxFit.contain,
      fallbackAsset: 'assets/images/weather.png',
      fallbackWidget: const SizedBox(
        width: 140,
        height: 140,
        child: Icon(Icons.cloud, size: 80, color: Colors.grey),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 8),
          Text(
            'Gagal memuat cuaca',
            style: AppTypography.mMedium.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: controller.refreshWeather,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suhu',
                  style: AppTypography.mMedium.copyWith(color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final temp = controller.temperature.value;
                  return Text(
                    temp != null ? '${temp.toStringAsFixed(0)}°' : '--°',
                    style: AppTypography.xlSemiBold.copyWith(
                      fontSize: 64,
                      height: 1,
                      color: Colors.black,
                    ),
                  );
                }),

                const SizedBox(height: 4),
                Text(
                  'Cuaca Saat Ini',
                  style: AppTypography.mMedium.copyWith(color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.weatherCondition.value,
                  style: AppTypography.lBold.copyWith(color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.location.value,
                  style: AppTypography.sRegular.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          // Weather Icon dari API dengan caching
          _buildWeatherIcon(),
        ],
      ),
    );
  }
}
