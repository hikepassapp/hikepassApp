import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageOptimizationService {
  // Compress and optimize image
  static Future<File?> optimizeImage({
    required File imageFile,
    int maxWidth = 1024,
    int maxHeight = 1024,
    int quality = 85,
  }) async {
    try {
      // Get file extension
      final String fileExtension = path.extension(imageFile.path).toLowerCase();

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed$fileExtension',
      );

      // Compress image
      final Uint8List? compressedBytes =
          await FlutterImageCompress.compressWithFile(
            imageFile.path,
            minWidth: maxWidth,
            minHeight: maxHeight,
            quality: quality,
            format: _getCompressFormat(fileExtension),
          );

      if (compressedBytes == null) {
        return null;
      }

      // Write compressed bytes to file
      final File compressedFile = File(targetPath);
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      print('Error optimizing image: $e');
      return null;
    }
  }

  // Get compress format based on file extension
  static CompressFormat _getCompressFormat(String extension) {
    switch (extension) {
      case '.png':
        return CompressFormat.png;
      case '.webp':
        return CompressFormat.webp;
      case '.heic':
      case '.heif':
        return CompressFormat.heic;
      default:
        return CompressFormat.jpeg;
    }
  }

  // Validate image dimensions
  static Future<Map<String, int>?> getImageDimensions(File imageFile) async {
    try {
      await imageFile.readAsBytes();
      // This is a simplified version - in production, use image package
      // to get actual dimensions
      return {'width': 0, 'height': 0};
    } catch (e) {
      print('Error getting image dimensions: $e');
      return null;
    }
  }

  // Calculate file size in MB
  static Future<double> getFileSizeInMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  // Check if image needs optimization
  static Future<bool> needsOptimization(
    File imageFile, {
    double maxSizeMB = 2.0,
  }) async {
    final sizeMB = await getFileSizeInMB(imageFile);
    return sizeMB > maxSizeMB;
  }
}
