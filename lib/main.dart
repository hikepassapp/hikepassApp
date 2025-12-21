import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/routes/app_pages.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'app/config/supabase_config.dart';
import 'app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Indonesian locale for date formatting
  await initializeDateFormatting('id_ID', null);
  
  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize AuthService
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
      home: const AuthCheck(), // Check auth status first
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}

// Widget to check authentication status on app start
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    // Check if user is logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authService.isLoggedIn) {
        // User is logged in, go to home
        print('User already logged in: ${authService.currentUser?.email}');
        Get.offAllNamed('/bottom-navigation');
      } else {
        // User not logged in, go to landing
        print('No active session, showing landing screen');
        Get.offAllNamed('/landing-screen');
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
