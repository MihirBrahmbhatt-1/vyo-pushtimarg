import 'package:encrypt/encrypt.dart';

Key cryptKeyString = Key.fromUtf8("kbsX-PYY.=!*-.cH");
final iv = IV.fromUtf8("EaH#ty)b1VkJZdvp");

String encryptInputParams(String inputString) {
  final encrypter = Encrypter(
    AES(
      cryptKeyString,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ),
  );
  final encrypted = encrypter.encrypt(
    inputString,
    iv: iv,
  );
  return encrypted.base64.toString();
}

String decryptApiResponse(dynamic apiResponseString) {
  final encrypter = Encrypter(
    AES(
      cryptKeyString,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ),
  );
  final decrypted = encrypter.decrypt(
    Encrypted.fromBase64(apiResponseString.toString()),
    iv: iv,
  );
  return decrypted;
}
