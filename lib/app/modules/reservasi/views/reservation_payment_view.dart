import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';
import '../widgets/payment_app_bar.dart';
import '../widgets/ticket_summary_card.dart';
import '../widgets/ticket_detail_section.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/payment_price_section.dart';

class ReservationPaymentView extends StatelessWidget {
  const ReservationPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketData = Get.arguments as Map<String, dynamic>?;
    final controller = Get.find<ReservasiController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: const PaymentAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TicketSummaryCard(data: ticketData),
            const SizedBox(height: 24),

            TicketDetailSection(data: ticketData),
            const SizedBox(height: 24),

            _buildHikersSection(controller),
            const SizedBox(height: 24),

            const PaymentMethodSection(),
            const SizedBox(height: 24),
            PaymentPriceSection(data: ticketData),
          ],
        ),
      ),
    );
  }

  Widget _buildHikersSection(ReservasiController controller) {
    return Obx(() {
      final hikers = controller.hikers;
      if (hikers.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Pendaki',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hikers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final hiker = hikers[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF2D9F8C),
                          radius: 18,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hiker['nama'] ?? 'Pendaki ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'NIK: ${hiker['nik'] ?? '-'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildHikerDetailRow(
                      'Jenis Kelamin',
                      hiker['jenisKelamin'] ?? '-',
                    ),
                    _buildHikerDetailRow('Telepon', hiker['telepon'] ?? '-'),
                    _buildHikerDetailRow('Alamat', hiker['alamat'] ?? '-'),
                    if (hiker['nationality']?.isNotEmpty ?? false)
                      _buildHikerDetailRow(
                        'Kebangsaan',
                        hiker['nationality'] ?? '-',
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildHikerDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
