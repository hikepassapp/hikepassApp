import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/hiking_controller.dart';

class HikingView extends GetView<HikingController> {
  const HikingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HikingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HikingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
