import 'package:get_storage/get_storage.dart';

final box = GetStorage();

class LocalStorage {
  static String userData = "userData";
  static String remember = "remember";
  static String ADD_SHOP = "add_shop";
  static final box = GetStorage();

  static String SAVE_ALL_SHOPS = "saveAllShops";

  static String AREAS="AREAS";

  /// Instance of GetStorage

  /// Write Data Against String Key
  static Future write(String key, dynamic value) async {
    await box.write(key, value);
  }

  /// Read Data Against String Key
  static Future read(String key) async {
    await box.read(key);
  }

  /// Remove Data Against String Key
  static Future remove(String key) async {
    await box.remove(key);
  }

  /// Remove Whole Data Container Without Any Key
  static Future erase() async {
    await box.erase();
  }
}
