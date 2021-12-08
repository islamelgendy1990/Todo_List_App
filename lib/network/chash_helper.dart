
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {

  static SharedPreferences ?_sharedPreferences ;

  static init () async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }


  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is String) return await _sharedPreferences!.setString(key, value);
    if (value is int) return await _sharedPreferences!.setInt(key, value);
    if (value is List) return await _sharedPreferences!.setStringList(key, []);
    if (value is bool) {
       return await _sharedPreferences!.setBool(key, value);
    } else {
      return await _sharedPreferences!.setDouble(key, value);
    }
  }


  static List<String>? getData ({
    required String key,
  })
  {
    return _sharedPreferences!.getStringList(key);
  }


}




// static Future<bool> putData ({
// @required String? key,
// @required String? value,
// }) async
// {
// return await _sharedPreferences!.setString(key!, value!);
// }