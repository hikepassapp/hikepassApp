import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/berita_controller.dart';
import '../widgets/berita_header_widget.dart';
import '../widgets/berita_content_widget.dart';

class BeritaDetailView extends GetView<BeritaController> {
  const BeritaDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const BeritaHeaderWidget(),
          SliverToBoxAdapter(
            child: const BeritaContentWidget(),
          ),
        ],
      ),
    );
  }
}