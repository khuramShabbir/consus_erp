import 'dart:convert';
import 'package:consus_erp/Model/Items/get_items.dart';
import 'package:consus_erp/Model/Orders/get_orders.dart';
import 'package:consus_erp/Providers/LocationServices/location_provider.dart';
import 'package:consus_erp/Providers/OrdersProvider/orders_provider.dart';
import 'package:consus_erp/Providers/ShopsProvider/add_new_shop_provider.dart';
import 'package:consus_erp/Providers/ShopsProvider/shops_provider.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/Services/ApiServices/api_urls.dart';
import 'package:consus_erp/Services/StorageServices/storage_services.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:math';

OrdersProvider orderProv = Provider.of<OrdersProvider>(Get.context!, listen: false);

class AddNewOrderProvider extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  TextEditingController txtRemarks = TextEditingController(text: '');
  TextEditingController txtLong = TextEditingController(text: '');
  TextEditingController txtLat = TextEditingController(text: '');
  TextEditingController shopId = TextEditingController();
  TextEditingController shopName = TextEditingController();
  List<ItemsModel> lstItems = <ItemsModel>[];
  GetItemsData? getItemsData;
  Position? position;
  double distance = 0, qty = 0;
  bool isAwayFromShop = false, isQtyZero = false;

  /// Create a map to store the text editing controllers for each item
  Map<int, TextEditingController> itemIdController = {};
  Map<int, TextEditingController> itemQtyController = {};


  /// Form Validation
  bool formValidation() {
    if (formKey.currentState!.validate()) return true;
    return false;
  }

  void getItemsFromLocal(){
    lstItems = <ItemsModel>[];
    if(!LocalStorage.box.hasData(LocalStorage.Add_Items)) return;
    String data = LocalStorage.box.read(LocalStorage.Add_Items);
    logger.i(data);
    getItemsData = getItemsDataFromJson(data);
    getItemsData!.data!.forEach((element) {
      lstItems.add(element);
    });
    Future.delayed(Duration.zero,()=>notifyListeners());
  }


  /// Create a new instance of TextEditingController for each item
  void initTextEditingControllers(){
    for(int i=0; i<lstItems.length; i++){
      itemIdController[i] = TextEditingController(text: lstItems[i].itemID.toString());
      itemQtyController[i] = TextEditingController(text: '');
    }
  }

  void printControllersValues(){
    itemIdController.forEach((key, value) {
      logger.i("<<Item ID index is $key>> and value is ${value.text}");
    });
    itemQtyController.forEach((key, value) {
      logger.i("<<Qty index is $key>> and value is ${value.text}");
    });
  }

  /// Get Current Location
  Future<bool> getCurrentPosition() async {
    position = await Provider.of<LocationProvider>(Get.context!, listen: false).getCurrentPosition();
    if (position == null) return false;

    txtLong.text = "${position?.longitude}";
    txtLat.text = "${position?.latitude}";

    return true;
  }


  /// Calculate distance between shop and order location
  double calculateDistance(lat2, lon2, int shopId){
    if(lstItems.isEmpty) {
      distance = -1;
      isAwayFromShop = true;
      notifyListeners();
      return 0;
    }
    distance = 0;
    var shop = Provider.of<ShopsProvider>(Get.context!, listen: false).getShopsData?.shopList.where(
      (element) => element.shopId == shopId
    ).toList();
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - shop?.first.latitiude) * p)/2 +
        cos(shop!.first!.latitiude! * p) * cos(lat2 * p) *
            (1 - cos((lon2 - shop?.first.longitiude) * p))/2;
    distance =  1000 * 12742 * asin(sqrt(a));
    if(distance.round() > 200 || distance.round() < 0)
      isAwayFromShop = true;
    else isAwayFromShop = false;
    notifyListeners();
    logger.i("<<Distance against shopId is ${distance.round()}>>");
    return distance;
  }

  /// New Record
  void newRecord() async{
    distance = 0;
    qty = 0;
    isAwayFromShop = false;
    isQtyZero = false;
    txtRemarks.text = '';
    Future.delayed(Duration.zero, ()=>notifyListeners());
  }

  void setQtyFlag(bool value){
    isQtyZero = value;
    notifyListeners();
  }

  void setDistanceFlag(bool value){
    isAwayFromShop = value;
    notifyListeners();
  }

  /// Save Orders To Local
  Future<bool> saveOrderToLocal() async{
    if(!formValidation() || position == null) return false;
    List<Map<String, String>> lstDetail = [];
    for(int i = 0; i<lstItems.length ; i++){
      Map<String, String> detail = {
        "OrderDetailID" : "0",
        "OrderID" : "0",
        "ItemID" : itemIdController[i]!.text.isEmpty ? "0" : itemIdController[i]!.text,
        "Qty" : itemQtyController[i]!.text.isEmpty ? "0.0" : itemQtyController[i]!.text
      };
      lstDetail.add(detail);
    }
    Map<String, dynamic> order = {
      "OrdersDetail" : lstDetail,
      "OrderID" : "0",
      "OrderNo" : "",
      "ShopID" : shopId.text,
      "OrderDate" : DateTime.now().toString(),
      "ShopName" : shopName.text,
      "SalePersonID" : LoginProvider.getUser().salePersonId.toString(),
      "RegionID" : LoginProvider.getUser().regionId.toString(),
      "SalePersonName" : LoginProvider.getUser().fullName.toString(),
      "SalePersonFullName" : LoginProvider.getUser().fullName.toString(),
      "GoogleAddress" : "",
      "Remarks" : txtRemarks.text,
      "SystemNotes" : "",
      "RegionName" : "",
      "CreatedBy" : LoginProvider.getUser().userId.toString(),
      "UpdatedBy" : "0",
      "Longitude" : txtLong.text,
      "Latitude" : txtLat.text,
      "CreatedOn" : DateTime.now().toString(),
      "UpdatedOn" : DateTime.now().toString(),
      "Qty" : qty,
      "Verify" : false.toString(),
      "ImageAddress" : "",
      "TotalRows" : "0",
      "isSync" : false.toString()
    };
    OrdersModel ordersModel = OrdersModel.fromJson(order);
    if (LocalStorage.box.hasData(LocalStorage.ADD_ORDERS)) {
      String data = LocalStorage.box.read(LocalStorage.ADD_ORDERS);
      GetOrdersData getOrders = getOrdersDataFromJson(data);
      getOrders?.data!.insert(0, ordersModel);
      Map<String, dynamic> orderMap = GetOrdersData(data: getOrders.data).toJson();
      String je = json.encode(orderMap);
      await box.write(LocalStorage.ADD_ORDERS, je);
      orderProv.getOrdersFromLocal();
    } else {
      return false;
    }
    Info.successSnackBar("Order Saved Successfully");
    return true;
  }

  ///  Saved Orders
  List<OrdersModel> unSyncedOrders = <OrdersModel>[];
  Future<bool> submitSavedOrders() async {
    unSyncedOrders = <OrdersModel>[];
    if (LocalStorage.box.hasData(LocalStorage.ADD_ORDERS)) {
      String data = LocalStorage.box.read(LocalStorage.ADD_ORDERS);
      GetOrdersData getOrders = getOrdersDataFromJson(data);
      getOrders.data!.forEach((element) {
        if (element.isSync == false) {
          unSyncedOrders.add(element);
        }
      });

      if (unSyncedOrders.isNotEmpty) {
        String response = await ApiServices.postRawMethodApiForLocal(unSyncedOrders, ApiUrls.Save_Orders);
        logger.wtf("<<<<<<<add Orders>>>>>>>>$response");
        if (response.isEmpty) return false;
        notifyListeners();
      }
    }

    return false;
  }


  /// Calculate Order Detail Qty
  void calculateDetailQty(){
    qty = 0;
    if(lstItems.isNotEmpty && itemIdController.isNotEmpty && itemQtyController.isNotEmpty){
      for(int i = 0; i<itemQtyController.length ; i++){
        qty += itemQtyController[i]!.text.isEmpty ? 0 : double.parse(itemQtyController[i]!.text);
      }
      notifyListeners();
      if(qty == 0) isQtyZero = true;
      else isQtyZero = false;
      notifyListeners();
      logger.i("<<Detail qty is $qty>>");
    }
  }
}