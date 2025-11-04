import 'package:flutter/material.dart';

class TermsContentWidget extends StatelessWidget {
  const TermsContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HikePass mewajibkan setiap pengguna untuk menjaga keselamatan, mematuhi jalur resmi pendakian, serta turut menjaga kelestarian alam selama aktivitas berlangsung. Pelanggaran terhadap ketentuan yang berlaku seperti memberikan data palsu, merusak lingkungan, atau mengabaikan prosedur keselamatan dapat berakibat pada pembatalan reservasi, pembatasan akun, hingga pelarangan pendakian di masa mendatang. Pihak HikePass dan pengelola Gunung Malabar juga berhak memperbaharui syarat dan ketentuan ini kapan saja demi kenyamanan dan keamanan pengguna. Untuk informasi selengkapnya, silakan baca bagian "Kebijakan & Privasi" yang tersedia di dalam aplikasi.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}