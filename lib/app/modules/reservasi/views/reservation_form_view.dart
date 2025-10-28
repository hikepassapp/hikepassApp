import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/continue_button.dart';

class ReservationFormView extends StatelessWidget {
  ReservationFormView({super.key});

  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final jkController = TextEditingController();
  final alamatController = TextEditingController();
  final telpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, String>?;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Isi Data Pendaki"),
        centerTitle: true,
        backgroundColor: const Color(0xFF2D9F8C),
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _inputField("Nama Lengkap", namaController),
              _inputField("NIK", nikController),
              _inputField("Jenis Kelamin", jkController),
              _inputField("Alamat", alamatController),
              _inputField("No Telepon", telpController),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
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
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
