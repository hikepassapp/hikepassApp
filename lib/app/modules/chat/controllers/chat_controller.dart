import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'package:hikepass_app/app/shared/theme/app_typography.dart';
import '../../../models/chat_message.dart';
import '../../../services/gemini_service.dart';

class ChatController extends GetxController {
  final messageController = TextEditingController();
  final messages = <ChatMessage>[].obs;
  final scrollController = ScrollController();
  final isLoading = false.obs;
  final isStreaming = false.obs;

  late final GeminiService _geminiService;

  @override
  void onInit() {
    super.onInit();
    _geminiService = GeminiService();

    messages.add(
      ChatMessage(
        text: 'Halo!, ada yang bisa kami bantu?',
        isBot: true,
        time: _getCurrentTime(),
      ),
    );
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty || isLoading.value) return;

    final userMessage = messageController.text.trim();
    messages.add(
      ChatMessage(text: userMessage, isBot: false, time: _getCurrentTime()),
    );

    messageController.clear();
    _scrollToBottom();

    isLoading.value = true;
    isStreaming.value = true;

    final botMessageIndex = messages.length;
    messages.add(ChatMessage(text: '', isBot: true, time: _getCurrentTime()));

    try {
      String fullResponse = '';
      await for (final chunk in _geminiService.sendMessageStream(userMessage)) {
        fullResponse += chunk;
        messages[botMessageIndex] = ChatMessage(
          text: fullResponse,
          isBot: true,
          time: _getCurrentTime(),
        );

        _scrollToBottom();
      }
      if (fullResponse.isEmpty) {
        messages[botMessageIndex] = ChatMessage(
          text: 'Maaf, saya tidak dapat memproses pertanyaan Anda saat ini.',
          isBot: true,
          time: _getCurrentTime(),
        );
      }
    } catch (e) {
      messages[botMessageIndex] = ChatMessage(
        text: 'Maaf, terjadi kesalahan. Silakan coba lagi.',
        isBot: true,
        time: _getCurrentTime(),
      );

      Get.snackbar(
        'Error',
        'Gagal mengirim pesan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      isStreaming.value = false;
      _scrollToBottom();
    }
  }

  void resetChat() {
    Get.dialog(
      AlertDialog(
        title: Text('Reset Chat', style: AppTypography.h3),
        content: const Text('Apakah Anda yakin ingin mereset percakapan?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              messages.clear();
              _geminiService.resetChat();
              messages.add(
                ChatMessage(
                  text: 'Halo!, ada yang bisa kami bantu?',
                  isBot: true,
                  time: _getCurrentTime(),
                ),
              );
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Chat berhasil direset',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
