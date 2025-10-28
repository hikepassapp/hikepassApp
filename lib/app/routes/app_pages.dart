import 'package:get/get.dart';

import '../modules/berita/bindings/berita_binding.dart';
import '../modules/berita/views/berita_view.dart';
import '../modules/bottom_navigation/bindings/bottom_navigation_binding.dart';
import '../modules/bottom_navigation/views/bottom_navigation_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/hiking/bindings/hiking_binding.dart';
import '../modules/hiking/views/hiking_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/informasi/bindings/informasi_binding.dart';
import '../modules/informasi/views/informasi_view.dart';
import '../modules/laporan/bindings/laporan_binding.dart';
import '../modules/laporan/views/laporan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/paket/bindings/paket_binding.dart';
import '../modules/paket/views/paket_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reservasi/bindings/reservasi_binding.dart';
import '../modules/reservasi/views/reservasi_view.dart';
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/spalsh_screen/bindings/spalsh_screen_binding.dart';
import '../modules/spalsh_screen/views/spalsh_screen_view.dart';

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
      name: _Paths.riwayat,
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.informasi,
      page: () => const InformasiView(),
      binding: InformasiBinding(),
    ),
    GetPage(
      name: _Paths.spalhScreen,
      page: () => const SpalshScreenView(),
      binding: SpalshScreenBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PAKET,
      page: () => const PaketView(),
      binding: PaketBinding(),
    ),
    GetPage(
      name: _Paths.BERITA,
      page: () => const BeritaView(),
      binding: BeritaBinding(),
    ),
  ];
}
