import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'menu_item_widget.dart';

class MenuGridWidget extends GetView<HomeController> {
  const MenuGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MenuItemWidget(
            icon: 'images/reservasi.png',
            label: 'Reservasi',
            onTap: controller.navigateToReservation,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: MenuItemWidget(
            icon: 'images/riwayat.png',
            label: 'Riwayat',
            onTap: controller.navigateToRiwayat,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: MenuItemWidget(
            icon: 'images/informasi.png',
            label: 'Informasi',
            onTap: controller.navigateToInformasi,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: MenuItemWidget(
            icon: 'images/laporan.png',
            label: 'Laporan',
            onTap: controller.navigateToLaporan,
          ),
        ),
      ],
    );
  }
}