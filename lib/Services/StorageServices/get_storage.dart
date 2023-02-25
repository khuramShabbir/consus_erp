// import 'package:consus_erp/model/user.dart';
// import 'package:get_storage/get_storage.dart';
//
// class StorageLocal {
//   static final box = GetStorage();
//
//   static Future write(String key, dynamic value) async {
//     await box.write(key, value);
//   }
//
//   static Future read(String key) async {
//     await box.read(key);
//   }
//
//   static Future remove(String key) async {
//     await box.remove(key);
//   }
//
//   static Future erase() async {
//     await box.erase();
//   }
//
//   static User getUser() {
//     User userAuthModel =
//     User.fromJson(box.read(StorageKeys.userData));
//     return userAuthModel;
//   }
//
//   static Future<void> saveUser(User user) async {
//     await box.write(StorageKeys.userData, user.toJson());
//   }
// }
//
// class StorageKeys {
//   static String userData = "userData";
//   static String remember = "remember";
// }
