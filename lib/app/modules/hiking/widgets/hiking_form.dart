import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hiking_controller.dart';

// mode tampilan form
enum HikingFormMode { checkIn, checkOut }

extension HikeFormStrings on HikingFormMode {
  String get appBarTitle =>
      this == HikingFormMode.checkIn ? 'Formulir Check-In' : 'Formulir Check-Out';

  String get subtitle => this == HikingFormMode.checkIn
      ? 'List barang bawaanmu sebelum melakukan pendakian!'
      : 'List barang bawaanmu setelah melakukan pendakian!';

  String get buttonLabel => this == HikingFormMode.checkIn ? 'Check-In' : 'Check-Out';
}

class CheckInFormPage extends StatelessWidget {
  const CheckInFormPage({super.key});

  static const List<String> checkInItems = [
    'Pakaian hangat',
    'Jas hujan',
    'Senter',
    'Makanan',
    'Minuman',
    'Kotak P3K',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HikingController>();
    final item = controller.selectedItem.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('Formulir Check-In',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mountain and trail info
              if (item != null) ...[
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],

              // Guidelines
              const Text(
                'Sebelum memulai pendakian, pastikan Anda memiliki semua perlengkapan yang diperlukan dan ikuti panduan berikut:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Mandatory items checkboxes
              const Text('Perlengkapan Wajib', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Obx(() => Column(
                children: List.generate(checkInItems.length, (index) {
                  return CheckboxListTile(
                    title: Text(checkInItems[index]),
                    value: controller.checkInCheckboxes[index],
                    onChanged: (value) {
                      controller.checkInCheckboxes[index] = value ?? false;
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  );
                }),
              )),
              const SizedBox(height: 16),

              // Your items textbox
              const Text('Barang Bawaan Anda', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => controller.checkInItems.value = value,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Daftar barang bawaan Anda',
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isCheckInValid ? controller.submitCheckInAndGoToCheckout : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isCheckInValid ? const Color(0xFF0E564A) : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Check-In',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        )),
      ),
    );
  }
}

class CheckOutFormPage extends StatelessWidget {
  const CheckOutFormPage({super.key});

  static const List<String> checkOutItems = [
    'Barang berharga',
    'Perlengkapan pribadi',
    'Sampah sisa',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HikingController>();
    final item = controller.selectedItem.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Formulir Check-Out',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mountain and trail info
              if (item != null) ...[
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (item.checkInDate != null)
                  Text(
                    'Check-in: ${item.checkInDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),
              ],

              // Guidelines
              const Text(
                'Setelah menyelesaikan pendakian, pastikan semua barang telah dikembalikan dan ikuti panduan berikut:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Mandatory items checkboxes
              const Text('Pengembalian Wajib', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Obx(() => Column(
                children: List.generate(checkOutItems.length, (index) {
                  return CheckboxListTile(
                    title: Text(checkOutItems[index]),
                    value: controller.checkOutCheckboxes[index],
                    onChanged: (value) {
                      controller.checkOutCheckboxes[index] = value ?? false;
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  );
                }),
              )),
              const SizedBox(height: 16),

              // Your items textbox
              const Text('Barang Bawaan Anda', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => controller.checkOutItems.value = value,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Daftar barang bawaan Anda yang dikembalikan',
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isCheckOutValid ? controller.submitCheckOutAndFinish : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isCheckOutValid ? const Color(0xFF0E564A) : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text(
              'Check-Out',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        )),
      ),
    );
  }
}
