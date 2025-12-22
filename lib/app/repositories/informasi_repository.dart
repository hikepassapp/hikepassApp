import '../config/supabase_config.dart';
import '../models/informasi_model.dart';
import 'package:flutter/foundation.dart';

class InformasiRepository {
  final _supabase = SupabaseConfig.client;

  // Get informasi by kategori dengan contents
  Future<InformasiModel?> getInformasiByKategori(String kategori) async {
    try {
      debugPrint('🔍 Fetching informasi for kategori: $kategori');
      
      // Query dengan join ke informasi_content
      final response = await _supabase
          .from('informasi')
          .select('''
            id,
            kategori,
            image_url,
            urutan,
            created_at,
            updated_at,
            informasi_content (
              id,
              informasi_id,
              title,
              description,
              urutan,
              created_at,
              updated_at
            )
          ''')
          .eq('kategori', kategori)
          .order('urutan', ascending: true)
          .single();

      debugPrint('✅ Found informasi: ${response['kategori']}');
      debugPrint('   Contents: ${response['informasi_content'].length} items');

      return InformasiModel.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('❌ Error getInformasiByKategori: $e');
      debugPrint('StackTrace: $stackTrace');
      throw Exception('Gagal mengambil informasi: $e');
    }
  }

  // Get all informasi dengan contents
  Future<List<InformasiModel>> getAllInformasi() async {
    try {
      debugPrint('🔍 Fetching all informasi...');
      
      final response = await _supabase
          .from('informasi')
          .select('''
            id,
            kategori,
            image_url,
            urutan,
            created_at,
            updated_at,
            informasi_content (
              id,
              informasi_id,
              title,
              description,
              urutan,
              created_at,
              updated_at
            )
          ''')
          .order('urutan', ascending: true);

      debugPrint('✅ Found ${response.length} informasi records');

      return (response as List)
          .map((data) => InformasiModel.fromJson(data))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('❌ Error getAllInformasi: $e');
      debugPrint('StackTrace: $stackTrace');
      throw Exception('Gagal mengambil semua informasi: $e');
    }
  }

  // Get informasi by ID
  Future<InformasiModel?> getInformasiById(String id) async {
    try {
      debugPrint('🔍 Fetching informasi by ID: $id');
      
      final response = await _supabase
          .from('informasi')
          .select('''
            id,
            kategori,
            image_url,
            urutan,
            created_at,
            updated_at,
            informasi_content (
              id,
              informasi_id,
              title,
              description,
              urutan,
              created_at,
              updated_at
            )
          ''')
          .eq('id', id)
          .single();

      debugPrint('✅ Found informasi: ${response['kategori']}');

      return InformasiModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error getInformasiById: $e');
      throw Exception('Gagal mengambil informasi: $e');
    }
  }

  // Get only contents by informasi_id
  Future<List<InformasiContent>> getContentsByInformasiId(String informasiId) async {
    try {
      debugPrint('🔍 Fetching contents for informasi_id: $informasiId');
      
      final response = await _supabase
          .from('informasi_content')
          .select()
          .eq('informasi_id', informasiId)
          .order('urutan', ascending: true);

      debugPrint('✅ Found ${response.length} contents');

      return (response as List)
          .map((data) => InformasiContent.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('❌ Error getContentsByInformasiId: $e');
      throw Exception('Gagal mengambil contents: $e');
    }
  }

  // Insert informasi baru (Admin only)
  Future<InformasiModel> createInformasi({
    required String kategori,
    required String imageUrl,
    int urutan = 0,
  }) async {
    try {
      debugPrint('➕ Creating new informasi: $kategori');
      
      final response = await _supabase
          .from('informasi')
          .insert({
            'kategori': kategori,
            'image_url': imageUrl,
            'urutan': urutan,
          })
          .select()
          .single();

      debugPrint('✅ Informasi created successfully');

      return InformasiModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error createInformasi: $e');
      throw Exception('Gagal membuat informasi: $e');
    }
  }

  // Insert content baru (Admin only)
  Future<InformasiContent> createContent({
    required String informasiId,
    required String title,
    required String description,
    int urutan = 0,
  }) async {
    try {
      debugPrint('➕ Creating new content for informasi: $informasiId');
      
      final response = await _supabase
          .from('informasi_content')
          .insert({
            'informasi_id': informasiId,
            'title': title,
            'description': description,
            'urutan': urutan,
          })
          .select()
          .single();

      debugPrint('✅ Content created successfully');

      return InformasiContent.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error createContent: $e');
      throw Exception('Gagal membuat content: $e');
    }
  }

  // Update informasi (Admin only)
  Future<void> updateInformasi(String id, Map<String, dynamic> updates) async {
    try {
      debugPrint('🔄 Updating informasi: $id');
      
      await _supabase
          .from('informasi')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      debugPrint('✅ Informasi updated successfully');
    } catch (e) {
      debugPrint('❌ Error updateInformasi: $e');
      throw Exception('Gagal update informasi: $e');
    }
  }

  // Update content (Admin only)
  Future<void> updateContent(String id, Map<String, dynamic> updates) async {
    try {
      debugPrint('🔄 Updating content: $id');
      
      await _supabase
          .from('informasi_content')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      debugPrint('✅ Content updated successfully');
    } catch (e) {
      debugPrint('❌ Error updateContent: $e');
      throw Exception('Gagal update content: $e');
    }
  }

  // Delete informasi (akan cascade delete contents juga)
  Future<void> deleteInformasi(String id) async {
    try {
      debugPrint('🗑️ Deleting informasi: $id');
      
      await _supabase
          .from('informasi')
          .delete()
          .eq('id', id);

      debugPrint('✅ Informasi deleted successfully');
    } catch (e) {
      debugPrint('❌ Error deleteInformasi: $e');
      throw Exception('Gagal delete informasi: $e');
    }
  }

  // Test connection
  Future<bool> testConnection() async {
    try {
      debugPrint('🧪 Testing informasi connection...');
      
      await _supabase
          .from('informasi')
          .select('id')
          .limit(1);
      
      debugPrint('✅ Informasi connection successful!');
      return true;
    } catch (e) {
      debugPrint('❌ Informasi connection failed: $e');
      return false;
    }
  }
}