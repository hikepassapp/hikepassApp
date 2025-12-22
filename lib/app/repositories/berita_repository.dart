import '../config/supabase_config.dart';
import '../models/berita_model.dart';

class BeritaRepository {
  final _supabase = SupabaseConfig.client;

  // Get all berita
  Future<List<BeritaModel>> getAllBerita() async {
    try {
      final response = await _supabase
          .from('berita')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => BeritaModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data berita: $e');
    }
  }

  // Get berita by ID
  Future<BeritaModel?> getBeritaById(String id) async {
    try {
      final response = await _supabase
          .from('berita')
          .select()
          .eq('id', id)
          .single();

      return BeritaModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil detail berita: $e');
    }
  }

  // Get limited berita for home page
  Future<List<BeritaModel>> getHomeBerita({int limit = 3}) async {
    try {
      final response = await _supabase
          .from('berita')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => BeritaModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data berita: $e');
    }
  }

  // Get berita by kategori
  Future<List<BeritaModel>> getBeritaByKategori(String kategori) async {
    try {
      final response = await _supabase
          .from('berita')
          .select()
          .eq('kategori', kategori)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => BeritaModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil berita by kategori: $e');
    }
  }

  // Search berita
  Future<List<BeritaModel>> searchBerita(String query) async {
    try {
      final response = await _supabase
          .from('berita')
          .select()
          .or('title.ilike.%$query%,intro_text.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => BeritaModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mencari berita: $e');
    }
  }
}