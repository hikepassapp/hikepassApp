// lib/app/modules/privacy_policy/widgets/privacy_section_widget.dart
import 'package:flutter/material.dart';

class PrivacySectionWidget extends StatelessWidget {
  final String number;
  final String title;
  final String content;

  const PrivacySectionWidget({
    Key? key,
    required this.number,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. $title',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
