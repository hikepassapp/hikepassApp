import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/routes/app_pages.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'app/config/supabase_config.dart';
import 'app/services/auth_service.dart';
import 'app/services/hiking_service.dart';
import 'app/services/riwayat_service.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() async {
  FlutterError.onError = (details) {
    debugPrint(details.exceptionAsString());
  };

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
await initializeDateFormatting('id_ID', null);
  await SupabaseConfig.initialize();

  // Initialize Error Handling Service
  Get.put(ErrorHandlingService());

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
      home: const AuthCheck(),
      locale: const Locale('id', 'ID'),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authService.isLoggedIn) {
        Get.offNamed('/bottom-navigation');
      } else {
        Get.offNamed('/landing-screen');
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.secondary),
            SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
