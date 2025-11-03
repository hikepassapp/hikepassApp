import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';

class TicketDetailSection extends StatefulWidget {
  const TicketDetailSection({super.key});

  @override
  State<TicketDetailSection> createState() => _TicketDetailSectionState();
}

class _TicketDetailSectionState extends State<TicketDetailSection> {
  final ReservasiController controller = Get.find<ReservasiController>();
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year, now.month + 3),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2D9F8C), // warna header date picker
              onPrimary: Colors.white, // teks di header
              onSurface: Colors.black, // warna teks tanggal
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Simpan ke controller supaya bisa dibaca di tombol “Bayar Sekarang”
      controller.setSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Tiket',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate == null
                    ? 'Pilih tanggal pendakian'
                    : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.grey),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
