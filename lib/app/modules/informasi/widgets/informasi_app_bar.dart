import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'package:hikepass_app/app/shared/theme/app_typography.dart';

class InformasiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InformasiAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed(Routes.bottomNavigation),
        ),
        title: Text(
          'Informasi',
          style: AppTypography.h3.copyWith(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.secondary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        toolbarHeight: 60,
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
