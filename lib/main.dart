import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'app/routes/app_pages.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'app/config/supabase_config.dart';
import 'app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'id_ID';
  await SupabaseConfig.initialize();
  await dotenv.load(fileName: ".env");
  final authService = Get.put(AuthService());
  await Future.delayed(const Duration(milliseconds: 100));
  final initialRoute = authService.isLoggedIn
      ? Routes.bottomNavigation
      : Routes.landingScreen;

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondary),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
