import 'package:get/get.dart';
import '../../../models/informasiModel.dart';

class InformasiController extends GetxController {
  final currentTabIndex = 0.obs;

  final peraturanData = InformasiModel(
    id: 'peraturan',
    imageUrl: 'assets/images/peraturan-banner.png', // GANTI PATH GAMBAR DI SINI
    contents: [
      InformasiContent(
        title: 'Dilarang Mengotori Gunung dan Membuang Sampah Sembarangan',
        description: 'Etika paling utama yang harus diterapkan oleh siapapun yang mendaki gunung adalah menjaga lingkungan alam dan kebersihan gunung. Jangan sedikitpun kamu mengotori gunung dan membuang sampah sembarang dalam pendakian.\n\nTentunya selain karena kotor dan sulit terurai, sampah akan merusak lingkungan dan membuat gunung tak lagi asri. Dengan penuh kesadaran, maka bawa sampahmu turun dari gunung dan jangan tinggalkan sampah sekecil apapun di gunung.\n\nSelalu ingat, di mana pun berada, menjaga alam menjadi tanggung jawab kita bersama demi kelestarian lingkungan.',
      ),
      InformasiContent(
        title: 'Jangan Ganggu Habitat Satwa dan Flora di Gunung',
        description: 'Larang saat mendaki berikutnya adalah mengganggu habitat alami satwa dan flora di gunung. Sebagai tujan pendaki manusia adalah untuk menjelajahi habitat alami dan menikmati indahnya pemandangan alam, sehingga dilarang keras untuk merusaknya dengan cara apapun.\n\nSebagian gunung di Indonesia juga berada di kawasan konservasi dan hutan lindung. Jadi, aksi merusak dan mencelakai satwa yang hidup di habitat alaminya bisa diganjar dengan hukuman perundang-undangan.',
      ),
      InformasiContent(
        title: 'Tidak Buang Air Sembarangan di Gunung Buang Air Sembarangan di Gunung',
        description: 'Selama pendakian tentunya kebutuhan membuat hajat buang air tidak dapat dihindari oleh setiap pendaki. Nah, sebelum melakukannya, kamu harus tahu larangan buang air sembarangan di gunung. Tujuannya pastinya untuk menjaga kebersihan diri, dan tidak mengganggu pendaki lain.\n\nJika ingin buang air, carilah lokasi yang jauh dari jalur pendakian, jauh dari camping area, serta jauh dari sumber mata air. Gunakan teknik gali lubang tutup lubang saat buang air supaya tidak mengganggu pendaki lain.\n\nPastikan juga lokasi yang dipilih untuk buang air jauh dari aliran air dan aman dari binatang buas. Bawa juga air, lap, atau tisu basah (sebagian gunung melarang penggunaan tisu basah), untuk membersihkan diri.',
      ),
    ],
  ).obs;

  final tipsData = InformasiModel(
    id: 'tips',
    imageUrl: 'assets/images/tips-banner.png',
    contents: [
      InformasiContent(
        title: 'Persiapan Fisik dan Mental',
        description: 'Lakukan latihan fisik rutin seperti jogging atau hiking ringan sebelum hari-H pendakian. Persiapkan juga mental menghadapi tantangan di alam terbuka.',
      ),
      InformasiContent(
        title: 'Pilih Jalur Sesuai Kemampuan',
        description: 'Untuk pemula, disarankan memilih jalur Puncak Puntang atau Haruman yang lebih landai. Sementara pendaki berpengalaman bisa mencoba jalur ke Puncak Malabar.',
      ),
      InformasiContent(
        title: 'Etika Pendakian',
        description: 'Jaga kebersihan gunung, bawa kembali sampah, dan hindari berteriak alam liar. Selalu ingat untuk menghormati sesama pendaki dan warga sekitar.',
      ),
      InformasiContent(
        title: 'Jaga Kesehatan Selama Pendakian',
        description: 'Minum air cukup, makan makanan bergizi, dan istirahat saat tubuh mulai lelah. Jangan paksakan diri jika merasa tidak fit!',
      ),
    ],
  ).obs;

  final umumData = InformasiModel(
    id: 'umum',
    imageUrl: 'assets/images/umum-banner.png',
    contents: [
      InformasiContent(
        title: 'Tentang Gunung Malabar',
        description: 'Pendakian Gunung Malabar menawarkan pengalaman menantang dengan pemandangan alam yang memukau. Gunung ini memiliki puncak yang disebut Puncak Besar, dengan ketinggian sekitar 2.343 meter di atas permukaan laut. Terdapat beberapa jalur pendakian, seperti melalui Banjaran atau Pangalengan, dan akses menuju basecamp cukup mudah dijangkau. Gunung Malabar juga dikenal dengan sejarahnya yang kaya, termasuk Stasiun Radio Malabar yang dibangun pada masa kolonial Belanda.',
      ),
    ],
  ).obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onTabChanged(int index) {
    currentTabIndex.value = index;
  }

  InformasiModel get currentData {
    switch (currentTabIndex.value) {
      case 0:
        return peraturanData.value;
      case 1:
        return tipsData.value;
      case 2:
        return umumData.value;
      default:
        return peraturanData.value;
    }
  }
}