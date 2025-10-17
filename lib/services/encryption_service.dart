import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'secure_storage_service.dart';

class EncryptionHelper {
  static EncryptionHelper get instance => Get.find();

  static final EncryptionHelper _instance = EncryptionHelper._internal();
  factory EncryptionHelper() => _instance;
  EncryptionHelper._internal();

  final _secureStorage = SecureStorageService();
  static const _secretKeyKey = 'encryption_secret_key';

  Future<SecretKey> _getSecretKey() async {
    String? keyFromStorage = await _secureStorage.read(_secretKeyKey);
    if (keyFromStorage != null) {
      return SecretKey(base64Decode(keyFromStorage));
    }

    final newKey = await AesGcm.with256bits().newSecretKey();
    final keyBytes = await newKey.extractBytes();
    await _secureStorage.write(_secretKeyKey, base64Encode(keyBytes));
    return newKey;
  }

  Future<String> encrypt(String text) async {
    final secretKey = await _getSecretKey();
    final algorithm = AesGcm.with256bits();
    final nonce = algorithm.newNonce();

    final secretBox = await algorithm.encrypt(utf8.encode(text), secretKey: secretKey, nonce: nonce);

    // Combine nonce, ciphertext, and mac into one string for storage
    final combined = <String>[
      base64Encode(nonce),
      base64Encode(secretBox.cipherText),
      base64Encode(secretBox.mac.bytes),
    ];

    return combined.join(':');
  }

  Future<String?> decrypt(String encryptedText) async {
    try {
      final parts = encryptedText.split(':');
      if (parts.length != 3) {
        throw Exception('Invalid encrypted text format');
      }

      final nonce = base64Decode(parts[0]);
      final cipherText = base64Decode(parts[1]);
      final macBytes = base64Decode(parts[2]);

      final secretKey = await _getSecretKey();
      final algorithm = AesGcm.with256bits();

      final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));

      final decryptedBytes = await algorithm.decrypt(secretBox, secretKey: secretKey);

      return utf8.decode(decryptedBytes);
    } catch (e) {
      if (kDebugMode) {
        print('Decryption failed: $e');
      }
      return null;
    }
  }
}
