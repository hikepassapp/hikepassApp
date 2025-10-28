import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/informasi_controller.dart';
import '../widgets/informasi_app_bar.dart';
import '../widgets/informasi_header_image.dart';
import '../widgets/informasi_tab_bar.dart';
import '../widgets/informasi_content_list.dart';
import '../widgets/informasi_footer.dart';
class InformasiView extends GetView<InformasiController> {
  const InformasiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              controller.onTabChanged(tabController.index);
            }
          });
          
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const InformasiAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(() => InformasiHeaderImage(
                    imageUrl: controller.currentData.imageUrl,
                  )),
                  InformasiTabBar(
                    tabController: tabController,
                  ),
                  const InformasiContentList(),
                  const InformasiFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}