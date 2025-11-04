// lib/app/modules/privacy_policy/widgets/privacy_content_widget.dart
import 'package:flutter/material.dart';
import 'privacy_section_widget.dart';

class PrivacyContentWidget extends StatelessWidget {
  const PrivacyContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrivacySectionWidget(
          number: '1',
          title: 'Data yang Kami Kumpulkan:',
          content:
              'Kami mengumpulkan informasi pribadi seperti nama, kontak, email, tanggal lahir, jenis kelamin, dan data pendakian (jalur, waktu, laporan) hanya untuk keperluan penggunaan aplikasi.',
        ),
        SizedBox(height: 16),
        PrivacySectionWidget(
          number: '2',
          title: 'Tujuan Penggunaan Data:',
          content:
              'Data digunakan untuk mengelola reservasi, memverifikasi identitas, menyediakan tiket pendakian, dan meningkatkan keamanan selama aktivitas di gunung.',
        ),
        SizedBox(height: 16),
        PrivacySectionWidget(
          number: '3',
          title: 'Keamanan Informasi:',
          content:
              'Data Anda disimpan dengan sistem yang aman dan tidak dibagikan ke pihak ketiga tanpa izin, kecuali diwajibkan oleh hukum.',
        ),
        SizedBox(height: 16),
        PrivacySectionWidget(
          number: '4',
          title: 'Hak Anda:',
          content:
              'Anda dapat mengakses, mengubah, atau menghapus data pribadi Anda kapan saja melalui pengaturan profil.',
        ),
        SizedBox(height: 16),
        PrivacySectionWidget(
          number: '5',
          title: 'Perubahan Kebijakan:',
          content:
              'Kebijakan ini dapat diperbarui sewaktu-waktu. Kami akan memberi tahu Anda jika ada perubahan penting.',
        ),
        SizedBox(height: 16),
        Text(
          'Dengan menggunakan aplikasi ini, Anda menyetujui kebijakan privasi kami.',
          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
