import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../controllers/reservasi_controller.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'package:hikepass_app/app/shared/theme/app_typography.dart';

class ReservationFormView extends StatefulWidget {
  const ReservationFormView({super.key});

  @override
  State<ReservationFormView> createState() => _ReservationFormViewState();
}

class _ReservationFormViewState extends State<ReservationFormView> {
  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final alamatController = TextEditingController();
  final telpController = TextEditingController();

  final selectedCountry = "+62".obs;
  final nationality = "WNI".obs;
  final gender = "".obs;
  final ReservasiController formC = Get.find<ReservasiController>();

  // Validation state
  final namaError = Rxn<String>();
  final nikError = Rxn<String>();
  final phoneError = Rxn<String>();
  final alamatError = Rxn<String>();
  final nationalityError = Rxn<String>();
  final genderError = Rxn<String>();
  final isFormValid = false.obs;

  int hikerIndex = -1;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['index'] != null) {
      hikerIndex = args['index'] as int;
    }

    if (hikerIndex >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        formC.ensureHikersCount(hikerIndex + 1);
        final existing = formC.getHiker(hikerIndex);
        if (existing != null && existing.isNotEmpty) {
          namaController.text = existing['nama']?.toString() ?? '';
          nikController.text = existing['nik']?.toString() ?? '';
          gender.value = existing['jenisKelamin']?.toString() ?? '';
          alamatController.text = existing['alamat']?.toString() ?? '';
          telpController.text = existing['telepon']?.toString() ?? '';
        }
      });
    }

    // Attach listeners for live validation
    namaController.addListener(_validateNama);
    nikController.addListener(_validateNik);
    telpController.addListener(_validatePhone);
    alamatController.addListener(_validateAlamat);

    ever(nationality, (_) => _validateNationality());
    ever(gender, (_) => _validateGender());

    // initial validation
    _updateFormValidity();
  }

  @override
  void dispose() {
    namaController.dispose();
    nikController.dispose();
    alamatController.dispose();
    telpController.dispose();
    super.dispose();
  }

  // Validation helpers
  void _validateNama() {
    final v = namaController.text.trim();
    if (v.isEmpty) {
      namaError.value = 'Nama lengkap wajib diisi';
    } else {
      namaError.value = null;
    }
    _updateFormValidity();
  }

  void _validateNik() {
    final v = nikController.text.trim();
    if (v.isEmpty) {
      nikError.value = 'NIK wajib diisi';
    } else if (v.length != 16 ||
        !v.split('').every((c) => '0123456789'.contains(c))) {
      nikError.value = 'NIK harus berupa 16 digit angka';
    } else {
      nikError.value = null;
    }
    _updateFormValidity();
  }

  void _validatePhone() {
    final v = telpController.text.trim();
    if (v.isEmpty) {
      phoneError.value = 'Nomor telepon wajib diisi';
    } else if (v.length < 7 ||
        v.length > 15 ||
        !v.split('').every((c) => '0123456789'.contains(c))) {
      phoneError.value = 'Nomor telepon tidak valid';
    } else {
      phoneError.value = null;
    }
    _updateFormValidity();
  }

  void _validateAlamat() {
    final v = alamatController.text.trim();
    if (v.isEmpty) {
      alamatError.value = 'Alamat wajib diisi';
    } else {
      alamatError.value = null;
    }
    _updateFormValidity();
  }

  void _validateNationality() {
    if (nationality.value.trim().isEmpty) {
      nationalityError.value = 'Pilih kewarganegaraan';
    } else {
      nationalityError.value = null;
    }
    _updateFormValidity();
  }

  void _validateGender() {
    if (gender.value.trim().isEmpty) {
      genderError.value = 'Pilih jenis kelamin';
    } else {
      genderError.value = null;
    }
    _updateFormValidity();
  }

  void _updateFormValidity() {
    final noErrors =
        namaError.value == null &&
        nikError.value == null &&
        phoneError.value == null &&
        alamatError.value == null &&
        nationalityError.value == null &&
        genderError.value == null;

    final allFilled =
        namaController.text.trim().isNotEmpty &&
        nikController.text.trim().isNotEmpty &&
        telpController.text.trim().isNotEmpty &&
        alamatController.text.trim().isNotEmpty &&
        nationality.value.trim().isNotEmpty &&
        gender.value.trim().isNotEmpty;

    isFormValid.value = noErrors && allFilled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Isi Data Pendaki',
        style: AppTypography.h3.copyWith(color: Colors.white, fontSize: 16),
      ),
      centerTitle: true,
      backgroundColor: AppColors.secondary,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      toolbarHeight: 60,
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildNamaSection(),
            _buildNikSection(),
            _buildPhoneSection(),
            _buildAddressSection(),
            _buildNationalitySection(),
            _buildGenderSection(),
            _buildKtpUploadSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Obx(
          () => ElevatedButton(
            onPressed: isFormValid.value
                ? () {
                    final userData = {
                      'nama': namaController.text.trim(),
                      'nik': nikController.text.trim(),
                      'jenisKelamin': gender.value,
                      'alamat': alamatController.text.trim(),
                      'telepon': telpController.text.trim(),
                    };

                    if (hikerIndex >= 0) {
                      formC.saveHiker(hikerIndex, userData);
                      Get.back();
                    } else {
                      formC.saveHiker(0, userData);
                      Get.back();
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: isFormValid.value
                  ? AppColors.secondary
                  : Colors.grey[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Simpan',
              style: TextStyle(
                color: isFormValid.value ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Warning about email autofill removed: email is not a required field for hiker data

  Widget _buildNikSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Nomor Induk Kependudukan"),
        TextField(controller: nikController, decoration: _inputDecoration()),
        Obx(() {
          return nikError.value != null
              ? Text(
                  nikError.value!,
                  style: TextStyle(color: Colors.red.shade700),
                )
              : _buildHintText("*NIK harus sesuai dengan kartu identitas");
        }),
      ],
    );
  }

  Widget _buildNamaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Nama Lengkap"),
        TextField(controller: namaController, decoration: _inputDecoration()),
        Obx(() {
          return namaError.value != null
              ? Text(
                  namaError.value!,
                  style: TextStyle(color: Colors.red.shade700),
                )
              : _buildHintText("*Nama harus sesuai dengan kartu identitas");
        }),
      ],
    );
  }

  Widget _buildPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("No Telepon"),
        _buildPhoneInput(),
        Obx(() {
          return phoneError.value != null
              ? Text(
                  phoneError.value!,
                  style: TextStyle(color: Colors.red.shade700),
                )
              : _buildHintText("*Nomor harus terhubung dengan WA");
        }),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Alamat"),
        TextField(
          controller: alamatController,
          maxLines: 3,
          decoration: _inputDecoration().copyWith(
            hintText: 'Masukan alamat lengkap',
          ),
        ),
        Obx(() {
          return alamatError.value != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    alamatError.value!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                )
              : const SizedBox(height: 12);
        }),
      ],
    );
  }

  Widget _buildNationalitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Kewarganegaraan"),
        _buildRadioGroup(nationality, ["WNI", "WNA"]),
        Obx(() {
          return nationalityError.value != null
              ? Text(
                  nationalityError.value!,
                  style: TextStyle(color: Colors.red.shade700),
                )
              : const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Jenis Kelamin"),
        _buildRadioGroup(gender, ["Laki - Laki", "Perempuan"]),
        Obx(() {
          return genderError.value != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    genderError.value!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                )
              : const SizedBox(height: 12);
        }),
      ],
    );
  }

  Widget _buildKtpUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel("Upload Foto KTP"), _buildKtpUploadField()],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildHintText(String text, {double fontSize = 12}) {
    return Text(
      text,
      style: TextStyle(color: Colors.blue, fontSize: fontSize),
    );
  }

  Widget _buildPhoneInput() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Obx(
            () => DropdownButtonFormField<String>(
              value: selectedCountry.value,
              decoration: _inputDecoration(),
              items: ["+62", "+60", "+65"].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (v) => selectedCountry.value = v!,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 7,
          child: TextField(
            controller: telpController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration(),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioGroup(RxString controller, List<String> options) {
    return Obx(
      () => Row(
        children: options.map((e) {
          return Row(
            children: [
              Radio<String>(
                value: e,
                groupValue: controller.value,
                onChanged: (val) => controller.value = val!,
              ),
              Text(e),
              const SizedBox(width: 20),
            ],
          );
        }).toList(),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF2F3F4),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _buildKtpUploadField() {
    return Obx(() {
      return GestureDetector(
        onTap: () => formC.pickKtpImage(),
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3F4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: formC.ktpImage.value == null
                  ? Colors.grey.shade300
                  : AppColors.primary,
              width: 2,
            ),
          ),
          child: formC.ktpImage.value == null
              ? _buildUploadPlaceholder()
              : _buildImagePreview(),
        ),
      );
    });
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.upload_file, size: 40, color: Colors.grey),
        SizedBox(height: 8),
        Text(
          "Upload Foto KTP",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return FutureBuilder<Uint8List>(
      future: formC.ktpImage.value!.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Gagal memuat gambar',
                  style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('Tidak ada data'));
        }

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                snapshot.data!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}
