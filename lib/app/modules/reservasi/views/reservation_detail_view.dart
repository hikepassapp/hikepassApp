import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';
import '../widgets/reservation_detail_header.dart';
import '../widgets/reservation_detail_info.dart';
import '../widgets/ticket_counter.dart';
import 'reservasi_rules_view.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class ReservationDetailView extends StatefulWidget {
  const ReservationDetailView({super.key});

  @override
  State<ReservationDetailView> createState() => _ReservationDetailViewState();
}

class _ReservationDetailViewState extends State<ReservationDetailView> {
  final ReservasiController controller = Get.find<ReservasiController>();

  void _handleContinuePressed() {
    // Validate reservation data
    String? validationError = controller.validateReservation();

    if (validationError != null) {
      // Show snackbar with error message
      Get.snackbar(
        'Validasi Gagal',
        validationError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // All validations passed, proceed to next step
    final data = Get.arguments as Map<String, dynamic>;
    Get.to(() => const ReservasiRulesView(), arguments: data);
  }

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;

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

      // Continue button at the bottom
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
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isReservationValid.value
                  ? _handleContinuePressed
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.isReservationValid.value
                    ? AppColors.secondary
                    : Colors.grey[400],
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Lanjutkan',
                style: TextStyle(
                  color: controller.isReservationValid.value
                      ? Colors.white
                      : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget dropdown for entry point and entry date selection
  Widget _buildInputSection() {
    final List<String> posList = ['Cinyiruan', 'Panorama'];

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

          // Dropdown for entry point with error indication
          Obx(() {
            final isError = controller.selectedPos.value.isEmpty;
            return DropdownButtonFormField<String>(
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
                  borderSide: BorderSide(
                    color: isError ? Colors.red[300]! : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isError ? Colors.red : const Color(0xFF2D9F8C),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red[300]!),
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Entry Date Selection
          const Text(
            'Tanggal Masuk',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          Obx(() {
            final isError = controller.selectedDate.value == null;
            return InkWell(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  controller.selectedDate.value = pickedDate;
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isError ? Colors.red[300]! : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.selectedDate.value != null
                          ? '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}'
                          : 'Pilih tanggal masuk',
                      style: TextStyle(
                        color: controller.selectedDate.value != null
                            ? Colors.black87
                            : Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: isError ? Colors.red : Colors.grey[600],
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
