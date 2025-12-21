import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReservationQrisView extends StatefulWidget {
  const ReservationQrisView({super.key});

  @override
  State<ReservationQrisView> createState() => _ReservationQrisViewState();
}

class _ReservationQrisViewState extends State<ReservationQrisView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // After a short delay, navigate to payment success screen
    final args = Get.arguments as Map<String, dynamic>?;
    _timer = Timer(const Duration(seconds: 3), () {
      // Use offNamed so the QRIS screen isn't in the back stack
      Get.offNamed('/payment-success', arguments: args);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran - QRIS'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2D9F8C),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // QRIS image from local assets
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/qriss.jpg',
                  width: 240,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Silakan pindai kode QRIS untuk menyelesaikan pembayaran.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              const Text(
                'Proses otomatis akan dilanjutkan setelah pembayaran terdeteksi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
