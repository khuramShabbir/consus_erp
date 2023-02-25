import 'package:consus_erp/Model/Shops/get_shops.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/Services/StorageServices/storage_services.dart';
import 'package:consus_erp/Widgets/DateTimePicker/date_picker.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ShopsProvider extends ChangeNotifier {
  TextEditingController dateFromCtrl = TextEditingController();
  TextEditingController dateToCtrl = TextEditingController();
  String dateFrom = "";
  TextEditingController regionCtrl = TextEditingController();
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

  Future<void> searchShops() async {
    searching = true;
    String response = await ApiServices.getMethodApi(
      "Shops/GetShopsList?SalePersonID=${LoginProvider.getUser().userId}"
      "&AreaID=0&RegionID=0&"
      "FromDate=${dateFrom}&"
      "ToDate=$dateTo",
    );
    searching = false;

    logger.i("<<<<<Search Shop>>>>>$response");
    if (response.isEmpty) return;
    notifyListeners();
  }

  Future<void> getShopsAndSave() async {
    searching = true;
    notifyListeners();
    await ApiServices.getMethodApi(
      "shops/GetShops?"
      "pSalePersonID=18"
      "&pAreaID=0"
      "&pRegionID=4"
      "&pFromDate=2020-09-06 11:07:42.523"
      "&pToDate=2022-09-06 11:07:42.523"
      "&startRowIndex=0"
      "&maximumRows=50",
    ).then((String value) async {
      searching = false;
      logger.i(value);

      getShopsData = getShopsFromJson(value);

      if (getShopsData == null || getShopsData?.error == true) {
        Info.error(getShopsData?.errorDetail ?? "Something Went Wrong");

        return null;
      }
      Info.successSnackBar("${getShopsData?.shopList.length} Shops Saved");

      if (getShopsData?.error != null && getShopsData?.error == false) {
        await box.write(LocalStorage.SAVE_ALL_SHOPS, value);
        getShopsFromLocal();
      }
      notifyListeners();

      return value;
    });
  }

  int? getShopsFromLocal() {
    if (!box.hasData(LocalStorage.SAVE_ALL_SHOPS)) return 0;

    final String shopsData = box.read(LocalStorage.SAVE_ALL_SHOPS);
    getShopsData = getShopsFromJson(shopsData);

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    return getShopsData?.shopList.length;
  }
}
