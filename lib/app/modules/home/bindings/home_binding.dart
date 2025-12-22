import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../../models/weather_provider.dart';
import '../../../models/weather_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherProvider>(
      () => WeatherProvider(),
      fenix: true,
    );

    Get.lazyPut<WeatherRepository>(
      () => WeatherRepository(),
      fenix: true,
    );

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
