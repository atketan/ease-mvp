import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateShort12CharUniqueKey() {
  var uuid = Uuid();
  String uuidString = uuid.v4();
  var bytes = utf8.encode(uuidString);
  var digest = sha256.convert(bytes);
  return digest.toString().substring(0, 12);
}
