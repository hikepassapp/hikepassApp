import 'package:flutter/widgets.dart';

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30,
      0,
      size.height - 50,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
