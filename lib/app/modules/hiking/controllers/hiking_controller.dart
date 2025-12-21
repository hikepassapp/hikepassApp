import 'package:get/get.dart';
import '../../../models/hiking_model.dart';
import '../../../services/hiking_service.dart';

class HikingController extends GetxController {
  final HikingService _hikingService = Get.find<HikingService>();

  final tabIndex = 0.obs;

  List<HikingModel> get pendingCheckIns => _hikingService.pendingCheckIns;
  List<HikingModel> get checkedIns => _hikingService.checkedIns;

  List<HikingModel> get filteredItems {
    return tabIndex.value == 0 ? pendingCheckIns : checkedIns;
  }

  void switchTab(int index) {
    if (tabIndex.value != index) tabIndex.value = index;
  }

  void navigateToCheckIn(HikingModel hiking) {
    Get.toNamed('/hiking/initial-checkin', arguments: hiking.id);
  }

  void navigateToCheckOut(HikingModel hiking) {
    Get.toNamed('/hiking/initial-checkout', arguments: hiking.id);
  }
}
