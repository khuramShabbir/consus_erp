import 'dart:async';

import 'package:consus_erp/data/database_helper.dart';
import 'package:consus_erp/model/shops_model.dart';
import 'package:consus_erp/model/user.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../model/area.dart';
import '../model/sale_person.dart';
import '../model/trade_channel.dart';

class ShopsController extends FxController {
  int selectedRecordId = 0;
  int shopsID = 0;
  String vpo = "LOW";
  String seo = "BROWN";
  String currentAddress = "";
  Position? currentPosition;
  SalePerson? salePerson;
  Area? area;
  User user = User();
  SalePerson salePersonData = SalePerson();
  TradeChannel? tradeChannel;
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController geoLocation = TextEditingController();
  TextEditingController shopName = TextEditingController();
  TextEditingController shopCode = TextEditingController();
  TextEditingController contactPerson = TextEditingController();
  TextEditingController contactNo = TextEditingController();
  TextEditingController ntnNo = TextEditingController();
  TextEditingController route = TextEditingController();
  List<SalePerson> spList = [];
  List<Area> areaList = [];
  List<TradeChannel> tcList = [];
  ShopsModel shopsModel = new ShopsModel();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Info.errorSnackBar(
          'Location services are disabled. Please enable location services in order to save Shop.');
      await Future.delayed(Duration(seconds: 3));
      //await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Info.errorSnackBar('Location permission is denied. Allow the app to use your location.');
        await Future.delayed(Duration(seconds: 3));
        return false;
      }
      if (permission == LocationPermission.deniedForever) {
        Info.errorSnackBar(
            'Location permissions are permanently denied, go to settings and give this app permission manually to proceed with Shop.');
        return false;
      }
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    Info.startProgress();
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
      getAddressFromLatAndLong(currentPosition!);
      Info.stopProgress();
    }).catchError((e) {
      Info.stopProgress();
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatAndLong(Position position) async {
    List<Placemark> placemarks = await GeocodingPlatform.instance.placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude,
        localeIdentifier: "en");
    Placemark place = placemarks[0];
    currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    latitude.text = position.latitude.toString();
    longitude.text = position.longitude.toString();
    geoLocation.text = currentAddress;
  }

  void getTradeChannel() async {
    List<TradeChannel> tc = await DatabaseHelper.instance.getTcs();
    tcList.clear();
    tcList.addAll(tc);
  }

  void clearControls() {
    selectedRecordId = 0;
    shopsID = 0;
    shopsModel = new ShopsModel();
    salePerson = null;
    area = null;
    tradeChannel = null;
    getArea(0);
    getSalePerson(0);
    getTradeChannel();
    latitude = TextEditingController(text: '');
    longitude = TextEditingController(text: '');
    geoLocation = TextEditingController(text: '');
    shopName = TextEditingController(text: '');
    shopCode = TextEditingController(text: '');
    contactPerson = TextEditingController(text: '');
    contactNo = TextEditingController(text: '');
    ntnNo = TextEditingController(text: '');
    route = TextEditingController(text: '');
    vpo = "LOW";
    seo = "BROWN";
  }

  // Future getUserData() async {
  //   // user = await StorageLocal.getUser();
  //   salePersonData = await DatabaseHelper.instance.getSalePersonByUserID(user.userID!);
  // }

  Future fillDropDowns() async {
    if (user.isSalesPerson != null && user.isSalesPerson == true) {
      if (salePersonData.parentID! == 0) {
        await getSuperVisors(salePersonData.salePersonID!);
        await getAreaBySalePerson(salePersonData.salePersonID!, 0);
      } else {
        await getSalePerson(salePersonData.salePersonID!);
        await getAreaBySalePerson(salePersonData.salePersonID!, salePersonData.regionID!);
      }
    } else {
      await getSalePerson(0);
      await getArea(0);
    }
    getTradeChannel();
  }

  Future getSalePerson(int id) async {
    List<SalePerson> sp = await DatabaseHelper.instance.fillSalePersonsById(id);
    spList.clear();
    spList.addAll(sp);
  }

  Future getSuperVisors(int id) async {
    List<SalePerson> sp = await DatabaseHelper.instance.fillSuperVisorsById(id);
    spList.clear();
    spList.addAll(sp);
  }

  Future getArea(int id) async {
    List<Area> a = await DatabaseHelper.instance.fillAreaByAreaId(id);
    areaList.clear();
    areaList.addAll(a);
  }

  Future getAreaBySalePerson(int spId, regionId) async {
    List<Area> a = [];
    if (regionId != 0) {
      a = await DatabaseHelper.instance.fillAreasBySalePersonsById(spId, regionId);
    } else {
      a = await DatabaseHelper.instance.fillSuperVisorsAreas(spId, regionId);
    }
    areaList.clear();
    areaList.addAll(a);
  }

  void vpoOnChanged(String value) {
    vpo = value;
  }

  void seoOnChanged(String value) {
    seo = value;
  }

  void tcOnChanged(TradeChannel tc) {
    tradeChannel = tc;
  }

  Future<bool> insertShops() async {
    double long = 0, lat = 0;
    final locationPermission = await handleLocationPermission();
    if (locationPermission) {
      await getCurrentPosition();
      await DatabaseHelper.instance.insertShops(ShopsModel(
          shopID: 0,
          shopName: shopName.text,
          shopCode: shopCode.text,
          contactPerson: contactPerson.text,
          contactNo: contactNo.text,
          nTNNO: ntnNo.text,
          areaID: area == null ? 0 : area!.areaID,
          salePersonID: (salePerson == null) ? 0 : salePerson!.salePersonID,
          longitiude: longitude.text.isEmpty ? long : double.parse(longitude.text),
          latitiude: latitude.text.isEmpty ? lat : double.parse(latitude.text),
          googleAddress: geoLocation.text,
          tradeChannelID: (tradeChannel == null) ? 0 : tradeChannel!.tradeChannelID,
          route: route.text.isEmpty ? 0 : int.parse(route.text),
          vPO: vpo,
          sEO: seo,
          imageUrl: "",
          entryDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          createdOn: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          updatedOn: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          IsModify: 1));
      return true;
    } else {
      return false;
    }
  }

  Future updateShop() async {
    double long = 0, lat = 0;
    await DatabaseHelper.instance.updateShop(ShopsModel(
        ID: selectedRecordId,
        shopID: shopsID,
        shopName: shopName.text,
        shopCode: shopCode.text,
        contactPerson: contactPerson.text,
        contactNo: contactNo.text,
        nTNNO: ntnNo.text,
        regionID: shopsModel.regionID != null ? shopsModel.regionID : 0,
        areaID: area!.areaID,
        salePersonID:
            (salePerson == null || salePerson!.salePersonID == null) ? 0 : salePerson!.salePersonID,
        createdByID: shopsModel.createdByID != null ? shopsModel.createdByID : 0,
        updatedByID: shopsModel.updatedByID != null ? shopsModel.updatedByID : 0,
        systemNotes: shopsModel.systemNotes != null ? shopsModel.systemNotes : "",
        remarks: shopsModel.remarks != null ? shopsModel.remarks : "",
        description: shopsModel.description != null ? shopsModel.description : "",
        entryDate: shopsModel.entryDate,
        branchID: shopsModel.branchID != null ? shopsModel.branchID : 0,
        longitiude: longitude.text.isEmpty ? long : double.parse(longitude.text),
        latitiude: latitude.text.isEmpty ? lat : double.parse(latitude.text),
        googleAddress: geoLocation.text,
        tradeChannelID: (tradeChannel == null || tradeChannel!.tradeChannelID == null)
            ? 0
            : tradeChannel!.tradeChannelID,
        route: route.text.isEmpty ? 0 : int.parse(route.text),
        vPO: vpo,
        sEO: seo,
        imageUrl: "",
        createdOn: shopsModel.createdOn,
        updatedOn: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        IsModify: 1));
  }

  void salePersonGet(int id) async {
    SalePerson sp = await DatabaseHelper.instance.getSalePersonById(id);
    salePerson = sp;
  }

  void areaGet(int id) async {
    Area a = await DatabaseHelper.instance.getAreaById(id);
    area = a;
  }

  void tradeChannelGet(int id) async {
    TradeChannel tc = await DatabaseHelper.instance.getTcById(id);
    tradeChannel = tc;
  }

  void openRecord() async {
    shopsModel = await DatabaseHelper.instance.getShopById(selectedRecordId);
    if (shopsModel.ID != null || shopsModel.ID != 0) {
      salePersonGet(shopsModel.salePersonID!);
      shopName.text = shopsModel.shopName == null ? "" : shopsModel.shopName!;
      shopCode.text = shopsModel.shopCode == null ? "" : shopsModel.shopCode!;
      contactPerson.text = shopsModel.contactPerson == null ? "" : shopsModel.contactPerson!;
      contactNo.text = shopsModel.contactNo == null ? "" : shopsModel.contactNo!;
      ntnNo.text = shopsModel.nTNNO == null ? "" : shopsModel.nTNNO!;
      areaGet(shopsModel.areaID!);
      tradeChannelGet(shopsModel.tradeChannelID!);
      route.text = shopsModel.route == null ? "0" : shopsModel.route!.toString();
      vpo = shopsModel.vPO == null ? "" : shopsModel.vPO!;
      seo = shopsModel.sEO == null ? "" : shopsModel.sEO!;
      longitude.text = shopsModel.longitiude == null ? "0" : shopsModel.longitiude!.toString();
      latitude.text = shopsModel.latitiude == null ? "0" : shopsModel.latitiude!.toString();
      geoLocation.text = shopsModel.googleAddress == null ? "" : shopsModel.googleAddress!;
    }
  }

  void spOnSelected(SalePerson sp) {
    salePerson = sp;
    print(salePerson!.salePersonID);
  }

  void areaOnSelected(Area a) {
    area = a;
    print(area!.areaID);
  }

  @override
  String getTag() {
    return "shops_controller";
  }
}
