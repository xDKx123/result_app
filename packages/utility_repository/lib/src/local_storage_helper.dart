import 'dart:convert';
import 'package:localstorage/localstorage.dart';

///Class to interact with local storage
class LocalStorageHelper {
  static LocalStorage _storage = new LocalStorage('my_data');

  LocalStorageHelper._privateConstructor();

  static final LocalStorageHelper instance = LocalStorageHelper._privateConstructor();

  Future<LocalStorage> get storage async {
    if (_storage != null) {
      return _storage;
    }
    _storage = LocalStorage('my_data');
    return _storage;
  }

  static Future<void> clearStorage() async {
    await _storage.ready;
    await _storage.clear();
  }

  ///Saving token in local storage
  static Future<void> setToken(String token) async {
    await _storage.ready;
    LocalStorage ls = await instance.storage;
    ls.setItem('token', token);
  }

  ///Get token from local storage
  static Future<String> getToken() async {
    await _storage.ready;
    LocalStorage ls = await instance.storage;
    //print(ls.getItem('token'));
    return ls.getItem('token') ?? "";
  }

  ///Save contracts
  static Future<void> setContracts(dynamic posts) async {
    await _storage.ready;
    LocalStorage ls = await instance.storage;
    ls.setItem('posts', jsonEncode(posts));
    //jsonEncode(posts);
  }

  ///Retrive contracts from local storage
  static Future<dynamic> getContracts() async {
    await _storage.ready;
    LocalStorage ls = await instance.storage;
    return jsonDecode(ls.getItem('posts') ?? {});
  }
}