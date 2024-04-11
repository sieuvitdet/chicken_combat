import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

class GenerateHash {
  static String encryptString(String plainText, String key) {
    final keyBytes = utf8.encode(key);
    final keyDigest = md5.convert(keyBytes);
    final iv = List.filled(16, 0);

    final cipher = AESFastEngine();
    final cbc = CBCBlockCipher(cipher);
    final params = ParametersWithIV<KeyParameter>(KeyParameter(Uint8List.fromList(keyDigest.bytes)), Uint8List.fromList(iv));

    cbc.init(true, params);

    final plainBytes = utf8.encode(plainText);
    final paddedData = padData(plainBytes);
    final encryptedBytes = cbc.process(Uint8List.fromList(paddedData));
    return base64.encode(encryptedBytes);
  }

  static String decryptString(String encryptedText, String key) {
    final keyBytes = utf8.encode(key);
    final keyDigest = md5.convert(keyBytes);
    final iv = List.filled(16, 0);

    final cipher = AESFastEngine();
    final cbc = CBCBlockCipher(cipher);
    final params = ParametersWithIV<KeyParameter>(KeyParameter(Uint8List.fromList(keyDigest.bytes)), Uint8List.fromList(iv));

    cbc.init(false, params);

    final encryptedBytes = base64.decode(encryptedText);
    final decryptedBytes = cbc.process(Uint8List.fromList(encryptedBytes));
    final unpaddedData = removePadding(decryptedBytes);
    return utf8.decode(unpaddedData);
  }

  static List<int> padData(List<int> data) {
    final padLength = 16 - (data.length % 16);
    final paddedData = List<int>.from(data);
    for (var i = 0; i < padLength; i++) {
      paddedData.add(padLength);
    }
    return paddedData;
  }

  static List<int> removePadding(List<int> paddedData) {
    final padLength = paddedData.last;
    return paddedData.sublist(0, paddedData.length - padLength);
  }
}
