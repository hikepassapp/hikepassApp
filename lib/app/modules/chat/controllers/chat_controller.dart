import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/chat_message.dart';

class ChatController extends GetxController {
  final messageController = TextEditingController();
  final messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initial bot messages
    messages.addAll([
      ChatMessage(
        text: 'Sampurasun, ada yang bisa kami bantu?',
        isBot: true,
        time: '12:30',
      ),
      ChatMessage(
        text: 'Akhir-akhir ini aku tertorik untuk hiking, kira-kira jalur pendakian di Gunung Malabar yang cocok untuk pemula apa ya?',
        isBot: false,
        time: '',
      ),
      ChatMessage(
        text: 'Oke! kalo gitu aku coba bantu buat perbandingannya ya',
        isBot: true,
        time: '12:30',
      ),
    ]);
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    // Add user message
    messages.add(ChatMessage(
      text: messageController.text,
      isBot: false,
      time: _getCurrentTime(),
    ));

    final userMessage = messageController.text;
    messageController.clear();

    // Simulate bot response
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(ChatMessage(
        text: _getBotResponse(userMessage),
        isBot: true,
        time: _getCurrentTime(),
      ));
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _getBotResponse(String message) {
    // Simple bot responses
    if (message.toLowerCase().contains('halo') || 
        message.toLowerCase().contains('hai')) {
      return 'Halo! Ada yang bisa saya bantu?';
    }
    if (message.toLowerCase().contains('gunung')) {
      return 'Untuk informasi gunung, silakan pilih menu yang sesuai di aplikasi!';
    }
    return 'Terima kasih atas pertanyaannya. Tim kami akan segera merespon.';
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}