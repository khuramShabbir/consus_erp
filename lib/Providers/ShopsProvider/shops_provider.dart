import 'dart:convert';

import '/Model/Shops/get_shops.dart';
import '/Model/Shops/shop_model.dart';
import '/Providers/ShopsProvider/add_new_shop_provider.dart';
import '/Providers/UserAuth/login_provider.dart';
import '/Services/ApiServices/api_services.dart';
import '/Services/StorageServices/storage_services.dart';
import '/Widgets/DateTimePicker/date_picker.dart';
import '/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ShopsProvider extends ChangeNotifier {
  TextEditingController dateFromCtrl = TextEditingController();
  TextEditingController dateToCtrl = TextEditingController();
  String dateFrom = "";
  TextEditingController regionCtrl = TextEditingController();
  TextEditingController areaCtrl = TextEditingController();
  TextEditingController shopSearchCtrl = TextEditingController();
  String dateTo = "";
  GetShops? getShopsData;

  void searchShop(String value) {
    shopSearchCtrl.text = value;
    logger.i(shopSearchCtrl.text);
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

  List<ShopData> shopList=<ShopData>[];


  Future<void> getShopsViaPagination() async {
    getShopsData=null;
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

      if (getShopsData?.error != null && getShopsData?.error == false) {


        getShopsData!.shopList.forEach((element) {

          shopList.add(element);

        });

        // getShopsData!.shopList.forEach((element) {
       //
       //   shopList.add(element);
       //
       //
       // });

        logger.e(shopList.length);


        getMoreShops(getShopsData!.shopList.first);

      }
      notifyListeners();

      return value;
    });
  }

  int startRow = 0;
  int maxRow = 500;
  double progressValue = 0;

  void getMoreShops(ShopData? shopData) async {
    progressValue = 0;

    if (shopData!.totalRows! <= maxRow) {
      searching = false;

      startRow=0;
      maxRow = 500;
    await  saveShopsToLocal();
     getShopsFromLocal();


      Info.successSnackBar("${shopList.length} Shops Saved");

      return;
    } else {
      startRow = maxRow;
      maxRow = startRow + 501;
      logger.wtf("Row  $startRow > $maxRow" );

      updateProgressValue(shopData.totalRows!.toDouble(), maxRow.toDouble());

      await getShopsViaPagination();
    }
  }

  Future<void> saveShopsToLocal()async{
    final je=json.encode(shopList);
    logger.wtf(je);

     await box.write(LocalStorage.SAVE_ALL_SHOPS, je);









  }


  void updateProgressValue(double maxValue, double currentValue) {
    if (currentValue / maxValue > 1.0) return;
    progressValue = currentValue / maxValue;
    logger.i(progressValue);

    notifyListeners();
  }

  int? getShopsFromLocal() {
    if (!box.hasData(LocalStorage.SAVE_ALL_SHOPS)) return 0;

    final String shopsData = box.read(LocalStorage.SAVE_ALL_SHOPS);
    // getShopsData = getShopsFromJson(shopsData);

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    // return getShopsData?.shopList.length;
    return 0;
  }
}
