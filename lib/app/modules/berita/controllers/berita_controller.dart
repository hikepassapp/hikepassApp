import 'package:get/get.dart';

class BeritaController extends GetxController {
  var beritaList = <BeritaModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBerita();
  }

  void fetchBerita() async {
    try {
      isLoading(true);
      // Simulasi data - ganti dengan API call
      await Future.delayed(Duration(seconds: 1));
      beritaList.value = [
        BeritaModel(
          id: 1,
          judul: 'Flutter 4.0 Dirilis dengan Fitur Baru',
          deskripsi: 'Flutter merilis versi terbaru dengan berbagai peningkatan performa',
          imageUrl: 'https://picsum.photos/400/200?random=1',
          tanggal: DateTime.now(),
        ),
        BeritaModel(
          id: 2,
          judul: 'GetX: State Management Terbaik',
          deskripsi: 'GetX menjadi pilihan utama developer Flutter untuk state management',
          imageUrl: 'https://picsum.photos/400/200?random=2',
          tanggal: DateTime.now(),
        ),
        BeritaModel(
          id: 3,
          judul: 'Tips Optimasi Aplikasi Flutter',
          deskripsi: 'Panduan lengkap untuk meningkatkan performa aplikasi Flutter Anda',
          imageUrl: 'https://picsum.photos/400/200?random=3',
          tanggal: DateTime.now(),
        ),
      ];
    } finally {
      isLoading(false);
    }
  }
}

class BeritaModel {
  final int id;
  final String judul;
  final String deskripsi;
  final String imageUrl;
  final DateTime tanggal;

  BeritaModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.imageUrl,
    required this.tanggal,
  });
}
