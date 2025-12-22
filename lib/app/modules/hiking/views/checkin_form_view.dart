import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checkin_form_controller.dart';

class CheckInFormView extends GetView<CheckInFormController> {
  const CheckInFormView({super.key});

  static const List<String> mandatoryItems = [
    'Pakaian hangat',
    'Makanan',
    'Jas hujan',
    'Minuman',
    'Senter',
    'Kotak P3K',
  ];

  String _formatDate(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year}, ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
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
                const Text(
                  'List barang bawaan sebelum melakukan pendakian!',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

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
                          const Text(
                            '-',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'Panduan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. Pendaki wajib membawa perlengkapan standar keselamatan, termasuk pakaian hangat, jas hujan, penerangan, serta perbakalan makanan dan minuman.',
                  style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 8),
                const Text(
                  '2. Pendaki dilarang membawa senjata tajam, minuman beralkohol, maupun barang berbahaya lainnya yang dapat mengganggu keamanan dan ketertiban.',
                  style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 8),
                const Text(
                  '3. Pendaki wajib mematuhi jalur resmi dan arahan petugas, serta melakukan aktivitas di luar jalur pendakian yang telah ditentukan demi menjaga keselamatan diri dan kelestarian alam.',
                  style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Barang Wajib',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: List.generate(
                    mandatoryItems.length,
                    (index) => Obx(
                      () => Row(
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
                const SizedBox(height: 20),

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
