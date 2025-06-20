import 'dart:io' as io;

import 'package:cloudinary/cloudinary.dart';
import 'package:file_picker/file_picker.dart'; // For PlatformFile
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

/// A service to handle file uploads to Cloudinary using the cloudinary package.
class CloudinaryService {
  static const cloudName = 'dlxgqufqm';

  final Cloudinary _cloudinary = Cloudinary.signedConfig(
    cloudName: cloudName,
    apiKey: '429321265474726',
    apiSecret: 'SIHKNIA-kvnKER8oz24-qE2PFJY',
  );

  /// Uploads a single [PlatformFile] to Cloudinary using unsigned upload.
  ///
  /// Returns the secure URL of the uploaded file.
  Future<String> uploadFile(PlatformFile file) async {
    // if (file.bytes == null) {
    //   throw ArgumentError('File bytes cannot be null: ${file.name}');
    // }

    final response = await _cloudinary.upload(
      file: file.path,
      fileBytes: file.bytes,
      resourceType: CloudinaryResourceType.image,

      fileName: file.name,
      progressCallback: (count, total) {
        print('Uploading image from file with progress: $count/$total');
      },
    );

    if (response.isSuccessful) {
      print('Get your image from with ${response.secureUrl}');
    }

    if (response.isSuccessful && response.secureUrl != null) {
      return response.secureUrl!;
    } else {
      throw Exception(
        'Cloudinary upload failed: ${response.error ?? 'Unknown error'}',
      );
    }
  }

  /// Uploads multiple [PlatformFile]s and returns a list of secure URLs.
  Future<List<String>> uploadFiles(List<PlatformFile> files) async {
    final validFiles = files.where((file) => file.bytes != null).toList();
    if (validFiles.isEmpty) return [];

    return Future.wait(validFiles.map(uploadFile));
  }

  /// Converts an asset file into a [PlatformFile].

  Future<PlatformFile> loadAssetAsPlatformFile({
    required String assetPath,
    required String fileName,
  }) async {
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();

    if (kIsWeb) {
      // On web, use bytes directly; no filesystem
      return PlatformFile(
        name: fileName,
        size: bytes.length,
        bytes: bytes,
        path: null, // not used on web
      );
    } else {
      // On mobile/desktop, write to temp file and return path
      final tempDir = await io.Directory.systemTemp.createTemp();
      final tempFile = io.File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(bytes, flush: true);

      return PlatformFile(
        name: fileName,
        size: bytes.length,
        path: tempFile.path,
        bytes: null, // uses path for lazy loading
      );
    }
  }
}
