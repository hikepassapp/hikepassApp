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
    final controller = Get.find<ReservasiController>();

    // Ambil data dari halaman sebelumnya
    final Map<String, dynamic> data =
        (Get.arguments as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      // 🔹 AppBar
      appBar: const PaymentAppBar(),

      // 🔹 Konten utama
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Ringkasan tiket
            TicketSummaryCard(),
            SizedBox(height: 24),

            // Detail tiket
            TicketDetailSection(),
            SizedBox(height: 24),

            // Metode pembayaran
            PaymentMethodSection(),
            SizedBox(height: 24),

            // Harga + tombol “Bayar Sekarang”
            PaymentPriceSection(),
          ],
        ),
      ),
    );
  }
}
