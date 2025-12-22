import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorHandlingService extends GetxService {
  // Connection status
  final isOnline = true.obs;
  StreamSubscription? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityMonitoring();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  // Monitor internet connectivity
  void _initConnectivityMonitoring() {
    // Check connectivity periodically
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      final wasOnline = isOnline.value;
      isOnline.value = await checkConnectivity();

      // Show notification when connection status changes
      if (wasOnline && !isOnline.value) {
        _showOfflineSnackbar();
      } else if (!wasOnline && isOnline.value) {
        _showOnlineSnackbar();
      }
    });
  }

  // Check internet connectivity
  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  void _showOfflineSnackbar() {
    Get.snackbar(
      'Tidak Ada Koneksi',
      'Anda sedang offline. Beberapa fitur mungkin tidak tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[900],
      icon: const Icon(Icons.wifi_off, color: Colors.orange),
      duration: const Duration(seconds: 5),
      isDismissible: true,
    );
  }

  void _showOnlineSnackbar() {
    Get.snackbar(
      'Koneksi Tersambung',
      'Anda kembali online',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
      icon: const Icon(Icons.wifi, color: Colors.green),
      duration: const Duration(seconds: 2),
    );
  }

  // Retry mechanism for operations
  Future<T> retryOperation<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    String? operationName,
  }) async {
    int attemptCount = 0;

    while (attemptCount < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attemptCount++;

        if (attemptCount >= maxRetries) {
          // Max retries reached, show error
          handleError(e, operationName: operationName);
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(retryDelay);

        // Show retry notification
        Get.snackbar(
          'Mencoba Lagi...',
          'Percobaan $attemptCount dari $maxRetries',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue[100],
          colorText: Colors.blue[900],
          duration: const Duration(seconds: 2),
        );
      }
    }

    throw Exception('Max retries reached');
  }

  // Handle errors with user-friendly messages
  void handleError(dynamic error, {String? operationName}) {
    String title = 'Error';
    String message = 'Terjadi kesalahan. Silakan coba lagi.';
    Color backgroundColor = Colors.red[100]!;
    Color textColor = Colors.red[900]!;

    // Log error for debugging
    _logError(error, operationName);

    // Categorize errors
    if (error is SocketException) {
      title = 'Tidak Ada Koneksi';
      message = 'Periksa koneksi internet Anda dan coba lagi.';
      backgroundColor = Colors.orange[100]!;
      textColor = Colors.orange[900]!;
    } else if (error is TimeoutException) {
      title = 'Timeout';
      message = 'Operasi memakan waktu terlalu lama. Silakan coba lagi.';
    } else if (error is AuthException) {
      final authError = _handleAuthException(error);
      title = authError['title']!;
      message = authError['message']!;
    } else if (error is PostgrestException) {
      final postgrestError = _handlePostgrestException(error);
      title = postgrestError['title']!;
      message = postgrestError['message']!;
    } else if (error is StorageException) {
      final storageError = _handleStorageException(error);
      title = storageError['title']!;
      message = storageError['message']!;
    }

    // Show error to user
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: const Duration(seconds: 5),
      icon: Icon(Icons.error_outline, color: textColor),
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
    );
  }

  // Handle Supabase Auth exceptions
  Map<String, String> _handleAuthException(AuthException error) {
    String title = 'Error Autentikasi';
    String message = error.message;

    if (error.message.contains('Invalid login credentials')) {
      title = 'Login Gagal';
      message = 'Email atau password salah';
    } else if (error.message.contains('Email not confirmed')) {
      title = 'Email Belum Terverifikasi';
      message = 'Silakan verifikasi email Anda terlebih dahulu';
    } else if (error.message.contains('User already registered')) {
      title = 'Email Sudah Terdaftar';
      message =
          'Email ini sudah digunakan. Silakan login atau gunakan email lain';
    } else if (error.message.contains('Password should be at least')) {
      title = 'Password Terlalu Pendek';
      message = 'Password harus minimal 8 karakter';
    } else if (error.message.contains('Token has expired')) {
      title = 'Sesi Berakhir';
      message = 'Sesi Anda telah berakhir. Silakan login kembali';
    } else if (error.message.contains('Invalid token')) {
      title = 'Token Tidak Valid';
      message = 'Silakan login kembali';
    }

    return {'title': title, 'message': message};
  }

  // Handle Supabase Postgrest exceptions
  Map<String, String> _handlePostgrestException(PostgrestException error) {
    String title = 'Error Database';
    String message = 'Terjadi kesalahan saat menyimpan data';

    if (error.message.contains('duplicate key')) {
      title = 'Data Duplikat';
      message = 'Data yang Anda masukkan sudah ada';
    } else if (error.message.contains('foreign key')) {
      title = 'Data Tidak Valid';
      message = 'Terdapat kesalahan pada data yang dimasukkan';
    } else if (error.message.contains('violates check constraint')) {
      title = 'Format Data Salah';
      message = 'Format data yang dimasukkan tidak sesuai';
    }

    return {'title': title, 'message': message};
  }

  // Handle Supabase Storage exceptions
  Map<String, String> _handleStorageException(StorageException error) {
    String title = 'Error Upload';
    String message = 'Gagal mengupload file';

    if (error.message.contains('row-level security')) {
      title = 'Akses Ditolak';
      message = 'Anda tidak memiliki izin untuk mengupload file';
    } else if (error.message.contains('Payload too large')) {
      title = 'File Terlalu Besar';
      message = 'Ukuran file melebihi batas maksimal';
    } else if (error.message.contains('Invalid mime type')) {
      title = 'Format File Salah';
      message = 'Format file tidak didukung';
    }

    return {'title': title, 'message': message};
  }

  // Log errors (can be extended to send to crash reporting service)
  void _logError(dynamic error, String? operationName) {
    final timestamp = DateTime.now().toIso8601String();
    final operation = operationName ?? 'Unknown';

    print('========== ERROR LOG ==========');
    print('Timestamp: $timestamp');
    print('Operation: $operation');
    print('Error Type: ${error.runtimeType}');
    print('Error Message: $error');
    print('Stack Trace:');
    print(StackTrace.current);
    print('===============================');

    
  }

  // Show loading with timeout
  Future<T?> withLoadingTimeout<T>({
    required Future<T> Function() operation,
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    try {
      return await operation().timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException('Operation timed out', timeout);
        },
      );
    } catch (e) {
      handleError(e, operationName: operationName);
      return null;
    }
  }
}
