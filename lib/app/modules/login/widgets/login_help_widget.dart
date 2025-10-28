import 'package:flutter/material.dart';

class LoginHelpWidget extends StatelessWidget {
  const LoginHelpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.headset_mic,
            color: Colors.black87,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mengalami kendala? hubungi kami',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.add_circle_outline,
            color: Colors.black87,
            size: 20,
          ),
        ],
      ),
    );
  }
}