import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/riwayat_service.dart';
import '../../../services/hiking_service.dart';
import '../../../models/riwayat_model.dart';
import '../../../models/reservasi_model.dart';
import '../../../models/payment_model.dart';
import '../../../models/hiking_model.dart';
import '../../reservasi/controllers/reservasi_controller.dart';

class RiwayatDetailView extends StatelessWidget {
  const RiwayatDetailView({super.key});

  String _formatDate(DateTime? date, {bool withTime = false}) {
    if (date == null) return '-';
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    if (!withTime) return '$dd/$mm/$yyyy';
    final hh = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy, $hh.$min';
  }

  RiwayatModel? _findItem(String? id) {
    if (id == null) return null;
    
    final hikingService = Get.find<HikingService>();
    
    final service = Get.find<RiwayatService>();
    final serviceItem = service.getById(id);
    if (serviceItem != null) return serviceItem;

    try {
      final reservasiC = Get.find<ReservasiController>();
      final mapItem = reservasiC.riwayat.firstWhere(
        (item) => (item['id'] ?? '').toString() == id,
        orElse: () => null as dynamic,
      );
      
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
        date: DateTime.now(),
        status: PaymentStatus.paid,
      );

      HikingHistoryStatus hikingStatus = HikingHistoryStatus.waiting;
      DateTime? checkInDate;
      DateTime? checkOutDate;
      try {
        final reservasiId = mapItem['id'];
        final hiking = hikingService.allHikings.firstWhere(
          (h) => h.reservasiId == reservasiId,
          orElse: () => null as dynamic,
        );
        
        if (hiking.status == HikingStatus.checkedIn) {
          hikingStatus = HikingHistoryStatus.hiking;
        } else if (hiking.status == HikingStatus.checkedOut) {
          hikingStatus = HikingHistoryStatus.finished;
        } else {
          hikingStatus = HikingHistoryStatus.waiting;
        }
 
        checkInDate = hiking.checkInDate;
        checkOutDate = hiking.checkOutDate;
            } catch (_) {
        hikingStatus = HikingHistoryStatus.waiting;
      }
      
      return RiwayatModel(
        id: mapItem['id'] ?? '',
        reservasi: reservasi,
        payment: payment,
        hikingStatus: hikingStatus,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
      );
        } catch (_) {

    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as String?;
    final item = _findItem(id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail Riwayat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: item == null
          ? const Center(child: Text('Data tidak ditemukan'))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Kode reservasi: ${item.reservasi.code}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nama Gunung',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.reservasi.mountainName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jalur Pendakian',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.reservasi.hikingTrail,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tanggal Check-In',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(item.checkInDate, withTime: true),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tanggal Check-Out',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(item.checkOutDate, withTime: true),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Detail Pendaki',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...item.reservasi.hikers.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final hiker = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pendaki $index',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    hiker.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'NIK',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    hiker.nik,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 24),

                    const Text(
                      'Detail Pembayaran',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kode Pembayaran',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.payment?.code ?? '-',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tanggal Pembayaran',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(item.payment?.date, withTime: true),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jumlah Tiket',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.reservasi.totalTickets} Tiket',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Pembayaran',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${item.payment?.total.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.') ?? '0'}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }


}
