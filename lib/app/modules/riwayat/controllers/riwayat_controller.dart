import 'package:get/get.dart';
import '../../../services/riwayat_service.dart';
import '../../../services/hiking_service.dart';
import '../../../models/riwayat_model.dart';
import '../../../models/reservasi_model.dart';
import '../../../models/payment_model.dart';
import '../../../models/hiking_model.dart';
import '../../reservasi/controllers/reservasi_controller.dart';
import '../../../routes/app_pages.dart';

class RiwayatController extends GetxController {
  late final RiwayatService _service;
  late final HikingService _hikingService;

  @override
  void onInit() {
    super.onInit();
    // Initialize services here instead of in class definition
    _service = Get.find<RiwayatService>();
    _hikingService = Get.find<HikingService>();
    
    // Load history from Supabase
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    await _service.loadFromSupabase();
  }

  /// Public method to refresh history from Supabase
  Future<void> refreshHistory() async {
    await _service.loadFromSupabase();
  }

  List<RiwayatModel> get items {
    final serviceItems = _service.all.toList();
    final existingReservasiIds = serviceItems
        .map((e) => e.reservasi.id)
        .where((id) => id.isNotEmpty)
        .toSet();

    try {
      final reservasiC = Get.find<ReservasiController>();
      
      for (var mapItem in reservasiC.riwayat) {
        final reservasiId = mapItem['id'] ?? '';

        if (existingReservasiIds.contains(reservasiId)) {
          continue;
        }

        final hikersList = <HikerInfo>[];
        if (mapItem['hikers'] != null && mapItem['hikers'] is List) {
          for (var hiker in mapItem['hikers'] as List) {
            hikersList.add(HikerInfo(
              name: hiker['name'] ?? '-',
              nik: hiker['nik'] ?? '-',
            ));
          }
        }

        final ticketCount = mapItem['ticketCount'] ?? 1;
        final ticketPrice = mapItem['ticketPrice'] ?? 15000;
        final totalPrice = mapItem['totalPrice'] ?? (ticketCount * ticketPrice);

        final reservasi = ReservasiModel(
          id: mapItem['id'] ?? '',
          code: mapItem['code'] ?? '',
          mountainName: mapItem['mountainName'] ?? '-',
          hikingTrail: mapItem['hikingTrail'] ?? '-',
          startDate: mapItem['startDate'] ?? DateTime.now(),
          hikers: hikersList,
          ticketPrice: ticketPrice,
        );
        
        final payment = PaymentModel(
          id: mapItem['paymentCode'] ?? '',
          code: mapItem['paymentCode'] ?? '',
          total: totalPrice,
          date: mapItem['paymentDate'] ?? DateTime.now(),
          status: PaymentStatus.paid,
        );

        HikingHistoryStatus hikingStatus = HikingHistoryStatus.waiting;
        DateTime? checkInDate;
        DateTime? checkOutDate;
        try {
          final hiking = _hikingService.allHikings.firstWhere(
            (h) => h.reservasiId == reservasiId,
            orElse: () => null as dynamic,
          );
          
          if (hiking != null) {
            if (hiking.status == HikingStatus.checkedIn) {
              hikingStatus = HikingHistoryStatus.hiking;
            } else if (hiking.status == HikingStatus.checkedOut) {
              hikingStatus = HikingHistoryStatus.finished;
            } else {
              hikingStatus = HikingHistoryStatus.waiting;
            }

            checkInDate = hiking.checkInDate;
            checkOutDate = hiking.checkOutDate;
          }
        } catch (_) {
          hikingStatus = HikingHistoryStatus.waiting;
        }
        
        final riwayatItem = RiwayatModel(
          id: mapItem['id'] ?? '',
          reservasi: reservasi,
          payment: payment,
          hikingStatus: hikingStatus,
          checkInDate: checkInDate,
          checkOutDate: checkOutDate,
        );
        
        serviceItems.insert(0, riwayatItem);
      }
    } catch (_) {

    }
    
    // Sort by start_date descending so newest is at the top
    serviceItems.sort((a, b) => b.reservasi.startDate.compareTo(a.reservasi.startDate));
    
    return serviceItems;
  }

  void openDetail(RiwayatModel item) {
    Get.toNamed('${Routes.riwayat}/detail', arguments: item.id);
  }
}
