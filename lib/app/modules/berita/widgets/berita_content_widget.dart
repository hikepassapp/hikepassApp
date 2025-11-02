import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/berita_controller.dart';
import 'berita_badge_widget.dart';
import 'berita_title_widget.dart';
import 'berita_meta_widget.dart';
import 'berita_body_widget.dart';
import 'berita_source_widget.dart';

class BeritaContentWidget extends GetView<BeritaController> {
  const BeritaContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BeritaBadgeWidget(),
          const SizedBox(height: 12),
          const BeritaTitleWidget(),
          const SizedBox(height: 12),
          const BeritaMetaWidget(),
          const SizedBox(height: 20),
          const BeritaBodyWidget(),
          const SizedBox(height: 20),
          const BeritaSourceWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}