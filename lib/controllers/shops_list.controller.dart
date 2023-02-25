import 'dart:async';

import 'package:consus_erp/data/database_helper.dart';
import 'package:consus_erp/model/area.dart';
import 'package:consus_erp/model/region.dart';
import 'package:consus_erp/model/shops_model.dart';
import 'package:consus_erp/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../model/sale_person.dart';

class ShopsListController extends FxController {
  SalePerson? salePerson;
  Region? region;
  Area? area;
  User user = new User();
  SalePerson salePersonData = new SalePerson();
  List<SalePerson> spList = [];
  List<Region> regionList = [];
  List<Area> areaList = [];
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController searchItemsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    fromDate = TextEditingController(text: '');
    toDate = TextEditingController(text: '');
    searchItemsController = TextEditingController(text: '');
    super.initState();
  }

  Future getUserData() async {
    // user = await StorageLocal.getUser();
    salePersonData = await DatabaseHelper.instance.getSalePersonByUserID(user.userID!);
  }

  Future fillDropDowns() async {
    if (user.isSalesPerson != null && user.isSalesPerson == true) {
      if (salePersonData.parentID! == 0) {
        await getSuperVisors(salePersonData.salePersonID!);
        await getSuperVisorsRegion(salePersonData.salePersonID!);
      } else {
        await getSalePerson(salePersonData.salePersonID!);
        await getRegion(salePersonData.regionID!);
        await getAreaBySalePerson(salePersonData.salePersonID!, salePersonData.regionID!);
      }
    } else {
      await getSalePerson(0);
      await getRegion(0);
    }
  }

  Future<List<ShopsModel>> getShops() async {
    return await DatabaseHelper.instance.getShops();
  }

  Future getSalePerson(int id) async {
    List<SalePerson> sp = await DatabaseHelper.instance.fillSalePersonsById(id);
    spList.clear();
    spList.addAll(sp);
    if (user.isSalesPerson != null && user.isSalesPerson == true) {
      salePerson = spList.isNotEmpty ? spList[0] : null;
    }
  }

  Future getSuperVisors(int id) async {
    List<SalePerson> sp = await DatabaseHelper.instance.fillSuperVisorsById(id);
    spList.clear();
    spList.addAll(sp);
    salePerson = salePersonData;
  }

  Future getRegion(int id) async {
    List<Region> reg = await DatabaseHelper.instance.fillRegionByRegionId(id);
    regionList.clear();
    regionList.addAll(reg);
    if (user.isSalesPerson != null && user.isSalesPerson == true) {
      region = regionList.isNotEmpty ? regionList[0] : null;
    }
  }

  Future getSuperVisorsRegion(int id) async {
    List<Region> reg = await DatabaseHelper.instance.fillSuperVisorsRegionById(id);
    regionList.clear();
    regionList.addAll(reg);
    //region = regionList.isNotEmpty ? regionList[0] : null;
  }

  Future getArea(int id) async {
    List<Area> a = await DatabaseHelper.instance.fillAreaByAreaId(id);
    areaList.clear();
    areaList.addAll(a);
  }

  Future getAreaBySalePerson(int spId, regionId) async {
    List<Area> a = await DatabaseHelper.instance.fillAreasBySalePersonsById(spId, regionId);
    areaList.clear();
    areaList.addAll(a);
    area = areaList.isNotEmpty ? areaList[0] : null;
  }

  void salePersonOnChanged(SalePerson sp) {
    salePerson = sp;
    print(salePerson!.salePersonID);
  }

  void regionOnChanged(Region r) {
    region = r;
    print(region!.regionID);
  }

  void areaOnChanged(Area a) {
    area = a;
    print(area!.areaID);
  }

  void clearControls() {
    user = new User();
    salePersonData = new SalePerson();
    salePerson = null;
    area = null;
    region = null;
  }

  @override
  String getTag() {
    return "shops_list_controller";
  }
}
