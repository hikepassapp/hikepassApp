import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const RegisterAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Daftar Akun',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }
}
