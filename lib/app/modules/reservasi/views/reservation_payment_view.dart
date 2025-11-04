import 'package:flutter/material.dart';
import '../widgets/payment_app_bar.dart';
import '../widgets/ticket_summary_card.dart';
import '../widgets/ticket_detail_section.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/payment_price_section.dart';

class ReservationPaymentView extends StatelessWidget {
  const ReservationPaymentView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: const PaymentAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            TicketSummaryCard(),
            SizedBox(height: 24),
            TicketDetailSection(),
            SizedBox(height: 24),
            PaymentMethodSection(),
            SizedBox(height: 24),
            PaymentPriceSection(),
          ],
        ),
      ),
    );
  }
}
