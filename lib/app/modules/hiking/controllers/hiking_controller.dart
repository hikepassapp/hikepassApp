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
    print('HikingController initialized');
    print('HikingService instance: ${_hikingService.hashCode}');
    print('Current hiking items: ${_hikingService.allHikings.length}');
    // Ensure persisted hiking data is loaded so the check-in tab shows pending hikes
    _hikingService.loadFromSupabase();
    final args = Get.arguments;
    if (args is Map && args['tab'] is int) {
      tabIndex.value = args['tab'] as int;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh hiking data when view becomes ready (helps after returning from payment)
    refreshHikingData();
  }

  /// Refresh hiking data from database
  Future<void> refreshHikingData() async {
    print('🔄 Refreshing hiking data...');
    await _hikingService.loadFromSupabase();
    print('✅ Hiking data refreshed - ${_hikingService.allHikings.length} items');
  }

  List<HikingModel> get pendingCheckIns {
    final items = _hikingService.allHikings
        .where((h) => h.status == HikingStatus.pending)
        .toList();
    print('📋 Pending check-ins: ${items.length}');
    return items;
  }

  List<HikingModel> get checkedIns {
    final items = _hikingService.allHikings
        .where((h) => h.status == HikingStatus.checkedIn)
        .toList();
    print('📋 Checked-ins: ${items.length}');
    return items;
  }

  List<HikingModel> get filteredItems {
    return tabIndex.value == 0 ? pendingCheckIns : checkedIns;
  }

  void switchTab(int index) {
    if (tabIndex.value != index) tabIndex.value = index;
  }

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
