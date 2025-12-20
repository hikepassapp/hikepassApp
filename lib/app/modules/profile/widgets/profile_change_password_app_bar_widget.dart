import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileChangePasswordAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const ProfileChangePasswordAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Ubah Kata Sandi',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
