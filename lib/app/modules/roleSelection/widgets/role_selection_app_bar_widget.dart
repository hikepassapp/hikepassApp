import 'package:flutter/material.dart';

class RoleSelectionAppBarWidget extends StatelessWidget {
  const RoleSelectionAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '9:41',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Icon(Icons.signal_cellular_4_bar, size: 16, color: Colors.black),
                SizedBox(width: 4),
                Icon(Icons.wifi, size: 16, color: Colors.black),
                SizedBox(width: 4),
                Icon(Icons.battery_full, size: 20, color: Colors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }
}