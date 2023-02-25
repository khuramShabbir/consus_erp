import 'dart:async';

import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/Services/ApiServices/api_urls.dart';
import 'package:consus_erp/data/database_helper.dart';
import 'package:consus_erp/model/region.dart';
import 'package:consus_erp/model/sale_person.dart';
import 'package:consus_erp/model/shops_model.dart';
import 'package:consus_erp/model/user.dart';
import 'package:consus_erp/model/visits_model.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx/core/state_management/state_management.dart';
import 'package:intl/intl.dart';

class VisitsListController extends FxController {
  SalePerson? salePerson;
  Region? region;
  ShopsModel? shops;
  List<SalePerson> spList = [];
  List<ShopsModel> shopsList = [];
  List<Region> regionList = [];
  User user = new User();
  SalePerson salePersonData = new SalePerson();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController searchItemsController = TextEditingController();
  bool isAdmin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<AppVisitsList>> getVisitsSalePersonSupervisorWise(
      int RegionID, int SalePersonID, int ShopID, DateTime FromDate, DateTime ToDate) async {
    List<AppVisitsList> lst = [];
    try {
      String response = await ApiServices.getMethodApi(
          "${ApiUrls.IMPORT_VISITS_LIST_SALE_PERSON_WISE}?RegionID=$RegionID&SalePersonID=$SalePersonID&ShopID=$ShopID&FromDate=$FromDate&ToDate=$ToDate");
      if (response.isEmpty) {
        return lst;
      }
      //Info.startProgress();
      var apiResponseFromJson = visitsListApiResponseFromJson(response);
      //Info.stopProgress();
      if (apiResponseFromJson.data != null) {
        lst.addAll(apiResponseFromJson.data!);
      }
    } catch (e) {
      Info.stopProgress();
    }
    return lst;
  }

  Future<List<SalePerson>> getSalePersonSupervisorWise(int spId) async {
    List<SalePerson> lst = [];
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_SALE_PERSONS}?spid=$spId");
    if (response.isEmpty) {
      return lst;
    }

    var apiResponseFromJson = salePersonApiResponseFromJson(response);

    if (apiResponseFromJson.data != null) {
      lst.addAll(apiResponseFromJson.data!);
    }
    return lst;
  }

  Future<List<ShopsModel>> getShopsSalePersonRouteWise(int spId, int route) async {
    List<ShopsModel> lst = [];
    String response = await ApiServices.getMethodApi(
        "${ApiUrls.IMPORT_SHOPS_SALE_PERSONS_ROUTE}?spid=$spId&route=$route");
    if (response.isEmpty) {
      return lst;
    }

    var apiResponseFromJson = shopsApiResponseFromJson(response);

    if (apiResponseFromJson.data != null) {
      lst.addAll(apiResponseFromJson.data!);
    }
    return lst;
  }

  Future getUserData() async {
    // user = await StorageLocal.getUser();
    salePersonData = await DatabaseHelper.instance.getSalePersonByUserID(user.userID!);
  }

  void salePersonOnChanged(SalePerson sp) {
    salePerson = sp;
    print('Sale person id on changed is : ${salePerson!.salePersonID}');
  }

  void shopsOnChanged(ShopsModel shop) {
    shops = shop;
    print('Shop id on changed is : ${shops!.shopID}');
  }

  void regionOnChanged(Region r) {
    region = r;
    print('Region id on changed is : ${region!.regionID}');
  }

  Future getData(int spId, int route) async {
    spList = await getSalePersonSupervisorWise(spId);
    shopsList = await getShopsSalePersonRouteWise(spId, route);
    if (spList.isNotEmpty) {
      salePerson = spList[0];
    }
    if (shopsList.isNotEmpty) {
      shops = shopsList[0];
    }
  }

  DateTime formatDate(String pDate) {
    DateFormat inputFormat = DateFormat("dd-MM-yyyy");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = inputFormat.parse(pDate);
    String outputDateString = outputFormat.format(dateTime);
    return DateTime.parse(outputDateString);
  }

  @override
  String getTag() {
    return "visits_controller";
  }
}
