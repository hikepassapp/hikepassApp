import 'package:flutter/material.dart';

class LandingButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const LandingButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56.0, // Tinggi standar yang baik untuk tombol
  });

  @override
  Widget build(BuildContext context) {
    // Tombol ini akan memiliki lebar penuh (double.infinity)
    // jika 'width' tidak diatur.
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          // Gunakan backgroundColor yang diberikan,
          // atau fallback ke warna hitam pekat (sesuai gambar)
          backgroundColor: backgroundColor ?? const Color(0xFF1E232C),
          
          // Bentuk tombol
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Sesuaikan radius
          ),
          // Menonaktifkan shadow jika tidak perlu
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white, // Teks default putih
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}