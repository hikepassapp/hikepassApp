import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/services/auth_service.dart';
import '../views/reservation_detail_view.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/hiking_service.dart';
import '../../../services/reservasi_service.dart';
import '../../../services/riwayat_service.dart';
import '../../../config/supabase_config.dart';


class ReservasiController extends GetxController {
  late final HikingService _hikingService;
  final reservations = <Map<String, dynamic>>[].obs;
  final riwayat = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final selectedPos = ''.obs;
  final ticketCount = 1.obs;
  final isAgreed = false.obs;
  var ktpImage = Rxn<XFile>();
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final isReservationValid = false.obs;
  final areAllHikersComplete = false.obs;

  final hikers = <Map<String, dynamic>>[].obs;

  void ensureHikersCount(int count) {
    if (hikers.length < count) {
      for (var i = hikers.length; i < count; i++) {
        hikers.add({});
      }
    } else if (hikers.length > count) {
      hikers.removeRange(count, hikers.length);
    }
  }

  void saveHiker(int index, Map<String, dynamic> data) {
    if (index < 0) return;
    ensureHikersCount(index + 1);
    hikers[index] = data;
    _updateHikersValidationState();
    update();
  }

  Map<String, dynamic>? getHiker(int index) {
    if (index < 0 || index >= hikers.length) return null;
    return hikers[index];
  }

  @override
  void onInit() {
    super.onInit();
    _hikingService = Get.find<HikingService>();
    print('ReservasiController initialized');
    print('HikingService instance: ${_hikingService.hashCode}');
    loadReservations();

    ever(selectedPos, (_) => _updateValidationState());
    ever(selectedDate, (_) => _updateValidationState());
    ever(ticketCount, (_) => _updateValidationState());

    ever(hikers, (_) => _updateHikersValidationState());
  }

  void _updateValidationState() {
    isReservationValid.value =
        selectedPos.value.isNotEmpty &&
        selectedDate.value != null &&
        ticketCount.value >= 1;
  }

  void loadReservations() {
    isLoading.value = true;

    reservations.value = [
      {
        'id': 'R${DateTime.now().millisecondsSinceEpoch}',
        'imagePath': 'assets/images/reservasi_panorama.png',
        'title': 'Puncak Besar Malabar',
        'jalur': 'Jalur Panorama',
        'subtitle': 'LMDH',
        'harga': 'Rp 15.000',
        'duration': 'Estimasi 2 Jam',
        'location': 'Pangalengan, Kab. Bandung',
        'phoneNumber': '+628123456789',
        'estimasi': '± 2 Jam',
      },
    ];

    riwayat.clear();
    isLoading.value = false;
  }

  void toggleAgreement(bool? value) => isAgreed.value = value ?? false;

  String generateReservationCode() {
    final rand = Random().nextInt(900000) + 100000;
    return 'RSV-$rand';
  }

  void incrementTicket() {
    if (ticketCount.value < 8) ticketCount.value++;
  }

  void decrementTicket() {
    if (ticketCount.value > 1) ticketCount.value--;
  }

  void resetTicketCount() => ticketCount.value = 1;

  void setSelectedDate(DateTime date) => selectedDate.value = date;

  String? validateReservation() {
    if (selectedPos.value.isEmpty) {
      return 'Harap pilih Pos Perizinan Masuk';
    }
    if (selectedDate.value == null) {
      return 'Harap pilih Tanggal Masuk';
    }
    if (ticketCount.value < 1) {
      return 'Jumlah pendaki harus minimal 1';
    }
    return null;
  }

  bool _isHikerComplete(Map<String, dynamic> hiker) {
    if (hiker.isEmpty) return false;

    return (hiker['nama'] != null &&
            (hiker['nama'] as String).trim().isNotEmpty) &&
        (hiker['nik'] != null && (hiker['nik'] as String).trim().isNotEmpty) &&
        (hiker['jenisKelamin'] != null &&
            (hiker['jenisKelamin'] as String).trim().isNotEmpty) &&
        (hiker['alamat'] != null &&
            (hiker['alamat'] as String).trim().isNotEmpty) &&
        (hiker['telepon'] != null &&
            (hiker['telepon'] as String).trim().isNotEmpty);
  }

  void _updateHikersValidationState() {
    final count = ticketCount.value;
    ensureHikersCount(count);

    bool allComplete = true;
    for (int i = 0; i < count; i++) {
      final hiker = getHiker(i) ?? {};
      if (!_isHikerComplete(hiker)) {
        allComplete = false;
        break;
      }
    }

    areAllHikersComplete.value = allComplete;
  }

  void goToDetail(Map<String, dynamic> reservation) {
    Get.to(
      () => const ReservationDetailView(),
      arguments: reservation,
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> pickKtpImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ktpImage.value = image;
    }
  }

  Future<void> completePayment(Map<String, dynamic> data) async {
    final now = DateTime.now();

    print('💳 === CompletePayment START ===');
    print('   selectedDate: ${selectedDate.value}');
    print('   selectedPos: ${selectedPos.value}');

    final reservasiCode =
        data['reservationCode']?.toString() ??
        data['id']?.toString() ??
        generateReservationCode();
    final reservasiId = 'R${now.millisecondsSinceEpoch}';
    final mountainName =
        (data['title'] ?? data['mountainName'] ?? 'Puncak Besar Malabar')
            .toString();
    final jalur =
        (data['selectedPos'] ??
                data['jalur'] ??
                data['hikingTrail'] ??
                'Jalur Panorama')
            .toString();
    final startDate = selectedDate.value ?? now;

    print('Extracted: Mountain=$mountainName, Trail=$jalur, Date=$startDate');

    final authService = Get.find<AuthService>();
    final currentUser = authService.currentUser;
    final userId = currentUser?.id;

    print('🔐 Auth Debug: currentUser=$currentUser, userId=$userId');
    if (userId == null) {
      print('⚠️ WARNING: userId is null! currentUser=${currentUser?.email}');
    }

    await _hikingService.createFromReservation(
      reservasiId: reservasiId,
      mountainName: mountainName,
      hikingTrail: jalur,
      startDate: startDate,
      userId: userId,
    );

    final payRand = Random().nextInt(900000) + 100000;
    final paymentCode = 'PAY-$payRand';
    final totalPrice = ticketCount.value * 15000;

    final historyMap = {
      'id': reservasiId,
      'code': reservasiCode,
      'mountainName': mountainName,
      'hikingTrail': jalur,
      'startDate': startDate,
      'paymentStatus': 'Lunas',
      'hikingStatus': 'Menunggu',
      'paymentCode': paymentCode,
      'paymentDate': now,
      'ticketCount': ticketCount.value,
      'ticketPrice': 15000,
      'totalPrice': totalPrice,
      'hikers': hikers
          .map(
            (h) => {
              'nama': h['nama'],
              'nik': h['nik'],
              'telepon': h['telepon'],
              'alamat': h['alamat'],
              'kewarganegaraan': h['kewarganegaraan'],
              'jenisKelamin': h['jenisKelamin'],
              'ktpImageUrl': h['ktpImageUrl'],
            },
          )
          .toList(),
    };

    riwayat.add(historyMap);

    try {
      print('💾 STEP 1: Save reservation...');
      final reservasiService = Get.isRegistered<ReservasiService>()
          ? Get.find<ReservasiService>()
          : Get.put(ReservasiService(), permanent: true);

      print('📝 Upserting reservation with userId: $userId');
      await reservasiService.upsertReservation({
        'id': reservasiId,
        'code': reservasiCode,
        'mountainName': mountainName,
        'hikingTrail': jalur,
        'startDate': startDate,
        'ticketPrice': 15000,
        'hikers': historyMap['hikers'],
        'userId': userId,
      });
      print('✅ Reservation saved');

      print('💳 Upserting payment with userId: $userId');
      await reservasiService.upsertPayment({
        'reservasiId': reservasiId,
        'paymentCode': paymentCode,
        'totalPrice': totalPrice,
        'paymentDate': now,
        'userId': userId,
      });
      print('✅ Payment saved, history should be created automatically');

      try {
        if (Get.isRegistered<RiwayatService>()) {
          final riwayatService = Get.find<RiwayatService>();
          print('🔄 Refreshing history data from Supabase...');
          await riwayatService.loadFromSupabase();
          print('✅ History refreshed');
        }
      } catch (e) {
        print('⚠️ Could not refresh history after payment: $e');
      }
      
      print('💾 STEP 5: Refresh hiking...');
      await _hikingService.loadFromSupabase();
      print('   ✅ Hiking refreshed - count: ${_hikingService.allHikings.length}');
      
      print('💳 === CompletePayment SUCCESS ===');
    } catch (e) {
      print('❌ ERROR in completePayment: $e');
      Get.snackbar(
        'Error',
        'Gagal menyimpan pembayaran: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    resetTicketCount();
    selectedDate.value = null;
    selectedPos.value = '';
    isAgreed.value = false;
    hikers.clear();
    ktpImage.value = null;

    update();

    Get.snackbar(
      'Pembayaran Berhasil',
      'Tiket telah ditambahkan. Silakan lakukan check-in di pendakian.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}
