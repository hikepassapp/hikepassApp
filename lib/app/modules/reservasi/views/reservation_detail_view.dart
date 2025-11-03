import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';
import '../widgets/reservation_detail_header.dart';
import '../widgets/reservation_detail_info.dart';
import '../widgets/ticket_counter.dart';
import 'reservasi_rules_view.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class ReservationDetailView extends StatelessWidget {
  const ReservationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, String>;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: CustomScrollView(
        slivers: [
          ReservationDetailHeader(
            imagePath: data['imagePath'] ?? '',
            title: data['title'] ?? '',
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

      // Tombol di bawah fix
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
          // Ketika ditekan -> lanjut ke form pendaki
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => ReservasiRulesView(), arguments: data);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Lanjutkan',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    final controller = Get.find<ReservasiController>();

    final List<String> posList = ['Cinyiruan', 'Kopi Magma'];

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

          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedPos.value.isEmpty
                  ? null
                  : controller.selectedPos.value,
              items: posList.map((pos) {
                return DropdownMenuItem(value: pos, child: Text(pos));
              }).toList(),
              onChanged: (val) {
                controller.selectedPos.value = val ?? '';
              },
              decoration: InputDecoration(
                hintText: 'Pilih pos perizinan',
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
          ),
        ],
      ),
    );
  }
}
