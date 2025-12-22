import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/routes/app_pages.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'app/config/supabase_config.dart';
import 'app/services/auth_service.dart';
import 'app/services/hiking_service.dart';
import 'app/services/riwayat_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load();

  try {
    await initializeDateFormatting('id_ID', '');
  } catch (e) {
    print('Note: Could not initialize id_ID locale: $e');
  }

  Intl.defaultLocale = 'id_ID';
  
  await SupabaseConfig.initialize();
  
  Get.put(AuthService());
  Get.put(HikingService());
  Get.put(RiwayatService(), permanent: true);

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
