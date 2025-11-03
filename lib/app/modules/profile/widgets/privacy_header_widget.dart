// lib/app/modules/privacy_policy/widgets/privacy_header_widget.dart
import 'package:flutter/material.dart';

class PrivacyHeaderWidget extends StatelessWidget {
  const PrivacyHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kebijakan Privasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Aplikasi HikePass berkomitmen untuk melindungi privasi dan data pribadi pengguna Anda.',
          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
