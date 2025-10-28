import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/informasi_controller.dart';

class InformasiView extends GetView<InformasiController> {
  const InformasiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InformasiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InformasiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
