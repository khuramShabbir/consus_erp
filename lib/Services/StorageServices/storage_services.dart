import 'package:get_storage/get_storage.dart';

final box = GetStorage();

class LocalStorage {
  static String userData = "userData";
  static String remember = "remember";
  static String ADD_SHOP = "add_shop";
  static String ADD_ORDERS = "add_orders";
  static String Add_Items = "add_items";
  static final box = GetStorage();

  static String SAVE_ALL_SHOPS = "saveAllShops";

  static String AREAS="AREAS";

  static String Trade_Channel="Trade_Channel";

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
