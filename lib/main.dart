import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/routes/app_pages.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';


void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(
        useMaterial3: false, // optional — matikan tema M3 biar default hijau
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.secondary, // set warna utama hijau
        ),
        primaryColor: AppColors.secondary,
        focusColor: AppColors.secondary,
        hintColor: AppColors.secondary,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
