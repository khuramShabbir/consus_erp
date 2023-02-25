import 'package:flutx/flutx.dart';

enum ShopStatus { close, open }

class ProfileController extends FxController {
  late ShopStatus shopStatus;

  ProfileController() {
    shopStatus = ShopStatus.open;
  }

  void changeShopStatus(ShopStatus shopStatus) {
    this.shopStatus = shopStatus;
    update();
  }

  @override
  String getTag() {
    return "profile_controller";
  }
}
