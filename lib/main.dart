import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/routes/app_pages.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'app/config/supabase_config.dart';
import 'app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID';
  await SupabaseConfig.initialize();
  await dotenv.load(fileName: ".env");
  Get.put(AuthService());

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondary),
        primaryColor: AppColors.secondary,
        focusColor: AppColors.secondary,
        hintColor: AppColors.secondary,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const AuthCheck(),
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
        Get.offAllNamed('/bottom-navigation');
      } else {
        Get.offAllNamed('/bottom-navigation');//debug langsung ke home sementara
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
