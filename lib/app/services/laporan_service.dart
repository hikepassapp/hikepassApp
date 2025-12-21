import 'dart:io';
import 'package:hikepass_app/app/models/laporan_model.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class LaporanService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String tableName = 'laporan';
  static const String bucketName = 'laporan-foto';

  Future<String?> uploadFoto(File foto) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(foto.path)}';
      final fileExt = path.extension(foto.path);
      final filePath = '$fileName$fileExt';

      await _supabase.storage.from(bucketName).upload(
            filePath,
            foto,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      final publicUrl = _supabase.storage.from(bucketName).getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Gagal upload foto: $e');
    }
  }

  Future<void> deleteFoto(String fotoUrl) async {
    try {
      final fileName = fotoUrl.split('/').last;
      await _supabase.storage.from(bucketName).remove([fileName]);
    } catch (e) {
      throw Exception('Gagal hapus foto: $e');
    }
  }

  Future<LaporanModel> createLaporan(LaporanModel laporan) async {
    try {
      final response = await _supabase
          .from(tableName)
          .insert(laporan.toJson())
          .select()
          .single();

      return LaporanModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal membuat laporan: $e');
    }
  }

  Future<List<LaporanModel>> getAllLaporan({
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _supabase
          .from(tableName)
          .select()
          .order('created_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;

      return (response as List)
          .map((item) => LaporanModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data laporan: $e');
    }
  }

  Future<LaporanModel?> getLaporanById(String id) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('id', id)
          .single();

      return LaporanModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil laporan: $e');
    }
  }

  Future<LaporanModel> updateLaporan(String id, LaporanModel laporan) async {
    try {
      final response = await _supabase
          .from(tableName)
          .update(laporan.toJson())
          .eq('id', id)
          .select()
          .single();

      return LaporanModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal update laporan: $e');
    }
  }
  Future<void> deleteLaporan(String id) async {
    try {
      await _supabase.from(tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal hapus laporan: $e');
    }
  }

  Future<List<LaporanModel>> searchLaporan(String keyword) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .or('nama_pelapor.ilike.%$keyword%,lokasi_kejadian.ilike.%$keyword%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => LaporanModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Gagal mencari laporan: $e');
    }
  }

  Future<List<LaporanModel>> getLaporanByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .gte('tanggal_kejadian', startDate.toIso8601String().split('T')[0])
          .lte('tanggal_kejadian', endDate.toIso8601String().split('T')[0])
          .order('tanggal_kejadian', ascending: false);

      return (response as List)
          .map((item) => LaporanModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil laporan berdasarkan tanggal: $e');
    }
  }
}