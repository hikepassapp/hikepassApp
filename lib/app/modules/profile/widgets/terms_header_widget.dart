import 'package:flutter/material.dart';

class TermsHeaderWidget extends StatelessWidget {
  const TermsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Syarat dan Ketentuan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Dengan menggunakan aplikasi HikePass, pengguna dianggap telah membaca, memahami, dan menyetujui seluruh syarat dan ketentuan yang berlaku dalam penggunaan layanan Kami. Aplikasi ini dirancang untuk mencara penggunaan aplikasi, perlindungan data pribadi pengguna, serta transparansi mengenai prosedur yang ditetapkan oleh pengelola Gunung Malabar. Seluruh informasi yang disediakan dalam aplikasi berupa data reservasi dan identitas diri, menjadi tanggung jawab penuh pengguna.',
          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
