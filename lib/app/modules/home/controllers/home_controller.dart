import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../models/berita_model.dart';
import '../../../models/paket_wisata_model.dart';
import '../../../models/weather_repository.dart';
import '../../../models/weather_model.dart';
import '../../../repositories/paket_wisata_repository.dart';
import '../../../repositories/berita_repository.dart';
import '../../../services/auth_service.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends GetxController {
  final WeatherRepository _weatherRepository = Get.find<WeatherRepository>();
  final PaketWisataRepository _paketWisataRepository = PaketWisataRepository();
  final BeritaRepository _beritaRepository = BeritaRepository();
  final AuthService _authService = AuthService();

  var userName = ''.obs;
  var userEmail = ''.obs;
  final paketWisataList = <PaketWisataModel>[].obs;
  final beritaList = <BeritaModel>[].obs;

  final temperature = 0.obs;
  final weatherCondition = ''.obs;
  final weatherIcon = ''.obs;
  final location = 'Loading...'.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final isLoadingPaket = true.obs;
  final isLoadingBerita = true.obs;
  final paketErrorMessage = ''.obs;
  final beritaErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    loadBerita();
    loadPaketWisata();
    loadUserName();
    fetchWeatherData();
  }

  Future<void> loadUserProfile() async {
    try {
      final userProfile = await _authService.getUserProfile();
      
      if (userProfile != null) {
        print('User Profile: $userProfile');
        
        userName.value = userProfile['full_name'] ?? 
                         userProfile['email']?.split('@')[0] ?? 
                         'User';
        
        userEmail.value = userProfile['email'] ?? '';
        
        print('Username set to: ${userName.value}');
      } else {
        print('User profile is null');
        userName.value = 'User';
      }
    } catch (e) {
      print('Error loading user profile: $e');
      userName.value = 'User';
    }
  }

  String get greetingMessage {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }
  String get displayName {
    if (userName.value.isEmpty) return 'User';
    final names = userName.value.split(' ');
    return names.first;
  }

  Future<void> fetchWeatherData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Dapatkan posisi user
      Position position = await _determinePosition();

      // Fetch weather data dari repository
      WeatherModel weather = await _weatherRepository.getWeatherByCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Update observable values
      _updateWeatherData(weather);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      _setDefaultWeatherData();

      // Tampilkan snackbar error
      Get.snackbar(
        'Error',
        'Gagal mengambil data cuaca: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _updateWeatherData(WeatherModel weather) {
    temperature.value = weather.temperature.toInt();
    weatherCondition.value = weather.weatherCondition;
    weatherIcon.value = weather.weatherIcon;
    location.value = weather.location;
  }

  void _setDefaultWeatherData() {
    temperature.value = 0;
    weatherCondition.value = 'Unknown';
    weatherIcon.value = '';
    location.value = 'Unknown Location';
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek location service
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _getDefaultPosition();
    }

    // Cek permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _getDefaultPosition();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return _getDefaultPosition();
    }

    // Dapatkan posisi saat ini
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }

  Position _getDefaultPosition() {
    // Default: Bandung, Indonesia
    return Position(
      latitude: -6.9175,
      longitude: 107.6191,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  Future<void> refreshWeather() async {
    await fetchWeatherData();
  }

  String getWeatherIconUrl() {
    if (weatherIcon.value.isEmpty) return '';
    return 'https://openweathermap.org/img/wn/${weatherIcon.value}@2x.png';
  }

  // Getter untuk temperature dalam format string
  String get temperatureString => '${temperature.value.toStringAsFixed(1)}°C';

  // Load Paket Wisata dari Supabase
  Future<void> loadPaketWisata() async {
    try {
      isLoadingPaket.value = true;
      paketErrorMessage.value = '';

      final data = await _paketWisataRepository.getHomePaketWisata(limit: 5);
      paketWisataList.value = data;

      isLoadingPaket.value = false;
    } catch (e) {
      isLoadingPaket.value = false;
      paketErrorMessage.value = e.toString();

      Get.snackbar(
        'Error',
        'Gagal memuat paket wisata: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Load Berita dari Supabase
  Future<void> loadBerita() async {
    try {
      isLoadingBerita.value = true;
      beritaErrorMessage.value = '';

      final data = await _beritaRepository.getHomeBerita(limit: 3);
      beritaList.value = data;

      isLoadingBerita.value = false;
    } catch (e) {
      isLoadingBerita.value = false;
      beritaErrorMessage.value = e.toString();

      Get.snackbar(
        'Error',
        'Gagal memuat berita: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Refresh semua data termasuk user profile
  Future<void> refreshAllData() async {
    await Future.wait([
      loadUserProfile(),
      loadPaketWisata(),
      loadBerita(),
      fetchWeatherData(),
    ]);
  }

  void onSeeAllBeritaAcaraTapped() {
    Get.offAllNamed(Routes.beritaList);
  }

  void onBeritaAcaraTapped(BeritaModel item) {
    Get.toNamed('/berita-detail', arguments: item);
  }

  void onSeeAllPaketWisataTapped() {
    Get.offAllNamed(Routes.paketList);
  }

  void onPaketWisataTapped(PaketWisataModel item) {
    Get.toNamed('/paket', arguments: item);
  }

  void navigateToReservation() {
    Get.offAllNamed(Routes.reservasi);
  }

  void navigateToRiwayat() {
    Get.offAllNamed(Routes.riwayat);
  }

  void navigateToInformasi() {
    Get.offAllNamed(Routes.informasi);
  }

  void navigateToLaporan() {
    Get.offAllNamed(Routes.laporan);
  }
}
