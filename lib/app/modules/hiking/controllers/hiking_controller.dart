import 'package:get/get.dart';
import '../../../models/hiking_model.dart';
import '../../../services/hiking_service.dart';

class HikingController extends GetxController {
  final HikingService _hikingService = Get.find<HikingService>();

  final tabIndex = 0.obs;
  bool _routeTabApplied = false;

  @override
  void onInit() {
    super.onInit();
    // Allow callers to open directly on a specific tab (0 = check-in, 1 = check-out)
    final args = Get.arguments;
    if (args is Map && args['tab'] is int) {
      tabIndex.value = args['tab'] as int;
    }
  }

  List<HikingModel> get pendingCheckIns => _hikingService.pendingCheckIns;
  List<HikingModel> get checkedIns => _hikingService.checkedIns;

  List<HikingModel> get filteredItems {
    return tabIndex.value == 0 ? pendingCheckIns : checkedIns;
  }

  void switchTab(int index) {
    if (tabIndex.value != index) tabIndex.value = index;
  }

  /// Apply tab from current route arguments once (used when returning from forms)
  void applyRouteTabIfPresent() {
    if (_routeTabApplied) return;
    final args = Get.arguments;
    if (args is Map && args['tab'] is int) {
      tabIndex.value = args['tab'] as int;
      _routeTabApplied = true;
    }
  }

  void navigateToCheckIn(HikingModel hiking) {
    _hikingService.processInitialCheckIn(hiking.id);
    Get.toNamed('/hiking/checkin-form', arguments: hiking.id);
  }

  void navigateToCheckOut(HikingModel hiking) {
    _hikingService.processInitialCheckOut(hiking.id);
    Get.toNamed('/hiking/checkout-form', arguments: hiking.id);
  }
}
