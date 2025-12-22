import 'package:flutter/material.dart';

class ProfileChangeConfirmationDialogWidget extends StatelessWidget {
  final VoidCallback onConfirm;
  final String title;
  final String message;

  const ProfileChangeConfirmationDialogWidget({
    super.key,
    required this.onConfirm,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
<<<<<<< HEAD
          onPressed: () {
            Navigator.of(context).pop(); // Use this instead of Get.back()
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Use this instead of Get.back()
=======
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Tidak',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
>>>>>>> main
            onConfirm();
          },
          child: const Text('Konfirmasi'),
        ),
      ],
    );
  }
}
