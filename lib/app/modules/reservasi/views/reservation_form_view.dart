import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../widgets/continue_button.dart';
import '../controllers/reservasi_controller.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'package:hikepass_app/app/shared/theme/app_typography.dart';

class ReservationFormView extends StatelessWidget {
  ReservationFormView({super.key});

  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final jkController = TextEditingController();
  final alamatController = TextEditingController();
  final telpController = TextEditingController();

  
  final selectedCountry = "+62".obs;
  final nationality = "WNI".obs;
  final gender = "".obs;
  final ReservasiController formC = Get.put(ReservasiController());

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
            _buildWarningBox(),
            const SizedBox(height: 12),
            _buildNamaSection(),
            _buildNikSection(),
            _buildPhoneSection(),
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
        child: ContinueButton(
          namaController: namaController,
          nikController: nikController,
          jkController: jkController,
          alamatController: alamatController,
          telpController: telpController,
        ),
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF4D8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6C45E)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Masukan email yang didaftarkan pada saat verifikasi akun, Form akan terisi otomatis.\n"
              "Apabila belum verifikasi akun silahkan isi secara manual semua Form yang tersedia.",
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNikSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Nomor Induk Kependudukan"),
        TextField(
          controller: nikController,
          decoration: _inputDecoration(),
        ),
        _buildHintText("*NIK harus sesuai dengan kartu identitas"),
      ],
    );
  }

  Widget _buildNamaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Nama Lengkap"),
        TextField(
          controller: namaController,
          decoration: _inputDecoration(),
        ),
        _buildHintText("*Nama harus sesuai dengan kartu identitas"),
      ],
    );
  }

  Widget _buildPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("No Telepon"),
        _buildPhoneInput(),
        _buildHintText("*Nomor harus terhubung dengan WA"),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildNationalitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Kewarganegaraan"),
        _buildRadioGroup(nationality, ["WNI", "WNA"]),
      ],
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Jenis Kelamin"),
        _buildRadioGroup(gender, ["Laki - Laki", "Perempuan"]),
        const SizedBox(height: 12),
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

  void dispose() {
    namaController.dispose();
    nikController.dispose();
    jkController.dispose();
    alamatController.dispose();
    telpController.dispose();
  }
}
