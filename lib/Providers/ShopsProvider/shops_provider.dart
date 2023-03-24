import 'dart:convert';

import 'package:consus_erp/Providers/ShopsProvider/add_new_shop_provider.dart';
import 'package:consus_erp/Widgets/DropDownField/dropdown_textfield.dart';
import 'package:provider/provider.dart';

import '/Model/Shops/get_shops.dart';
import '/Model/Shops/shop_model.dart';
import '/Providers/UserAuth/login_provider.dart';
import '/Services/ApiServices/api_services.dart';
import '/Services/StorageServices/storage_services.dart';
import '/Widgets/DateTimePicker/date_picker.dart';
import '/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


AddNewShopProvider addNewShopProvider = Provider.of<AddNewShopProvider>(Get.context!, listen: false);


class ShopsProvider extends ChangeNotifier {
  TextEditingController dateFromCtrl = TextEditingController();
  TextEditingController dateToCtrl = TextEditingController();
  String dateFrom = "";
  TextEditingController regionCtrl = TextEditingController();
  TextEditingController areaCtrl = TextEditingController();
  TextEditingController shopsValue = TextEditingController();
  TextEditingController shopSearchCtrl = TextEditingController();
  String dateTo = "";
  GetShops? getShopsData;
  int totalShops = 0;
  List<DropDownValueModel> lstShops = <DropDownValueModel>[];

  void searchShop(String value) {
    shopSearchCtrl.text = value;
    notifyListeners();
  }

  Future<void> getFromDate() async {
    DateTime? dateTime = await AppDateTimePicker.getDate(Get.context!);

    if (dateTime == null) return;
    dateFrom = dateTime.toString();
    dateFromCtrl.text = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  Future<void> getToDate() async {
    DateTime? dateTime = await AppDateTimePicker.getDate(Get.context!);

    if (dateTime == null) return;
    dateTo = dateTime.toString();

    dateToCtrl.text = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  bool searching = false;

  List<ShopData> shopList = <ShopData>[];

  Future<void> getShopsViaPagination() async {
    searching = true;
    notifyListeners();
    await ApiServices.getMethodApi(
      "shops/GetShops?"
      "pSalePersonID=${LoginProvider.getUser().salePersonId}"
      "&pAreaID=0"
      "&pRegionID=${LoginProvider.getUser().regionId}"
      "&startRowIndex=$startRow"
      "&maximumRows=$maxRow",
    ).then((String value) async {
      getShopsData = getShopsFromJson(value);

      if (getShopsData == null || getShopsData?.error == true) {
        Info.error(getShopsData?.errorDetail ?? "Something Went Wrong");
        return null;
      }
      if (getShopsData != null && getShopsData?.error != null && getShopsData?.error == false) {
        if (getShopsData!.shopList.isNotEmpty)
          getShopsData!.shopList.forEach((element) {
            shopList.add(element);
          });
        getMoreShops(getShopsData!.shopList);
      }
      notifyListeners();

      return value;
    });
  }

  int startRow = 0;
  int maxRow = 500;
  double progressValue = 0;

  void getMoreShops(List<ShopData> shopData) async {
    progressValue = 0;

    if (shopData.isNotEmpty) {
      if (shopData.first.totalRows != null &&
          startRow < shopData.first.totalRows! &&
          (getShopsData!.shopList.isNotEmpty)) {
        startRow = startRow + 500;
        logger.i(startRow);
        updateProgressValue(shopData.first.totalRows!.toDouble(), startRow.toDouble());

        await getShopsViaPagination();
      }
    } else {
      searching = false;
      startRow = 0;
      await saveShopsToLocal();
      getShopsFromLocal();

    }
  }

  Future<void> saveShopsToLocal() async {
    Map<String, dynamic> getShops = GetShops(shopList: shopList).toJson();
    String je = json.encode(getShops);
    await box.write(LocalStorage.SAVE_ALL_SHOPS, je);
    shopList=<ShopData>[];
    notifyListeners();
  }

  void updateProgressValue(double maxValue, double currentValue) {
    if (currentValue / maxValue > 1.0) return;
    progressValue = currentValue / maxValue;

    notifyListeners();
  }

  void getShopsFromLocal() async {
    if (!box.hasData(LocalStorage.SAVE_ALL_SHOPS)) return;
    String data = await box.read(LocalStorage.SAVE_ALL_SHOPS);
    getShopsData = getShopsFromJson(data);
    Future.delayed(Duration.zero, () {});
    totalShops = getShopsData!.shopList.length;
    notifyListeners();
  }

  void fillShopsDropDown() async{
    lstShops = <DropDownValueModel>[];
    if(!LocalStorage.box.hasData(LocalStorage.SAVE_ALL_SHOPS)) return;
    String data = await LocalStorage.box.read(LocalStorage.SAVE_ALL_SHOPS);
    getShopsData = getShopsFromJson(data);
    getShopsData?.shopList.forEach((element) {
      lstShops.add(DropDownValueModel(name: element!.shopName!, value: element.shopId));
    });
    Future.delayed(Duration.zero, ()=>notifyListeners());
  }
}
