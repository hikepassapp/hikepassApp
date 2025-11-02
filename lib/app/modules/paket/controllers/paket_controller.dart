import 'package:get/get.dart';
import '../../../models/paketWisataModel.dart';

class PaketController extends GetxController {
  late PaketWisataModel paketData;
  
  // Observable variables
  final paketTitle = ''.obs;
  final rating = 0.0.obs;
  final admin = ''.obs;
  final tanggal = ''.obs;
  final biaya = ''.obs;
  final titikKumpul = ''.obs;
  final jamKeberangkatan = ''.obs;
  final narahubung = ''.obs;
  
  final fasilitasList = <String>[].obs;
  final destinasiList = <String>[].obs;
  final createdDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data dari arguments
    if (Get.arguments != null && Get.arguments is PaketWisataModel) {
      paketData = Get.arguments as PaketWisataModel;
      loadPaketData();
    }
  }
  
  void loadPaketData() {
    // Populate data dari model
    paketTitle.value = paketData.title ?? '';
    rating.value = paketData.rating ?? 0.0;
    admin.value = paketData.admin ?? '';
    tanggal.value = paketData.tanggal ?? '';
    biaya.value = paketData.biaya ?? '';
    titikKumpul.value = paketData.titikKumpul ?? '';
    jamKeberangkatan.value = paketData.jamKeberangkatan ?? '';
    narahubung.value = paketData.narahubung ?? '';
    fasilitasList.value = paketData.fasilitas ?? [];
    destinasiList.value = paketData.destinasi ?? [];
    createdDate.value = paketData.createdDate ?? '';
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  
  // Methods
  void goBack() {
    Get.back();
  }
}
