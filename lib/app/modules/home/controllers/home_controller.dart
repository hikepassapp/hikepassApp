import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../models/classNewsEventModel.dart';
import '../../../models/paketWisataModel.dart';

class HomeController extends GetxController {
  var userName = 'Nailong'.obs;
  var temperature = 27.obs;
  var weatherCondition = 'Cerah Berawan'.obs;
  var location = 'Pangalengan, Kab. Bandung. Jawa Barat'.obs;
  final paketWisataList = <PaketWisataModel>[].obs;
  final newsEventList = <NewsEventModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNewsEvent();
    loadPaketWisata();
  }

  void loadPaketWisata() {
    paketWisataList.value = [
      PaketWisataModel(
        id: '1',
        title: 'Puncak Besar Malabar',
        agen: 'Trip Dieng Dieng',
        tripType: 'Open Trip',
        date: '10 Des 2023',
        imageUrl: 'assets/images/banner1.png',
        description: 'Nikmati keindahan Puncak Besar Malabar bersama kami!',
        rating: 4.9,
        admin: 'Admini',
        tanggal: '17 Agustus 2025',
        biaya: 'Rp. 100.000',
        titikKumpul: 'Indomaret Podomoro',
        jamKeberangkatan: '05.00 WIB',
        narahubung: '082XXXXXXXXX (Satria)',
        fasilitas: [
          'Transportasi Full AC Pulang Pergi',
          'Air Mineral',
          'Makan Siang',
          'Tour Leader',
          'Spanduk (properti Foto)',
          'Tiket SIMAKSI',
          'Dokumentasi',
        ],
        destinasi: [
          'Puncak Besar Malabar',
          'Taman Rusa',
          'Mengunjungi Pusat Oleh-oleh',
        ],
        createdDate: '31 Mei 2025',
      ),
      PaketWisataModel(
        id: '2',
        title: 'Petualangan Gunung Kerta',
        agen: 'Kerta Trip',
        tripType: 'Private Trip',
        date: '15 Des 2023',
        imageUrl: 'assets/images/banner2.png',
        description: 'Jelajahi Gunung Kerta dengan pengalaman tak terlupakan.',
        rating: 4.7,
        admin: 'Budi Santoso',
        tanggal: '22 Agustus 2025',
        biaya: 'Rp. 250.000',
        titikKumpul: 'Alfamart Gatot Subroto',
        jamKeberangkatan: '04.30 WIB',
        narahubung: '081234567890 (Budi)',
        fasilitas: [
          'Transportasi Private AC',
          'Air Mineral & Snack',
          'Makan 2x (Siang & Malam)',
          'Tour Guide Profesional',
          'Alat Pendakian',
          'Tenda & Sleeping Bag',
          'P3K & Oxygen',
          'Dokumentasi Drone',
        ],
        destinasi: [
          'Base Camp Gunung Kerta',
          'Pos 1 - Hutan Pinus',
          'Pos 2 - Savana',
          'Puncak Gunung Kerta',
        ],
        createdDate: '20 Mei 2025',
      ),
      PaketWisataModel(
        id: '3',
        title: 'Sunrise Dieng Plateau',
        agen: 'Dieng Adventure',
        tripType: 'Open Trip',
        date: '25 Des 2023',
        imageUrl: 'assets/images/banner1.png',
        description:
            'Saksikan keindahan matahari terbit di Dataran Tinggi Dieng',
        rating: 4.8,
        admin: 'Siti Nurhaliza',
        tanggal: '05 September 2025',
        biaya: 'Rp. 150.000',
        titikKumpul: 'Parkir Timur Senayan',
        jamKeberangkatan: '02.00 WIB',
        narahubung: '085678901234 (Siti)',
        fasilitas: [
          'Transportasi Full AC PP',
          'Air Mineral',
          'Sarapan Pagi',
          'Makan Siang',
          'Tour Leader Berpengalaman',
          'Tiket Masuk Wisata',
          'Foto Polaroid',
          'Dokumentasi',
        ],
        destinasi: [
          'Bukit Sikunir (Sunrise)',
          'Telaga Warna',
          'Kawah Sikidang',
          'Candi Arjuna',
          'Pasar Dieng (Oleh-oleh)',
        ],
        createdDate: '15 Juni 2025',
      ),
      PaketWisataModel(
        id: '4',
        title: 'Pantai Selatan Jogja',
        agen: 'Jogja Beach Tour',
        tripType: 'Open Trip',
        date: '01 Jan 2024',
        imageUrl: 'assets/images/banner2.png',
        description:
            'Jelajahi keindahan pantai-pantai eksotis di Jogja Selatan',
        rating: 4.6,
        admin: 'Agung Prasetyo',
        tanggal: '12 September 2025',
        biaya: 'Rp. 120.000',
        titikKumpul: 'Titik Nol KM Yogyakarta',
        jamKeberangkatan: '06.00 WIB',
        narahubung: '087890123456 (Agung)',
        fasilitas: [
          'Transportasi AC PP',
          'Air Mineral',
          'Makan Siang Seafood',
          'Tour Guide Lokal',
          'Tiket Masuk Pantai',
          'Ban Pelampung',
          'Dokumentasi',
        ],
        destinasi: [
          'Pantai Indrayanti',
          'Pantai Timang',
          'Pantai Wediombo',
          'Pule Payung',
        ],
        createdDate: '10 Juni 2025',
      ),
      PaketWisataModel(
        id: '5',
        title: 'Bromo Midnight Tour',
        agen: 'Bromo Explorer',
        tripType: 'Private Trip',
        date: '18 Jan 2024',
        imageUrl: 'assets/images/banner1.png',
        description: 'Nikmati sunrise spektakuler di Gunung Bromo',
        rating: 4.9,
        admin: 'Rina Wulandari',
        tanggal: '28 September 2025',
        biaya: 'Rp. 350.000',
        titikKumpul: 'Stasiun Malang',
        jamKeberangkatan: '23.00 WIB',
        narahubung: '089012345678 (Rina)',
        fasilitas: [
          'Jeep 4x4 Private',
          'Air Mineral & Snack',
          'Jaket Tebal & Masker',
          'Sarapan di Bromo',
          'Tour Guide Berpengalaman',
          'Tiket Masuk & Parkir',
          'Gas Mask',
          'Dokumentasi GoPro',
        ],
        destinasi: [
          'Bukit Penanjakan (Sunrise)',
          'Kawah Bromo',
          'Pasir Berbisik',
          'Savana Teletubbies',
        ],
        createdDate: '05 Juli 2025',
      ),
    ];
  }

  void loadNewsEvent() {
    newsEventList.value = [
      NewsEventModel(
        id: '1',
        title: '3 Fakta Unik Gunung Malabar',
        category: 'Berita',
        date: '3 Des 2023',
        imageUrl: 'assets/images/banner4.png',
        description:
            'Kisah menarik tentang Gunung Malabar yang jarang diketahui',
      ),
      NewsEventModel(
        id: '2',
        title: 'Reboisasi Hutan Lindung Tahun 2023',
        category: 'Event',
        date: '5 Des 2023',
        imageUrl: 'assets/images/banner3.png',
        description: 'Program reboisasi untuk menjaga kelestarian lingkungan',
      ),
    ];
  }

  void onSeeAllTapped() {
    Get.toNamed('/berita-event-list');
  }

  void onNewsEventTapped(NewsEventModel item) {
    Get.toNamed('/berita-event-detail', arguments: item);
  }

  void onSeeAllPaketWisataTapped() {
    Get.toNamed('/paket-wisata-list');
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
