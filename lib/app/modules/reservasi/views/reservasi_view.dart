import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reservasi_controller.dart';

class ReservasiView extends GetView<ReservasiController> {
  const ReservasiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReservasiView'), centerTitle: true),
      body: const Center(
        child: Text('ReservasiView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

//
