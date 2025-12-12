import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static const String secretKey =
      'LegacySyncApp2024SecretKey123456'; // 32 characters for AES-256

  /// Encrypts a string using simple XOR encryption with hash
  static String encryptString(String plainText) {
    try {
      // Convert the secret key to bytes
      final keyBytes = utf8.encode(secretKey);
      final keyHash = sha256.convert(keyBytes).bytes;

      // Convert plain text to bytes
      final plainBytes = utf8.encode(plainText);

      // XOR encryption
      final encryptedBytes = <int>[];
      for (int i = 0; i < plainBytes.length; i++) {
        encryptedBytes.add(plainBytes[i] ^ keyHash[i % keyHash.length]);
      }

      // Convert to base64 for storage
      return base64.encode(encryptedBytes);
    } catch (e) {
      print('Encryption error: $e');
      return plainText; // Return original if encryption fails
    }
  }

  /// Decrypts a string using simple XOR decryption with hash
  static String decryptString(String encryptedText) {
    try {
      // Convert the secret key to bytes
      final keyBytes = utf8.encode(secretKey);
      final keyHash = sha256.convert(keyBytes).bytes;

      // Decode from base64
      final encryptedBytes = base64.decode(encryptedText);

      // XOR decryption
      final decryptedBytes = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ keyHash[i % keyHash.length]);
      }

      // Convert back to string
      return utf8.decode(decryptedBytes);
    } catch (e) {
      print('Decryption error: $e');
      return encryptedText; // Return original if decryption fails
    }
  }

  /// Encrypts JSON data
  static String encryptJson(Map<String, dynamic> jsonData) {
    final jsonString = json.encode(jsonData);
    return encryptString(jsonString);
  }

  /// Decrypts JSON data
  static Map<String, dynamic>? decryptJson(String encryptedData) {
    try {
      final decryptedString = decryptString(encryptedData);
      return json.decode(decryptedString) as Map<String, dynamic>;
    } catch (e) {
      print('JSON decryption error: $e');
      return null;
    }
  }
}
