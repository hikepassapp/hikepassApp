import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hiking_controller.dart';

// mode tampilan form
enum HikingFormMode { checkIn, checkOut }

extension HikeFormStrings on HikingFormMode {
  String get appBarTitle =>
      this == HikingFormMode.checkIn ? 'Formulir Check-In' : 'Formulir Check-Out';

  String get subtitle => this == HikingFormMode.checkIn
      ? 'List barang bawaanmu sebelum melakukan pendakian!'
      : 'List barang bawaanmu setelah melakukan pendakian!';

  String get buttonLabel => this == HikingFormMode.checkIn ? 'Check-In' : 'Check-Out';
}

class HikingForm extends GetWidget<HikingController> {
  const HikingForm({super.key, required this.mode, required this.onSubmit});

  final HikingFormMode mode;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            mode.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Text('List Barang', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextField(
            controller: controller.listController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'List barang bawaanmu!',
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E564A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: Text(
                mode.buttonLabel,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckInFormPage extends StatelessWidget {
  const CheckInFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HikingController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('Formulir Check-In',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'List barang bawaanmu sebelum melakukan pendakian!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              const Text('List Barang', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.listController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'List barang bawaanmu!',
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(height: 24), // ⟵ ganti Spacer dengan jarak biasa
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.submitCheckInAndGoToCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E564A),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Check-In',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

class CheckOutFormPage extends StatelessWidget {
  const CheckOutFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HikingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Formulir Check-Out',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'List barang bawaanmu setelah melakukan pendakian!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              const Text('List Barang', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.listController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'List barang bawaanmu!',
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),

              // (Opsional) tambahkan field khusus check-out di sini:
              // - kondisi perlengkapan, catatan jalur/cuaca, dsb.
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.submitCheckOutAndFinish,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E564A),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text(
              'Check-Out',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
