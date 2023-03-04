import 'dart:convert';

import 'package:consus_erp/Model/Shops/add_new_shop.dart';
import 'package:consus_erp/Model/Shops/shop_model.dart';
import 'package:consus_erp/Providers/LocationServices/location_provider.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/Services/ApiServices/api_urls.dart';
import 'package:consus_erp/Services/StorageServices/storage_services.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddNewShopProvider extends ChangeNotifier {

  TextEditingController salePersonCtrl = TextEditingController();
  TextEditingController shopNameCtrl = TextEditingController();
  TextEditingController shopCodeCtrl = TextEditingController();
  TextEditingController contactPersonCtrl = TextEditingController();
  TextEditingController contactNumberCtrl = TextEditingController();
  TextEditingController ntnNoCtrl = TextEditingController();
  TextEditingController areaCtrl = TextEditingController();
  TextEditingController tradeChanelCtrl = TextEditingController(text: "0");
  TextEditingController routeCtrl = TextEditingController();
  TextEditingController vpoCtrl = TextEditingController(text: "LOW");
  TextEditingController seoCtrl = TextEditingController(text: "BROWN");
  TextEditingController latLngCtrl = TextEditingController();
  TextEditingController geoLocationCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController remarksCtrl = TextEditingController();
  TextEditingController systemNotesCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Position? position;
  AddShopResponse? addShopResponse;

  /// Form Validation

  bool formValidation() {
    if (formKey.currentState!.validate()) return true;
    return false;
  }

  /// Get Current Location
  Future<bool> getCurrentPosition() async {
    position =
        await Provider.of<LocationProvider>(Get.context!, listen: false).getCurrentPosition();
    if (position == null) return false;

    latLngCtrl.text = "${position?.latitude},${position?.longitude}";
    geoLocationCtrl.text =
        "${Provider.of<LocationProvider>(Get.context!, listen: false).currentAddress}";

    return true;
  }

  /// Api call For Add Shop
  Future<bool> addShop() async {
    if (!formValidation() || position == null) return false;

    shopList = [];

    Map<String, String> fields = {
      "ShopID": "0",
      "ShopName": shopNameCtrl.text,
      "ShopCode": "",
      "ContactPerson": contactPersonCtrl.text,
      "ContactNo": contactNumberCtrl.text,
      "NTNNO": ntnNoCtrl.text,
      "SalePersonID": LoginProvider.getUser().salePersonId.toString(),
      "RegionID": LoginProvider.getUser().regionId.toString(),
      "AreaID": areaCtrl.text,
      "CreatedBYID": LoginProvider.getUser().userId.toString(),
      "UpdatedByID": LoginProvider.getUser().userId.toString(),
      "Description": descriptionCtrl.text,
      "Remarks": remarksCtrl.text,
      "SystemNotes": systemNotesCtrl.text,
      "EntryDate": DateTime.now().toString(),
      "BranchID": LoginProvider.getUser().branchId.toString(),
      "Latitiude": position!.latitude.toString(),
      "Longitiude": position!.longitude.toString(),
      "GoogleAddress": geoLocationCtrl.text,
      "CreatedOn": DateTime.now().toString(),
      "UpdatedOn": DateTime.now().toString(),
      "TradeChannelID": tradeChanelCtrl.text,
      "Route": routeCtrl.text,
      "VPO": vpoCtrl.text,
      "SEO": seoCtrl.text
    };

    shopList.add(fields);

    String response = await ApiServices.postRawMethodApiForLocal(shopList, ApiUrls.ADD_SHOP);
    logger.wtf("<<<<<<<add Shop>>>>>>>>$response");
    if (response.isEmpty) return false;
    shopList = [];
    // addShopResponse = addShopResponseFromJson(response);
    notifyListeners();
    clearCtrl();
    return true;
  }

  /// Save Shop Local Storage
  List shopList = [];

  Future<bool> saveShop() async {
    if (!formValidation() || position == null) return false;
    Map<String, String> fields = {
      "ShopID": "0",
      "ShopName": shopNameCtrl.text,
      "ShopCode": "",
      "ContactPerson": contactPersonCtrl.text,
      "ContactNo": contactNumberCtrl.text,
      "NTNNO": ntnNoCtrl.text,
      "SalePersonID": LoginProvider.getUser().salePersonId.toString(),
      "RegionID": LoginProvider.getUser().regionId.toString(),
      "AreaID": areaCtrl.text,
      "CreatedBYID": LoginProvider.getUser().userId.toString(),
      "UpdatedByID": LoginProvider.getUser().userId.toString(),
      "Description": descriptionCtrl.text,
      "Remarks": remarksCtrl.text,
      "SystemNotes": systemNotesCtrl.text,
      "EntryDate": DateTime.now().toString(),
      "BranchID": LoginProvider.getUser().branchId.toString(),
      "Latitiude": position!.latitude.toString(),
      "Longitiude": position!.longitude.toString(),
      "GoogleAddress": geoLocationCtrl.text,
      "CreatedOn": DateTime.now().toString(),
      "UpdatedOn": DateTime.now().toString(),
      "TradeChannelID": tradeChanelCtrl.text,
      "Route": routeCtrl.text,
      "VPO": vpoCtrl.text,
      "SEO": seoCtrl.text
    };

    logger.i(fields);

    if (box.hasData(LocalStorage.ADD_SHOP)) {
      shopList = box.read(LocalStorage.ADD_SHOP);
      shopList.add(fields);
      await box.write(LocalStorage.ADD_SHOP, shopList);
    } else {
      shopList.add(fields);

      await box.write(LocalStorage.ADD_SHOP, shopList);
    }

    clearCtrl();

    Info.successSnackBar("Shop Saved");

    return true;
  }

  bool loading = false;

  ///  Saved Shops
  Future<bool> submitSavedShop() async {
    try {
      loading = true;
      notifyListeners();
      if (box.hasData(LocalStorage.ADD_SHOP)) {
        shopList = box.read(LocalStorage.ADD_SHOP);

        if (shopList.isEmpty) return false;
        String response = await ApiServices.postRawMethodApiForLocal(shopList, ApiUrls.ADD_SHOP);

        if (response.isEmpty) return false;

        box.remove(LocalStorage.ADD_SHOP);
        shopList = [];
        shopDataList = <ShopData>[];
        Info.successSnackBar("Shops Submitted");

        notifyListeners();

        return true;
      }
    } catch (e) {
    } finally {
      loading = false;
      notifyListeners();
    }

    return false;
  }

  List<ShopData>? shopDataList;

  void getSavedShops() {
    shopList = [];

    if (box.hasData(LocalStorage.ADD_SHOP)) {
      shopList = jsonDecode(jsonEncode(box.read(LocalStorage.ADD_SHOP)));

      shopDataList = shopsListFromJson(json.encode(shopList));
    } else {}

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  /// Clear Controllers After Add Shop SuccessFully
  void clearCtrl() {
    shopCodeCtrl.clear();
    contactPersonCtrl.clear();
    contactNumberCtrl.clear();
    ntnNoCtrl.clear();
    areaCtrl.clear();
    tradeChanelCtrl.clear();
    routeCtrl.clear();
  }
}
