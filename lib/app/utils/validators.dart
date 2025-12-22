import 'package:get/get.dart';

class Validators {
  // NIK Validation (Indonesian National ID)
  static String? validateNIK(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIK tidak boleh kosong';
    }

    // Remove spaces
    final nik = value.replaceAll(' ', '');

    // Check length
    if (nik.length != 16) {
      return 'NIK harus 16 digit';
    }

    // Check if all characters are numeric
    if (!RegExp(r'^[0-9]+$').hasMatch(nik)) {
      return 'NIK harus berupa angka';
    }

    // Validate province code (2 first digits)
    final provinceCode = int.parse(nik.substring(0, 2));
    if (provinceCode < 11 || provinceCode > 94) {
      return 'Kode provinsi NIK tidak valid';
    }

    // Validate birth date (DDMMYY at position 6-11)
    try {
      final day = int.parse(nik.substring(6, 8));
      final month = int.parse(nik.substring(8, 10));
      final year = int.parse(nik.substring(10, 12));

      // Female NIK adds 40 to day
      final actualDay = day > 40 ? day - 40 : day;

      if (actualDay < 1 || actualDay > 31) {
        return 'Tanggal lahir dalam NIK tidak valid';
      }
      if (month < 1 || month > 12) {
        return 'Bulan lahir dalam NIK tidak valid';
      }
      // Year validation (assuming people are born between 1930-2024)
      if (year > 24 && year < 30) {
        return 'Tahun lahir dalam NIK tidak valid';
      }
    } catch (e) {
      return 'Format tanggal lahir dalam NIK tidak valid';
    }

    return null;
  }

  // Phone Number Validation (Indonesian format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    // Remove spaces, dashes, and parentheses
    String phone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if starts with +62 or 0
    if (!phone.startsWith('+62') && !phone.startsWith('0')) {
      return 'Nomor telepon harus diawali +62 atau 0';
    }

    // Normalize to format without country code
    String normalizedPhone = phone;
    if (phone.startsWith('+62')) {
      normalizedPhone = '0${phone.substring(3)}';
    }

    // Check length (10-13 digits including leading 0)
    if (normalizedPhone.length < 10 || normalizedPhone.length > 13) {
      return 'Nomor telepon harus 10-13 digit';
    }

    // Check if all characters are numeric (after normalization)
    if (!RegExp(r'^0[0-9]+$').hasMatch(normalizedPhone)) {
      return 'Nomor telepon harus berupa angka';
    }

    // Validate Indonesian operator prefixes
    final validPrefixes = [
      '0811',
      '0812',
      '0813',
      '0814',
      '0815',
      '0816',
      '0817',
      '0818',
      '0819', // Telkomsel
      '0821', '0822', '0823', '0851', '0852', '0853', // Telkomsel Simpati/AS
      '0831', '0832', '0833', '0838', // Axis
      '0895', '0896', '0897', '0898', '0899', // Three
      '0881',
      '0882',
      '0883',
      '0884',
      '0885',
      '0886',
      '0887',
      '0888',
      '0889', // Smartfren
      '0857', '0858', // Indosat IM3
      '0814', '0815', '0816', // Indosat Matrix
      '0855', '0856', // Indosat Mentari
      '0817', '0818', '0819', '0859', '0878', // XL
    ];

    final prefix = normalizedPhone.substring(0, 4);
    bool isValidPrefix = validPrefixes.any(
      (p) => normalizedPhone.startsWith(p.substring(0, 4)),
    );

    if (!isValidPrefix) {
      return 'Prefix operator tidak valid';
    }

    return null;
  }

  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    // Basic email format validation
    if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid';
    }

    // Block disposable email services
    final disposableDomains = [
      'tempmail.com',
      'guerrillamail.com',
      '10minutemail.com',
      'throwaway.email',
      'mailinator.com',
      'temp-mail.org',
      'fakeinbox.com',
      'trashmail.com',
      'maildrop.cc',
      'yopmail.com',
    ];

    final domain = value.split('@').last.toLowerCase();
    if (disposableDomains.contains(domain)) {
      return 'Email sementara tidak diperbolehkan';
    }

    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung huruf kecil';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }

    return null;
  }

  // Confirm Password Validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Password tidak cocok';
    }

    return null;
  }

  // Name Validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }

    if (value.length > 100) {
      return 'Nama maksimal 100 karakter';
    }

    // Check if contains only letters, spaces, and some special characters
    if (!RegExp(r"^[a-zA-Z\s\'\.\-]+$").hasMatch(value)) {
      return 'Nama hanya boleh mengandung huruf';
    }

    return null;
  }

  // Address Validation
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat tidak boleh kosong';
    }

    if (value.length < 10) {
      return 'Alamat minimal 10 karakter';
    }

    if (value.length > 500) {
      return 'Alamat maksimal 500 karakter';
    }

    return null;
  }

  // Image File Validation
  static String? validateImageFile(String filePath, int fileSizeInBytes) {
    // Check file size (max 5MB)
    const maxSizeInBytes = 5 * 1024 * 1024; // 5MB
    if (fileSizeInBytes > maxSizeInBytes) {
      return 'Ukuran file maksimal 5MB';
    }

    // Check file extension
    final validExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.heic'];
    final extension = filePath.toLowerCase().split('.').last;

    bool isValidExtension = validExtensions.any(
      (ext) => filePath.toLowerCase().endsWith(ext),
    );

    if (!isValidExtension) {
      return 'Format file harus JPG, PNG, WEBP, atau HEIC';
    }

    return null;
  }
}
