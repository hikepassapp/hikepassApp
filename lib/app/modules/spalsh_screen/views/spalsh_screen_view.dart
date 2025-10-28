import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/spalsh_screen_controller.dart';

class SpalshScreenView extends GetView<SpalshScreenController> {
  const SpalshScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpalshScreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SpalshScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
