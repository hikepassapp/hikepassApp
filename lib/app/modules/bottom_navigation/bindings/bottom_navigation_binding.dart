import 'package:get/get.dart';
import 'package:hikepass_app/app/models/weather_provider.dart';
import 'package:hikepass_app/app/models/weather_repository.dart';
import '../../../services/hiking_service.dart';
import '../controllers/bottom_navigation_controller.dart';

class BottomNavigationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HikingService>()) {
      Get.put<HikingService>(HikingService(), permanent: true);
    }

    Get.lazyPut<BottomNavigationController>(
      () => BottomNavigationController(),
    );

    Get.lazyPut<WeatherProvider>(() => WeatherProvider(), fenix: true);
    Get.lazyPut<WeatherRepository>(() => WeatherRepository(), fenix: true);
  }
}
