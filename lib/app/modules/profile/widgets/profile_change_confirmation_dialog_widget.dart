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
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Konfirmasi'),
        ),
      ],
    );
  }
}
