import 'package:consus_erp/Model/Orders/get_orders.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/Services/ApiServices/api_urls.dart';
import 'package:consus_erp/Services/StorageServices/storage_services.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/material.dart';

class OrdersProvider extends ChangeNotifier{
  GetOrdersData? getOrdersData;
  int startRowIndex = 0, maximumRows = 500, totalOrders = 0, totalRows = 0;
  double progressValue = 0;
  bool searching = false;
  List<OrdersModel> lstOrders = <OrdersModel>[];
  TextEditingController txtSearchOrders = TextEditingController(text: '');

  void searchOrders(String value){
    txtSearchOrders.text = value;
    notifyListeners();
  }

  Future<void> getOrdersList() async{
    if(LocalStorage.box.hasData(LocalStorage.userData)){
      searching = true;
      notifyListeners();
      await ApiServices.getMethodApi(
          "${ApiUrls.GET_ORDERS_LIST}?SalePersonID=${LoginProvider.getUser().salePersonId}"
              "&RegionID=0"
              "&startRowIndex=$startRowIndex"
              "&maximumRows=$maximumRows"
      ).then((value) {
        getOrdersData = getOrdersDataFromJson(value);
        if(getOrdersData == null || getOrdersData?.error == true){
          Info.errorSnackBar('Something Went Wrong. Please Try Again Later.');
          return null;
        }
        if(getOrdersData != null && getOrdersData?.error != null
            && getOrdersData?.error == false && getOrdersData?.data != null){
          if(getOrdersData!.data!.isNotEmpty){
            getOrdersData?.data!.forEach((element) {
              lstOrders.add(element);
            });
            getMoreOrders(getOrdersData!.data!);
          }
        }
        else{
          searching = false;
          saveOrdersToLocal();
          getOrdersFromLocal();
          startRowIndex = 0;
          progressValue = 0;
        }
        notifyListeners();
        return value;
      });
    }
  }

  void getMoreOrders(List<OrdersModel> orders) async{
    if(orders.isNotEmpty){
      if(orders.first.TotalRows != null && startRowIndex < orders.first.TotalRows!
      && (getOrdersData!.data!.isNotEmpty)){
        totalRows = orders.first.TotalRows!;
        startRowIndex += 500;
        logger.i(startRowIndex);
        updateProgressValue(orders.first.TotalRows!.toDouble(), startRowIndex.toDouble());
        await getOrdersList();
      }
    }
    else{
      startRowIndex=0;
      searching=false;
      await saveOrdersToLocal();
      getOrdersFromLocal();
    }
  }

  Future<void> saveOrdersToLocal() async{
    String jsonEncode = getOrdersDataToJson(GetOrdersData(data: lstOrders));
    await LocalStorage.box.write(LocalStorage.ADD_ORDERS, jsonEncode);
    lstOrders = <OrdersModel>[];
    notifyListeners();
  }

  void getOrdersFromLocal() async{
    if(!LocalStorage.box.hasData(LocalStorage.ADD_ORDERS)) return;
    String data = await LocalStorage.box.read(LocalStorage.ADD_ORDERS);
    getOrdersData = getOrdersDataFromJson(data);
    Future.delayed(Duration.zero, (){});
    totalOrders = getOrdersData!.data!.length;
    notifyListeners();
  }

  void updateProgressValue(double maxValue, double currentValue){
    if(currentValue/maxValue > 1.0) {
      return;
    }
    progressValue = currentValue/maxValue;
    notifyListeners();
  }
}