import 'package:flutter/widgets.dart';

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    
    // Mulai dari kiri atas
    path.lineTo(0, 0);
    
    // Garis lurus ke kanan atas
    path.lineTo(size.width, 0);
    
    // Garis lurus ke kanan bawah
    path.lineTo(size.width, size.height - 50);
    
    // Kurva melengkung ke bawah (ini yang membuat efek curved)
    path.quadraticBezierTo(
      size.width / 2,      // Control point X (tengah horizontal)
      size.height + 30,    // Control point Y (ke bawah untuk lengkungan)
      0,                   // End point X (kiri)
      size.height - 50,    // End point Y
    );
    
    // Tutup path
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}