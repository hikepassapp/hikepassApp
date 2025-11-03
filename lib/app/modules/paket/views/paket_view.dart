import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/paket_controller.dart';
import '../widget/header_image_widget.dart';
import '../widget/paket_info_widget.dart';
import '../widget/detail_section_widget.dart';
import '../widget/description_widget.dart';

class PaketView extends GetView<PaketController> {
  const PaketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HeaderImageWidget(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PaketInfoWidget(),
                  const SizedBox(height: 8),
                  const DetailSectionWidget(),
                  const SizedBox(height: 8),
                  const DescriptionWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
