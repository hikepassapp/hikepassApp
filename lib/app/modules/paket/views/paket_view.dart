import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/paket_controller.dart';
import '../widget/paket_wisata_header.dart';
import '../widget/paket_wisata_list.dart';

class PaketView extends GetView<PaketController> {
  const PaketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PaketWisataHeader(),
            ),
            const SizedBox(height: 12),
            // List Paket Wisata
            Obx(() => PaketWisataList(
              paketList: controller.paketWisataList,
            )),
          ],
        ),
      ),
    );
  }
}
