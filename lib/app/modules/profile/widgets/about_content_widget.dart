import 'package:flutter/material.dart';
import 'about_section_widget.dart';

class AboutContentWidget extends StatelessWidget {
  const AboutContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AboutSectionWidget(
          number: '1',
          title: 'Reservasi Tiket',
          content:
              'Reservasi tiket pendakian dilakukan secara online melalui aplikasi HikePass. Pendaki harus memilih tanggal dapat memilih menu \'Reservasi Tiket\', lalu sistem akan menampilkan data jalur dan hari yang tersedia untuk melakukan pendakian. Setelah proses reservasi berhasil, pendaki akan menerima verifikasi kelengkapan, pendaki akan diarahkan untuk memilih metode pembayaran dan mengirimkan konfirmasi prosedur dan petunjuk pembayaran.',
        ),
        SizedBox(height: 16),
        AboutSectionWidget(
          number: '2',
          title: 'Pembayaran',
          content:
              'Setelah proses reservasi selesai, pendaki harus melakukan pembayaran dan mengubahnya menjadi "Lunas" jika transaksi berhasil. Selanjutnya, e-ticket digital akan dikirimkan atau dapat diunduh langsung dari aplikasi setelah bukti pembayaran diverifikasi.',
        ),
        SizedBox(height: 16),
        AboutSectionWidget(
          number: '3',
          title: 'Check-In',
          content:
              'Check-in dilakukan saat hari pendakian di pos registrasi. Pendaki harus menunjukkan e-ticket dan melakukan proses check-in melalui aplikasi HikePass ini, sistem akan menampilkan kode QR tiket sebagai validasi, serta formulir laporan sampah yang harus diisi untuk memantau barang yang dibawa dan tanggung jawab sampah yang akan dibawa.',
        ),
        SizedBox(height: 16),
        AboutSectionWidget(
          number: '4',
          title: 'Check-out',
          content:
              'Check-out dilakukan saat pendakian selesai. Pendaki kembali membuka tiket di aplikasi dan menekan tombol "Check Out", sistem akan kembali memunculkan formulir laporan sampah yang harus diisi ulang. Setelah data dilaporkan, sistem akan menampilkan konfirmasi berhasil check-out. Proses ini memastikan bahwa pendaki menyelesaikan pendakian sesuai prosedur dan membawa kembali sampah yang telah didaftarkan.',
        ),
        SizedBox(height: 16),
        AboutSectionWidget(
          number: '5',
          title: 'Laporan (Opsional)',
          content:
              'Pendaki dapat melaporkan kondisi lingkungan seperti kerusakan atau cuaca buruk melalui fitur laporan di aplikasi HikePass. Laporan ini mencakup deskripsi masalah, lokasi kejadian, serta dukungan bukti berupa foto. Laporan yang dikirim akan diterima dan diverifikasi oleh pengelola melalui dashboard, membantu dalam upaya pemeliharaan Gunung Malabar secara partisipatif.',
        ),
      ],
    );
  }
}
