import 'package:encrypt/encrypt.dart';

Key cryptKeyString = Key.fromUtf8("c7-2z8DF4]T#jUY4");
final iv = IV.fromUtf8("M>!8Y}D==?ZXj)+x");

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
