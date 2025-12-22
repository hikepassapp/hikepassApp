import '../config/supabase_config.dart';
import '../models/paket_wisata_model.dart';

class PaketWisataRepository {
  final _supabase = SupabaseConfig.client;

  // Get all paket wisata
  Future<List<PaketWisataModel>> getAllPaketWisata() async {
    try {
      final response = await _supabase
          .from('paket_wisata')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => PaketWisataModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data paket wisata: $e');
    }
  }

  // Get paket wisata by ID
  Future<PaketWisataModel?> getPaketWisataById(String id) async {
    try {
      final response = await _supabase
          .from('paket_wisata')
          .select()
          .eq('id', id)
          .single();

      return PaketWisataModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil detail paket wisata: $e');
    }
  }

  // Get limited paket wisata for home page
  Future<List<PaketWisataModel>> getHomePaketWisata({int limit = 5}) async {
    try {
      final response = await _supabase
          .from('paket_wisata')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => PaketWisataModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data paket wisata: $e');
    }
  }

  // Search paket wisata
  Future<List<PaketWisataModel>> searchPaketWisata(String query) async {
    try {
      final response = await _supabase
          .from('paket_wisata')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => PaketWisataModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mencari paket wisata: $e');
    }
  }
}