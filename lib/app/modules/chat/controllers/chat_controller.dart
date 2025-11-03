import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/chat_message.dart';

class ChatController extends GetxController {
  final messageController = TextEditingController();
  final messages = <ChatMessage>[].obs;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    messages.addAll([
      ChatMessage(
        text: 'Nailong, ada yang bisa kami bantu?',
        isBot: true,
        time: '12:30',
      ),
      ChatMessage(
        text:
            'Akhir-akhir ini aku tertorik untuk hiking, kira-kira jalur pendakian di Gunung Malabar yang cocok untuk pemula apa ya?',
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
    messages.add(
      ChatMessage(
        text: messageController.text,
        isBot: false,
        time: _getCurrentTime(),
      ),
    );

    final userMessage = messageController.text;
    messageController.clear();

    // Simulate bot response
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(
        ChatMessage(
          text: _getBotResponse(userMessage),
          isBot: true,
          time: _getCurrentTime(),
        ),
      );
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _getBotResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('halo') || lowerMessage.contains('hai')) {
      return 'Halo! Ada yang bisa saya bantu?';
    }

    if (lowerMessage.contains('gunung') || lowerMessage.contains('pendakian')) {
      return 'Untuk informasi gunung dan jalur pendakian, silakan pilih menu yang sesuai di aplikasi!';
    }

    if (lowerMessage.contains('pemula') || lowerMessage.contains('beginner')) {
      return 'Untuk pemula, saya sarankan memilih jalur dengan tingkat kesulitan rendah hingga sedang. Pastikan juga membawa perlengkapan yang memadai!';
    }

    if (lowerMessage.contains('terima kasih') ||
        lowerMessage.contains('makasih')) {
      return 'Sama-sama! Jangan ragu untuk bertanya lagi ya 😊';
    }

    return 'Terima kasih atas pertanyaannya. Tim kami akan segera merespon.';
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
