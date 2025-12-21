import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import 'custom_text_field_widget.dart';
import 'custom_button_widget.dart';
import 'info_box_widget.dart';

class FillDataRegisterFormWidget extends GetView<RegisterController> {
  const FillDataRegisterFormWidget({super.key});

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: DefaultTextStyle.of(
            Get.context!,
          ).style.copyWith(fontSize: 12, color: Colors.black54),
          children: [
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yuk, lengkapi data dirimu untuk mendapatkan pengalaman yang lebih',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

          // --- NIK ---
          CustomTextField(
            label: 'NIK',
            hint: 'Masukkan Nomor Induk Kependudukan',
            controller: controller.nikController,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          // --- Nama Lengkap ---
          CustomTextField(
            label: 'Nama Lengkap',
            hint: 'Masukkan Nama Lengkap',
            controller: controller.namaLengkapController,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          // --- Nomor Telepon ---
          CustomTextField(
            label: 'Nomor Telepon',
            hint: 'Masukkan nomor telepon',
            controller: controller.teleponController,
            keyboardType: TextInputType.phone,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          // --- Tanggal Lahir ---
          _buildLabel('Tanggal Lahir', isRequired: true),
          TextFormField(
            controller: controller.tanggalLahirController,
            readOnly: true,
            onTap: () => controller.selectDate(context),
            decoration: InputDecoration(
              hintText: 'dd / mm / yyyy',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              suffixIcon: const Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF059669),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Jenis Kelamin ---
          _buildLabel('Jenis Kelamin', isRequired: true),
          Obx(
            () => Row(
              children: [
                Radio<String>(
                  value: 'Laki-laki',
                  groupValue: controller.selectedGender.value,
                  onChanged: (value) {
                    if (value != null) controller.setGender(value);
                  },
                  activeColor: const Color(0xFF059669),
                ),
                const Text('Laki-laki'),
                const SizedBox(width: 16),
                Radio<String>(
                  value: 'Perempuan',
                  groupValue: controller.selectedGender.value,
                  onChanged: (value) {
                    if (value != null) controller.setGender(value);
                  },
                  activeColor: const Color(0xFF059669),
                ),
                const Text('Perempuan'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // --- Alamat ---
          _buildLabel('Alamat Lengkap', isRequired: true),
          TextFormField(
            controller: controller.alamatController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Masukkan Alamat',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF059669),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Info Box ---
          const InfoBox(
            message:
                'Pastikan informasi yang Anda masukkan benar dan lengkap. Data ini akan digunakan untuk keperluan akun',
          ),
          const SizedBox(height: 32),

          // --- Tombol Navigasi ---
          Obx(
            () => CustomButton(
              text: 'Daftar',
              onPressed: controller.savePersonalData,
              isLoading: controller.isLoading.value,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
