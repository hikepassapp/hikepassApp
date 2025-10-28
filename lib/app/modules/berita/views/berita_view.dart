import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/berita_controller.dart';

class BeritaView extends GetView<BeritaController> {
  const BeritaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BeritaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BeritaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
