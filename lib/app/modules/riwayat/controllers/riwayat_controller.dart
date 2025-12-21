import 'package:get/get.dart';
import '../../../services/riwayat_service.dart';
import '../../../models/riwayat_model.dart';
import '../../../routes/app_pages.dart';

class RiwayatController extends GetxController {
  final RiwayatService _service = Get.find<RiwayatService>();

  List<RiwayatModel> get items => _service.all;

  void openDetail(RiwayatModel item) {
    Get.toNamed('${Routes.riwayat}/detail', arguments: item.id);
  }
}
