import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';
import '../widgets/reservation_detail_header.dart';
import '../widgets/reservation_detail_info.dart';
import '../widgets/ticket_counter.dart';
import '../widgets/continue_button.dart';

class ReservationDetailView extends StatelessWidget {
  const ReservationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReservasiController>();
    final data = Get.arguments as Map<String, String>;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: CustomScrollView(
        slivers: [
          ReservationDetailHeader(
            imagePath: data['imagePath'] ?? '',
            title: 'Pendakian Gunung Malabar',
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReservationDetailInfo(data: data),
                  const SizedBox(height: 16),
                  _buildInputSection(),
                  const SizedBox(height: 16),
                  const TicketCounter(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: const ContinueButton(),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pos Perizinan Masuk',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Masukkan pos perizinan',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2D9F8C)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
