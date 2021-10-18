import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  final _storage = FlutterSecureStorage();

  String key ;

  UserSecureStorage({this.key});


  Future<String> getIdToken() async => await _storage.read(key: key);
}

