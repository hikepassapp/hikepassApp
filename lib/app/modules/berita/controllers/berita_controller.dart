import 'package:get/get.dart';
import '../../../models/berita_model.dart';

class BeritaController extends GetxController {
  // Data dari arguments
  late BeritaModel beritaData;
  
  // Observable variables
  final kategori = 'Berita'.obs;
  final title = ''.obs;
  final tanggal = ''.obs;
  final author = ''.obs;
  final introText = ''.obs;
  final contentSections = <Map<String, String>>[].obs;
  final sourceTitle = ''.obs;
  final sourceUrl = ''.obs;
  final imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data dari arguments
    if (Get.arguments != null && Get.arguments is BeritaModel) {
      beritaData = Get.arguments as BeritaModel;
      loadBeritaData();
    } else {
      // Set default values jika tidak ada data
      print('Warning: No BeritaModel data received');
    }
  }
  
  void loadBeritaData() {
    if (beritaData == null) return;
    
    kategori.value = beritaData!.kategori;
    title.value = beritaData!.title;
    tanggal.value = beritaData!.tanggal;
    author.value = beritaData!.author;
    introText.value = beritaData!.introText;
    contentSections.value = beritaData!.contentSections;
    sourceTitle.value = beritaData!.sourceTitle;
    sourceUrl.value = beritaData!.sourceUrl;
    imageUrl.value = beritaData!.imageUrl;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}