import 'dart:convert';

import 'package:consus_erp/Model/Shops/add_new_shop.dart';
import 'package:consus_erp/Model/Shops/get_shops.dart';
import 'package:consus_erp/Model/Shops/shop_model.dart';
import 'package:consus_erp/Providers/LocationServices/location_provider.dart';
import 'package:consus_erp/Providers/ShopsProvider/shops_provider.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/Services/ApiServices/api_urls.dart';
import 'package:consus_erp/Services/StorageServices/storage_services.dart';
import 'package:consus_erp/Widgets/DropDownField/dropdown_textfield.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

ShopsProvider shopProv = Provider.of<ShopsProvider>(Get.context!, listen: false);

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
  TextEditingController vpoCtrl = TextEditingController(text: "");
  TextEditingController seoCtrl = TextEditingController(text: "");
  TextEditingController latLngCtrl = TextEditingController();
  TextEditingController geoLocationCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController remarksCtrl = TextEditingController();
  TextEditingController systemNotesCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Position? position;
  AddShopResponse? addShopResponse;

  /// VPO LIST
  List<DropDownValueModel> vpoList = <DropDownValueModel>[
    DropDownValueModel(name: 'NONE', value: ''),
    DropDownValueModel(name: 'LOW', value: 'LOW'),
    DropDownValueModel(name: 'MEDIUM', value: 'MEDIUM'),
    DropDownValueModel(name: 'HIGH', value: 'HIGH'),
  ];

  /// SEO LIST
  List<DropDownValueModel> seoList = <DropDownValueModel>[
    DropDownValueModel(name: 'NONE', value: ''),
    DropDownValueModel(name: 'BROWN', value: 'BROWN'),
    DropDownValueModel(name: 'SILVER', value: 'SILVER'),
    DropDownValueModel(name: 'GOLDEN', value: 'GOLDEN'),
    DropDownValueModel(name: 'DIAMOND', value: 'DIAMOND'),
  ];

  /// Form Validation

  bool formValidation() {
    if (formKey.currentState!.validate()) return true;
    return false;
  }

  /// Get Current Location
  Future<bool> getCurrentPosition() async {
    position = await Provider.of<LocationProvider>(Get.context!, listen: false).getCurrentPosition();
    if (position == null) return false;

    latLngCtrl.text = "${position?.latitude},${position?.longitude}";
    geoLocationCtrl.text = "${Provider.of<LocationProvider>(Get.context!, listen: false).currentAddress}";

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
      "SEO": seoCtrl.text,
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
      "SEO": seoCtrl.text,
      "isSync": false.toString(),
    };
    ShopData shopData = ShopData.fromJson(fields);
    if (LocalStorage.box.hasData(LocalStorage.SAVE_ALL_SHOPS)) {
      String data = LocalStorage.box.read(LocalStorage.SAVE_ALL_SHOPS);
      GetShops getShops = getShopsFromJson(data);
      getShops.shopList.insert(0, shopData);
      Map<String, dynamic> shopMap = GetShops(shopList: getShops.shopList).toJson();
      String je = json.encode(shopMap);
      await box.write(LocalStorage.SAVE_ALL_SHOPS, je);
      shopProv.getShopsFromLocal();
    } else {
      return false;
    }

    clearCtrl();
    Info.successSnackBar("Shop Saved");
    return true;
  }

  bool loading = false;

  ///  Saved Shops
  List<ShopData> unSyncShops = <ShopData>[];

  Future<bool> submitSavedShop() async {
    unSyncShops = <ShopData>[];
    if (LocalStorage.box.hasData(LocalStorage.SAVE_ALL_SHOPS)) {
      String data = LocalStorage.box.read(LocalStorage.SAVE_ALL_SHOPS);
      GetShops getShops = getShopsFromJson(data);
      getShops.shopList.forEach((element) {
        if (element.isSync == false) {
          unSyncShops.add(element);
        }
      });

      if (unSyncShops.isNotEmpty) {
        String response = await ApiServices.postRawMethodApiForLocal(unSyncShops, ApiUrls.ADD_SHOP);
        logger.wtf("<<<<<<<add Shop>>>>>>>>$response");
        if (response.isEmpty) return false;
        shopList = [];
        notifyListeners();
        clearCtrl();
      }
    }

    return false;
  }

  List<ShopData> shopDataList = <ShopData>[];

  void getSavedShops() {
    shopList = [];

    if (box.hasData(LocalStorage.ADD_SHOP)) {
      shopList = json.decode(json.encode(box.read(LocalStorage.ADD_SHOP)));
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
    routeCtrl.clear();
  }
}
