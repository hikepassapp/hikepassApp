import 'package:get/get.dart';
import 'package:hikepass_app/app/modules/berita/views/berita_list.dart';
import 'package:hikepass_app/app/modules/paket/views/paket_list_view.dart';
import 'package:hikepass_app/app/modules/register/views/fill_data_register_view.dart';
import 'package:hikepass_app/app/modules/register/views/otp_verification_view.dart';
import 'package:hikepass_app/app/modules/register/views/register_password_view.dart';
import 'package:hikepass_app/app/modules/register/views/register_view.dart';
import '../modules/profile/views/about_view.dart';
import '../modules/profile/views/privacy_policy_view.dart';
import '../modules/profile/views/terms_view.dart';
import '../modules/reservasi/views/reservation_payment_view.dart';
import '../modules/reservasi/views/reservation_qris_view.dart';
import '../modules/reservasi/views/payment_success_view.dart';
import '../modules/berita/bindings/berita_binding.dart';
import '../modules/berita/views/berita_view.dart';
import '../modules/bottom_navigation/bindings/bottom_navigation_binding.dart';
import '../modules/bottom_navigation/views/bottom_navigation_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
// Hiking module imports - check-in/check-out feature
import '../modules/hiking/bindings/hiking_binding.dart';
import '../modules/hiking/bindings/checkin_form_binding.dart';
import '../modules/hiking/bindings/checkout_form_binding.dart';
import '../modules/hiking/views/hiking_view.dart';
import '../modules/hiking/views/checkin_form_view.dart';
import '../modules/hiking/views/checkout_form_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/informasi/bindings/informasi_binding.dart';
import '../modules/informasi/views/informasi_view.dart';
import '../modules/landingScreen/bindings/landing_screen_binding.dart';
import '../modules/landingScreen/views/landing_screen_view.dart';
import '../modules/laporan/bindings/laporan_binding.dart';
import '../modules/laporan/views/laporan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_email_view.dart';
import '../modules/login/views/login_password_view.dart';
import '../modules/login/views/login_reset_password_view.dart';
import '../modules/login/views/login_otp_reset_password_view.dart';
import '../modules/login/views/login_reset_password_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/profile_change_profile_view.dart';
import '../modules/profile/views/profile_change_password_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/reservasi/bindings/reservasi_binding.dart';
import '../modules/reservasi/views/reservasi_view.dart';
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/riwayat/views/riwayat_detail_view.dart';
import '../modules/roleSelection/bindings/role_selection_binding.dart';
import '../modules/roleSelection/views/role_selection_view.dart';
import '../modules/paket/bindings/paket_binding.dart';
import '../modules/paket/views/paket_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.bottomNavigation;

  static final routes = [
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
    GetPage(
      name: _Paths.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.hiking,
      page: () => const HikingView(),
      binding: HikingBinding(),
    ),
    GetPage(
      name: '/hiking/checkin-form',
      page: () => const CheckInFormView(),
      binding: CheckInFormBinding(),
    ),
    GetPage(
      name: '/hiking/checkout-form',
      page: () => const CheckOutFormView(),
      binding: CheckOutFormBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.laporan,
      page: () => const LaporanView(),
      binding: LaporanBinding(),
    ),
    GetPage(
      name: _Paths.reservasi,
      page: () => const ReservasiView(),
      binding: ReservasiBinding(),
    ),
    GetPage(
      name: _Paths.reservationPayment,
      page: () => const ReservationPaymentView(),
    ),
    GetPage(name: '/reservation-qris', page: () => const ReservationQrisView()),
    GetPage(name: '/payment-success', page: () => const PaymentSuccessView()),
    GetPage(
      name: _Paths.riwayat,
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: '${_Paths.riwayat}/detail',
      page: () => const RiwayatDetailView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.informasi,
      page: () => const InformasiView(),
      binding: InformasiBinding(),
    ),
    GetPage(
      name: _Paths.landingScreen,
      page: () => const LandingScreenView(),
      binding: LandingScreenBinding(),
    ),
    GetPage(
      name: _Paths.roleSelection,
      page: () => const RoleSelectionView(),
      binding: RoleSelectionBinding(),
    ),
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
      name: '/login-password',
      page: () => const LoginPasswordView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/login-reset-password',
      page: () => const LoginResetPasswordView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/login-otp-reset-password',
      page: () => const LoginOtpResetPasswordView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/edit-profile',
      page: () => const ProfileChangeProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/change-password',
      page: () => const ProfileChangePasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/paket',
      page: () => const PaketView(),
      binding: PaketBinding(),
    ),
    GetPage(
      name: '/berita-detail',
      page: () => const BeritaDetailView(),
      binding: BeritaBinding(),
    ),
    GetPage(name: _Paths.terms, page: () => const TermsView()),
    GetPage(name: _Paths.about, page: () => const AboutView()),
    GetPage(name: _Paths.privacyPolicy, page: () => const PrivacyPolicyView()),
    GetPage(
      name: _Paths.beritaList,
      page: () => const BeritaList(),
      binding: BeritaBinding(),
    ),
    GetPage(
      name: _Paths.paketList,
      page: () => const PaketListView(),
      binding: PaketBinding(),
    ),
  ];
}
