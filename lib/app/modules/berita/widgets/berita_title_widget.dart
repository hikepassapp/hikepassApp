import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/berita_controller.dart';

class BeritaTitleWidget extends GetView<BeritaController> {
  const BeritaTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      controller.title.value,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    );
  }
}