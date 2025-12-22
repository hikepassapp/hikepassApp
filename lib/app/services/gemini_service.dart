import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      ],
    );

    _chat = _model.startChat(
      history: [
        Content.text(
          '''Kamu adalah asisten virtual pendakian gunung bernama "Rimba" dari aplikasi HikePass. 

Peran dan karaktermu:
- Ramah, helpful, dan supportive
- Ahli dalam pendakian gunung di Indonesia
- Memberikan saran keamanan pendakian
- Membantu pemula memilih jalur yang tepat
- Menjawab pertanyaan tentang persiapan, perlengkapan, cuaca, dan tips pendakian

Format Jawaban:
- Gunakan **bold** untuk menekankan poin penting
- Gunakan bullet points (- atau *) untuk list
- Gunakan numbering (1., 2., 3.) untuk langkah-langkah
- Pisahkan paragraf dengan baik
- Maksimal 3-4 paragraf per jawaban agar mudah dibaca

Ketika menjawab:
- Gunakan bahasa Indonesia yang friendly
- Berikan jawaban yang praktis dan actionable
- Jika ditanya tentang gunung tertentu, berikan info spesifik
- Selalu prioritaskan keselamatan pendaki
- Jika tidak yakin, sarankan untuk cek info terbaru atau hubungi ranger

Contoh topik yang bisa kamu bantu:
- Rekomendasi gunung untuk pemula
- Persiapan dan perlengkapan
- Tips keamanan
- Informasi jalur pendakian
- Cuaca dan musim pendakian
- Perizinan (SIMAKSI)''',
        ),
        Content.model([
          TextPart(
            'Baik, saya siap membantu sebagai asisten virtual pendakian Rimba! 😊',
          ),
        ]),
      ],
    );
  }
  Stream<String> sendMessageStream(String message) async* {
    try {
      final response = _chat.sendMessageStream(Content.text(message));

      await for (final chunk in response) {
        final text = chunk.text;
        if (text != null) {
          yield text;
        }
      }
    } catch (e) {
      if (e.toString().contains('API key')) {
        yield 'Error: API key tidak valid. Silakan periksa konfigurasi.';
      } else {
        yield 'Maaf, terjadi kesalahan. Silakan coba lagi.';
      }
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ??
          'Maaf, saya tidak dapat memproses pertanyaan Anda saat ini.';
    } catch (e) {
      if (e.toString().contains('API key')) {
        return 'Error: API key tidak valid. Silakan periksa konfigurasi.';
      }
      return 'Maaf, terjadi kesalahan. Silakan coba lagi.';
    }
  }

  void resetChat() {
    _chat = _model.startChat(
      history: [
        Content.text(
          '''Kamu adalah asisten virtual pendakian gunung bernama "Rimba" dari aplikasi HikePass.''',
        ),
        Content.model([TextPart('Baik, saya siap membantu! 😊')]),
      ],
    );
  }

  List<Content> getHistory() {
    return _chat.history.toList();
  }
}
