import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';
import '../widgets/reservation_app_bar.dart';
import '../widgets/reservation_card.dart';

class ReservasiView extends GetView<ReservasiController> {
  const ReservasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: const ReservationAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2D9F8C)),
          );
        }

        if (controller.reservations.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada data reservasi',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: controller.reservations.length,
          itemBuilder: (context, index) {
            final reservation = controller.reservations[index];
            return ReservationCard(
              imagePath: reservation['imagePath'] ?? '',
              title: reservation['title'] ?? '',
              subtitle: reservation['subtitle'] ?? '',
              price: reservation['price'] ?? '',
              duration: reservation['duration'] ?? '',
              onTap: () {
                controller.goToDetail(reservation);
              },
            );
          },
        );
      }),
    );
  }
}
