//
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CashHelper {
//
//   static SharedPreferences ?_sharedPreferences ;
//
//   static init () async {
//     _sharedPreferences = await SharedPreferences.getInstance();
//   }
//
//
//   static Future<bool> saveData(
//       {required String key, required List value}) async {
//
//      return await _sharedPreferences!.setStringList(key, []);
//
//   }
//
//
//   static List<String>? getData ({
//     required String key,
//   })
//   {
//     return _sharedPreferences!.getStringList(key);
//   }
//
//
// }
//
//
//
//
// // static Future<bool> putData ({
// // @required String? key,
// // @required String? value,
// // }) async
// // {
// // return await _sharedPreferences!.setString(key!, value!);
// // }