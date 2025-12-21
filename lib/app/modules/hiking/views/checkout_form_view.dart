import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/checkout_form_controller.dart';

class CheckOutFormView extends GetView<CheckOutFormController> {
  const CheckOutFormView({super.key});

  static const List<String> mandatoryItems = [
    'Barang berharga',
    'Perlengkapan pribadi',
    'Sampah sisa makanan/minuman/plastik',
  ];

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy, HH:mm', 'id_ID').format(date);
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
          'Formulir Check-Out',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
                // Subtitle
                const Text(
                  'List barang bawaan setelah melakukan pendakian!',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Mountain and trail info in two columns
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Gunung',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hiking.mountainName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jalur Pendakian',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hiking.hikingTrail,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Check-in and check-out dates
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tanggal Check-In',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hiking.checkInDate != null
                                ? _formatDate(hiking.checkInDate!)
                                : '-',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tanggal Check-Out',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hiking.checkOutDate != null
                                ? _formatDate(hiking.checkOutDate!)
                                : '-',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Guidelines with numbering
                const Text(
                  'Panduan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. Pendaki wajib menjaga kelestarian lingkungan dengan tidak merusak flora, fauna, maupun fasilitas pendakian yang tersedia.',
                  style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 8),
                const Text(
                  '2. Pendaki wajib memastikan seluruh sampah pribadi dibawa turun, serta menjaga kebersihan jalur dan area perkemahan.',
                  style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 8),
                const Text(
                  '3. Pendaki wajib melapor kepada petugas pos saat selesai pendakian sebagai tanda resmi telah kembali dengan selamat.',
                  style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 20),

                // Mandatory items checkboxes in grid
                const Text(
                  'Barang Wajib',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(
                    mandatoryItems.length,
                    (index) => Obx(
                      () => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Checkbox(
                              value: controller.checkboxes[index],
                              onChanged: (value) =>
                                  controller.toggleCheckbox(index, value),
                              activeColor: const Color(0xFF179778),
                            ),
                            Expanded(
                              child: Text(
                                mandatoryItems[index],
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Your items textbox
                const Text(
                  'Barang Bawaan Anda',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.itemsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'List barang bawaan anda!',
                    hintStyle: const TextStyle(fontSize: 13),
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
                  ? controller.submitCheckOut
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
                'Check-Out',
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
