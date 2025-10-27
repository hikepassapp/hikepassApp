import 'package:flutter/material.dart';
import '../../../shared/theme/app_typography.dart';

class WeatherCardWidget extends StatelessWidget {
  final int temperature;
  final String weatherCondition;
  final String location;

  const WeatherCardWidget({
    super.key,
    required this.temperature,
    required this.weatherCondition,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
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
                  'Cuaca Saat Ini',
                  style: AppTypography.mMedium.copyWith(color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      temperature.toString(),
                      style: AppTypography.xlBold.copyWith(
                        fontSize: 64,
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '°',
                      style: AppTypography.xlBold.copyWith(
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  weatherCondition,
                  style: AppTypography.lBold.copyWith(color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: AppTypography.sRegular.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/weather.png',
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
