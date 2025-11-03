import 'package:get/get.dart';
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
import '../modules/login/views/login_email_view.dart';
import '../modules/login/views/login_otp_view.dart';
import '../modules/login/views/login_password_view.dart';

// Profile
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

// Register
import '../modules/register/bindings/register_binding.dart';

// Reservasi
import '../modules/reservasi/bindings/reservasi_binding.dart';
import '../modules/reservasi/views/reservasi_view.dart';

// Riwayat
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

  static const initial = Routes.LANDING_SCREEN;

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
      name: _Paths.LANDING_SCREEN,
      page: () => const LandingScreenView(),
      binding: LandingScreenBinding(),
    ),

    // ======= ROLE SELECTION =======
    GetPage(
      name: _Paths.ROLE_SELECTION,
      page: () => const RoleSelectionView(),
      binding: RoleSelectionBinding(),
    ),

    // ======= REGISTER =======
    GetPage(
      name: _Paths.REGISTER,
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
      name: _Paths.LOGIN,
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
  ];
}
