import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/role_selection_controller.dart';
import '../widgets/role_selection_app_bar_widget.dart';
import '../widgets/role_selection_hero_image_widget.dart';
import '../widgets/role_selection_content_widget.dart';

class RoleSelectionView extends GetView<RoleSelectionController> {
  const RoleSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hero Image Background
          RoleSelectionHeroImageWidget(),
          
          // Main Content
          Column(
            children: [
              RoleSelectionAppBarWidget(),
              Spacer(),
              RoleSelectionContentWidget(),
            ],
          ),
        ],
      ),
    );
  }
}