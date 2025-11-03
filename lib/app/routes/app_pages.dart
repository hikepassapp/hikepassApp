import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

// Register views
import 'package:hikepass_app/app/modules/register/views/fill_data_register_view.dart';
import 'package:hikepass_app/app/modules/register/views/otp_verification_view.dart';
import 'package:hikepass_app/app/modules/register/views/register_password_view.dart';
import 'package:hikepass_app/app/modules/register/views/register_view.dart';

// Reservasi
import '../modules/reservasi/views/reservation_payment_view.dart';
import '../modules/reservasi/views/payment_success_view.dart';

// Berita
=======
import 'package:hikepass_app/app/modules/profile/views/edit_profile_view.dart';

import 'package:hikepass_app/app/modules/register/views/fill_data_register_view.dart';
import 'package:hikepass_app/app/modules/register/views/otp_verification_view.dart';
import 'package:hikepass_app/app/modules/register/views/register_password_view.dart';
>>>>>>> 7c50468f053130b1cd922255066189281c219c04
import '../modules/berita/bindings/berita_binding.dart';
import '../modules/berita/views/berita_view.dart';

// Bottom Navigation
import '../modules/bottom_navigation/bindings/bottom_navigation_binding.dart';
import '../modules/bottom_navigation/views/bottom_navigation_view.dart';

// Chat
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';

// Hiking
import '../modules/hiking/bindings/hiking_binding.dart';
import '../modules/hiking/views/hiking_view.dart';

// Home
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

// Informasi
import '../modules/informasi/bindings/informasi_binding.dart';
import '../modules/informasi/views/informasi_view.dart';

// Landing Screen
import '../modules/landingScreen/bindings/landing_screen_binding.dart';
import '../modules/landingScreen/views/landing_screen_view.dart';

// Laporan
import '../modules/laporan/bindings/laporan_binding.dart';
import '../modules/laporan/views/laporan_view.dart';

// Login
import '../modules/login/bindings/login_binding.dart';
<<<<<<< HEAD
=======
// main login view is not used as a route directly; sub-pages are registered below
>>>>>>> 7c50468f053130b1cd922255066189281c219c04
import '../modules/login/views/login_email_view.dart';
import '../modules/login/views/login_otp_view.dart';
import '../modules/login/views/login_password_view.dart';

// Profile
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
<<<<<<< HEAD

// Register
import '../modules/register/bindings/register_binding.dart';

// Reservasi
=======
import '../modules/profile/views/terms_view.dart';
import '../modules/profile/views/privacy_policy_view.dart';
import '../modules/profile/views/about_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register/views/register_password_view.dart';
import '../modules/register/views/otp_verification_view.dart';
import '../modules/register/views/fill_data_register_view.dart';
>>>>>>> 7c50468f053130b1cd922255066189281c219c04
import '../modules/reservasi/bindings/reservasi_binding.dart';
import '../modules/reservasi/views/payment_success_view.dart';
import '../modules/reservasi/views/reservasi_view.dart';
<<<<<<< HEAD

// Riwayat
=======
import '../modules/reservasi/views/reservation_payment_view.dart';
>>>>>>> 7c50468f053130b1cd922255066189281c219c04
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';

// Role Selection
import '../modules/roleSelection/bindings/role_selection_binding.dart';
import '../modules/roleSelection/views/role_selection_view.dart';

// Paket
import '../modules/paket/bindings/paket_binding.dart';
import '../modules/paket/views/paket_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.landingScreen;

  static final routes = [
    // ======= HOME & NAVIGATION =======
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.bottomNavigation,
      page: () => const BottomNavigationView(),
      binding: BottomNavigationBinding(),
    ),

    // ======= CHAT =======
    GetPage(
      name: _Paths.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),

    // ======= HIKING =======
    GetPage(
      name: _Paths.hiking,
      page: () => const HikingView(),
      binding: HikingBinding(),
    ),

    // ======= PROFILE =======
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),

    // ======= LAPORAN =======
    GetPage(
      name: _Paths.laporan,
      page: () => const LaporanView(),
      binding: LaporanBinding(),
    ),

    // ======= RESERVASI =======
    GetPage(
      name: _Paths.reservasi,
      page: () => const ReservasiView(),
      binding: ReservasiBinding(),
    ),
    GetPage(
      name: _Paths.reservationPayment,
      page: () => const ReservationPaymentView(),
    ),
    GetPage(name: '/payment-success', page: () => const PaymentSuccessView()),

    // ======= RIWAYAT =======
    GetPage(
      name: _Paths.riwayat,
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),

    // ======= INFORMASI =======
    GetPage(
      name: _Paths.informasi,
      page: () => const InformasiView(),
      binding: InformasiBinding(),
    ),

    // ======= LANDING SCREEN =======
    GetPage(
<<<<<<< HEAD
      name: _Paths.LANDING_SCREEN,
=======
      name: _Paths.landingScreen,
>>>>>>> 7c50468f053130b1cd922255066189281c219c04
      page: () => const LandingScreenView(),
      binding: LandingScreenBinding(),
    ),

    // ======= ROLE SELECTION =======
    GetPage(
      name: _Paths.roleSelection,
      page: () => const RoleSelectionView(),
      binding: RoleSelectionBinding(),
    ),

    // ======= REGISTER =======
    GetPage(
      name: _Paths.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: '/register-password',
      page: () => const RegisterPasswordView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: '/register-otp',
      page: () => const RegisterOtpVerificationView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: '/register-fill-data',
      page: () => const FillDataRegisterView(),
      binding: RegisterBinding(),
    ),

    // ======= LOGIN =======
    GetPage(
      name: _Paths.login,
      page: () => const LoginEmailView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/login-email',
      page: () => const LoginEmailView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/login-otp',
      page: () => const LoginOtpView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/login-password',
      page: () => const LoginPasswordView(),
      binding: LoginBinding(),
    ),

    // ======= PAKET =======
    GetPage(
      name: '/paket',
      page: () => const PaketView(),
      binding: PaketBinding(),
    ),

    // ======= BERITA =======
    GetPage(
      name: '/berita-detail',
      page: () => const BeritaDetailView(),
      binding: BeritaBinding(),
    ),
<<<<<<< HEAD
=======
    GetPage(
      name: '/edit-profile',
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.TERMS,
      page: () => const TermsView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: ProfileBinding(),
    ),
      name: _Paths.reservationPayment,
      page: () => const ReservationPaymentView(),
    ),
    GetPage(name: '/payment-success', page: () => const PaymentSuccessView()),
>>>>>>> 7c50468f053130b1cd922255066189281c219c04
  ];
}
