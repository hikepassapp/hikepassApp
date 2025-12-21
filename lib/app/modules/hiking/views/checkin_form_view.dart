import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/checkin_form_controller.dart';

class CheckInFormView extends GetView<CheckInFormController> {
  const CheckInFormView({super.key});

  static const List<String> mandatoryItems = [
    'Pakaian hangat',
    'Jas hujan',
    'Senter',
    'Makanan',
    'Minuman',
    'Kotak P3K',
  ];

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Formulir Check-In',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        final hiking = controller.currentHiking.value;

        if (hiking == null) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Mountain and trail info
                Text(
                  hiking.mountainName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  hiking.hikingTrail,
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (hiking.checkInDate != null)
                  Text(
                    'Check-in: ${_formatDate(hiking.checkInDate!)}',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),

                // Guidelines
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF179778)),
                  ),
                  child: const Text(
                    'Sebelum memulai pendakian, pastikan Anda memiliki semua perlengkapan yang diperlukan dan ikuti panduan berikut:',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),

                // Mandatory items checkboxes
                const Text(
                  'Perlengkapan Wajib',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  mandatoryItems.length,
                  (index) => Obx(
                    () => CheckboxListTile(
                      title: Text(mandatoryItems[index]),
                      value: controller.checkboxes[index],
                      onChanged: (value) =>
                          controller.toggleCheckbox(index, value),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      activeColor: const Color(0xFF179778),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Your items textbox
                const Text(
                  'Barang Bawaan Anda',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.itemsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Daftar barang bawaan Anda',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF179778),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Obx(
          () => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isFormValid
                  ? controller.submitCheckIn
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.isFormValid
                    ? const Color(0xFF179778)
                    : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Check-In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
