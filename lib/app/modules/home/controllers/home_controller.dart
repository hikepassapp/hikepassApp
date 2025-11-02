import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../models/berita_model.dart';
import '../../../models/paketWisataModel.dart';

class HomeController extends GetxController {
  var userName = 'Nailong'.obs;
  var temperature = 27.obs;
  var weatherCondition = 'Cerah Berawan'.obs;
  var location = 'Pangalengan, Kab. Bandung. Jawa Barat'.obs;
  final paketWisataList = <PaketWisataModel>[].obs;
  final beritaList = <BeritaModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBerita();
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

  void loadBerita() {
    beritaList.value = [
      BeritaModel(
        id: '1',
        title:
            '3 Fakta Unik Gunung Malabar, Habitat Macan Kumbang di Jawa Barat',
        kategori: 'Berita',
        tanggal: '3 Des 2024',
        author: 'Admini',
        imageUrl: 'assets/images/banner4.png',
        introText:
            'JURNAL SOREANG - Gunung Malabar, terletak di Bandung Selatan, dikenal tidak hanya sebagai tujuan pendakian, tetapi juga sebagai kawasan konservasi yang penting. Berikut adalah beberapa fakta unik tentang Gunung Malabar:',
        contentSections: [
          {
            'title': 'Habitat Macan Kumbang',
            'content':
                'Gunung Malabar menjadi salah satu habitat alami bagi macan kumbang (Panthera pardus melas), subspesies macan tutul yang dilindungi. Kehadiran hewan ini menunjukkan keberagaman hayati yang masih terjaga di kawasan tersebut. Meski jarang terlihat, pendaki disarankan untuk selalu berhati-hati dan menjaga lingkungan.',
          },
          {
            'title': 'Radio Malabar Bersejarah',
            'content':
                'Di kaki gunung ini terdapat peninggalan sejarah berupa Stasiun Radio Malabar, yang dahulu merupakan pusat komunikasi terbesar Belanda di Asia. Kini, area tersebut menjadi saksi sejarah sekaligus daya tarik wisata edukasi.',
          },
          {
            'title': 'Perkebunan Teh yang Luas',
            'content':
                'Gunung ini dikelilingi oleh kebun teh yang terhampar luas, memberikan suasana sejuk dan segar bagi pendaki maupun wisatawan yang ingin sekadar menikmati alam.',
          },
        ],
        sourceTitle:
            '3 Fakta Unik Gunung Malabar, Habitat Macan Kumbang di Jawa Barat',
        sourceUrl:
            'https://soreang.pikiran-rakyat.com/gaya-hidup/pr-3938839289/3-fakta-unik-gunung-malabar-habitat-macan-kumbang-di-jawa-barat?page=2',
      ),
      BeritaModel(
        id: '2',
        title: 'Jalur Pendakian Gunung Semeru Dibuka Kembali untuk Umum',
        kategori: 'Berita',
        tanggal: '15 Des 2024',
        author: 'Redaksi',
        imageUrl: 'assets/images/banner3.png',
        introText:
            'Balai Besar Taman Nasional Bromo Tengger Semeru (TNBTS) resmi membuka kembali jalur pendakian Gunung Semeru untuk umum setelah ditutup selama beberapa bulan karena aktivitas vulkanik.',
        contentSections: [
          {
            'title': 'Syarat dan Ketentuan Pendakian',
            'content':
                'Pendaki wajib mendaftar secara online melalui sistem booking yang telah disediakan. Kuota pendaki dibatasi maksimal 500 orang per hari untuk menjaga kelestarian lingkungan dan keamanan.',
          },
          {
            'title': 'Protokol Keselamatan',
            'content':
                'Setiap pendaki diwajibkan mengikuti briefing keselamatan dan membawa perlengkapan standar pendakian. Tim SAR dan petugas TNBTS siaga 24 jam untuk memantau kondisi gunung dan pendaki.',
          },
          {
            'title': 'Biaya Pendakian',
            'content':
                'Biaya pendakian ditetapkan Rp 50.000 untuk pendaki domestik dan Rp 300.000 untuk pendaki mancanegara. Biaya ini sudah termasuk asuransi dan biaya konservasi.',
          },
        ],
        sourceTitle: 'Jalur Pendakian Gunung Semeru Dibuka Kembali',
        sourceUrl: 'https://example.com/berita-semeru',
      ),
      BeritaModel(
        id: '3',
        title: 'Festival Pendakian Nusantara 2024 Siap Digelar di 10 Gunung',
        kategori: 'Event',
        tanggal: '20 Des 2024',
        author: 'Tim Redaksi',
        imageUrl: 'assets/images/banner3.png',
        introText:
            'Kementerian Pariwisata dan Ekonomi Kreatif berkolaborasi dengan komunitas pendaki akan menggelar Festival Pendakian Nusantara 2024 di 10 gunung populer di Indonesia.',
        contentSections: [
          {
            'title': 'Gunung yang Terlibat',
            'content':
                'Festival ini akan digelar serentak di Gunung Rinjani, Semeru, Kerinci, Merbabu, Prau, Gede, Papandayan, Slamet, Ciremai, dan Sumbing. Setiap lokasi akan menghadirkan acara spesial dan doorprize menarik.',
          },
          {
            'title': 'Rangkaian Acara',
            'content':
                'Peserta akan mendapatkan certificate of achievement, merchandise eksklusif, dan kesempatan mengikuti workshop fotografi landscape serta survival skills dari praktisi berpengalaman.',
          },
          {
            'title': 'Cara Pendaftaran',
            'content':
                'Pendaftaran dibuka mulai 1 Januari 2025 melalui website resmi. Kuota peserta terbatas 200 orang per gunung. Early bird mendapat diskon 30% hingga 15 Januari 2025.',
          },
        ],
        sourceTitle: 'Festival Pendakian Nusantara 2024',
        sourceUrl: 'https://example.com/festival-pendakian',
      ),
    ];
  }

  void onSeeAllBeritaAcaraTapped() {
    Get.toNamed('/berita-list');
  }

  void onBeritaAcaraTapped(BeritaModel item) {
    Get.toNamed('/berita-detail', arguments: item);
  }

  void onSeeAllPaketWisataTapped() {
    Get.toNamed('/paket-list');
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
