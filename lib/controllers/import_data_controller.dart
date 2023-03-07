import 'dart:async';

import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/data/database_helper.dart';
import 'package:consus_erp/model/sale_person.dart';
import 'package:flutx/flutx.dart';
import 'package:intl/intl.dart';

import '/model/area.dart';
import '/model/branch.dart';
import '/model/items.dart';
import '/model/region.dart';
import '/model/shops_model.dart';
import '/model/trade_channel.dart';
import '/utils/info_controller.dart';
import '../Services/ApiServices/api_urls.dart';

class ImportDataFromJson extends FxController {
  bool isSyncShop = false,
      isSyncItem = false,
      isSyncBranch = false,
      isSyncSpDetail = false,
      isSyncSp = false,
      isSyncRegion = false,
      isSyncArea = false,
      isSyncedData = false;
  bool isTradeChannel=false;

  String syncDate = "12-2-2023";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<Items>> fetchItems() async {
    int count = 0;
    int id = 0;
    String date = "";
    List<Items> itemsList = [];
    List<SyncDataModel> syncList = await DatabaseHelper.instance.getSyncDataHistory();
    syncList.forEach((element) {
      id = element.SyncID!;
      date = element.ItemSyncDate == null ? "" : element.ItemSyncDate!;
    });
    //Info.startProgress();
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_ITEMS}?itemid=0");
    if (response.isEmpty || response == null) {
      return itemsList;
    }

    var itemApiResponse = itemApiResponseFromJson(response);

    if (itemApiResponse.data != null) {
      itemApiResponse.data!.forEach((element) async {
        await insertUpdateItems(element);
        count++;
      });
      if (count > 0) {
        syncList.length == 0
            ? await DatabaseHelper.instance.insertSyncDataHistory(SyncDataModel(
                ItemSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                LastSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))
            : await DatabaseHelper.instance
                .updateItemSyncDate(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), id);
      }
    }
    //Info.stopProgress();
    if (count == 0) {
      isSyncedData = true;
      //Info.successSnackBar('Items are up to date!!!');
    } else {
      isSyncedData = true;
      //Info.successSnackBar('Items inserted successfully!!!');
    }

    return itemsList;
  }

  Future<List<ShopsModel>> fetchShops() async {
    int count = 0;
    List<ShopsModel> shopsList = [];
    int id = 0;
    String date = "";
    List<SyncDataModel> syncList = await DatabaseHelper.instance.getSyncDataHistory();
    syncList.forEach((element) {
      id = element.SyncID!;
      date = element.ShopSyncDate == null ? "" : element.ShopSyncDate!;
    });
    //Info.startProgress();
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_SHOPS}?date=$date");

    if (response.isEmpty || response == null) {
      return shopsList;
    }

    var shopsApiResponse = shopsApiResponseFromJson(response);

    if (shopsApiResponse.data != null) {
      print('Total length : ${shopsApiResponse.data!.length}');
      shopsApiResponse.data!.forEach((element) async {
        await insertShops(element);
        count++;
        print('Count : $count / ${element.shopID}');
        if (count == 1) {
          syncList.length == 0
              ? await DatabaseHelper.instance.insertSyncDataHistory(SyncDataModel(
                  ShopSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                  LastSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))
              : await DatabaseHelper.instance
                  .updateShopSyncDate(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), id);
        }
      });
    }
    //Info.stopProgress();
    if (count == 0) {
      isSyncedData = true;
      //Info.successSnackBar('Shops are up to date!!!');
    } else {
      isSyncedData = true;
      //Info.successSnackBar('Shops inserted successfully!!!');
    }
    return shopsList;
  }

  Future syncShops() async {
    List<ShopsModel> lstShops = [];
    List<Map<String, String>> lstBody = [];
    Map<String, String> body = {};
    lstShops = await DatabaseHelper.instance.syncModifiedShops();
    lstShops.forEach((element) {
      body = {
        'ID': element.ID.toString(),
        'ShopID': element.shopID.toString(),
        'ShopName': element.shopName.toString(),
        'ShopCode': element.shopCode == null ? "" : element.shopCode.toString(),
        'ContactPerson': element.contactPerson == null ? "" : element.contactPerson.toString(),
        'ContactNo': element.contactNo == null ? "" : element.contactNo.toString(),
        'NTNNo': element.nTNNO == null ? "" : element.nTNNO.toString(),
        'RegionID': element.regionID == null ? "0" : element.regionID.toString(),
        'AreaID': element.areaID == null ? "0" : element.areaID.toString(),
        'SalePersonID': element.salePersonID == null ? "0" : element.salePersonID.toString(),
        'CreatedByID': element.createdByID == null ? "0" : element.createdByID.toString(),
        'UpdatedByID': element.updatedByID == null ? "0" : element.updatedByID.toString(),
        'SystemNotes ': element.systemNotes == null ? "" : element.systemNotes.toString(),
        'Remarks ': element.remarks == null ? "" : element.remarks.toString(),
        'Description': element.description == null ? "" : element.description.toString(),
        'EntryDate': element.entryDate == null
            ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
            : element.entryDate.toString(),
        'BranchID': element.branchID == null ? "0" : element.branchID.toString(),
        'Latitiude': element.latitiude == null ? "0" : element.latitiude.toString(),
        'Longitiude': element.longitiude == null ? "0" : element.longitiude.toString(),
        'GoogleAddress': element.googleAddress == null ? "" : element.googleAddress.toString(),
        'CreatedOn': element.createdOn == null
            ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
            : element.createdOn.toString(),
        'UpdatedOn': element.updatedOn == null
            ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
            : element.updatedOn.toString(),
        'TradeChannelID': element.tradeChannelID == null ? "0" : element.tradeChannelID.toString(),
        'Route ': element.route == null ? "0" : element.route.toString(),
        'VPO ': element.vPO == null ? "" : element.vPO.toString(),
        'SEO': element.sEO == null ? "" : element.sEO.toString(),
        'ImageUrl ': element.imageUrl == null ? "" : element.imageUrl.toString(),
        'IsModify': element.IsModify.toString(),
      };
      lstBody.add(body);
    });
    // var response = await ApiServices.postRawMethodApi(lstBody, ApiUrls.SYNC_SHOPS);
    // if (response.isEmpty) {
    //   return lstShops;
    // }
    //
    // var shopsApiResponse = await shopsApiResponseFromJson(response);
    // if (shopsApiResponse.data != null) {
    //   shopsApiResponse.data!.forEach((element) async {
    //     await insertUpdateSyncedShops(element);
    //   });
    // }
    // return lstShops;
  }

  Future<List<Branch>> fetchBranches() async {
    int count = 0;
    List<Branch> branchList = [];
    int id = 0;
    String date = "";
    List<SyncDataModel> syncList = await DatabaseHelper.instance.getSyncDataHistory();
    syncList.forEach((element) {
      id = element.SyncID!;
      date = element.BranchSyncDate == null ? "" : element.BranchSyncDate!;
    });
    //Info.startProgress();
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_BRANCHES}?branchid=0");
    if (response.isEmpty) {
      return branchList;
    }

    var apiBranchResponse = branchApiResponseFromJson(response);

    if (apiBranchResponse.data != null) {
      apiBranchResponse.data!.forEach((element) async {
        await insertUpdateBranches(element);
        count++;
      });
      if (count > 0) {
        syncList.length == 0
            ? await DatabaseHelper.instance.insertSyncDataHistory(SyncDataModel(
                BranchSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                LastSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))
            : await DatabaseHelper.instance
                .updateBranchSyncDate(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), id);
      }
    }
    //Info.stopProgress();
    if (count == 0) {
      isSyncedData = true;
      //Info.successSnackBar('Branches are up to date!!!');
    } else {
      isSyncedData = true;
      //Info.successSnackBar('Branches record inserted successfully!!!');
    }
    return branchList;
  }

  Future<List<Region>> fetchRegions() async {
    int count = 0;
    List<Region> regionList = [];
    int id = 0;
    String date = "";
    List<SyncDataModel> syncList = await DatabaseHelper.instance.getSyncDataHistory();
    syncList.forEach((element) {
      id = element.SyncID!;
      date = element.RegionSyncDate == null ? "" : element.RegionSyncDate!;
    });
    //Info.startProgress();
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_REGIONS}?regionid=0");
    if (response.isEmpty) {
      return regionList;
    }

    var regionApiResponse = regionApiResponseFromJson(response);

    if (regionApiResponse.data != null) {
      regionApiResponse.data!.forEach((element) async {
        await insertUpdateRegions(element);
        count++;
      });
      if (count > 0) {
        syncList.length == 0
            ? await DatabaseHelper.instance.insertSyncDataHistory(SyncDataModel(
                RegionSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                LastSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))
            : await DatabaseHelper.instance
                .updateRegionSyncDate(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), id);
      }
    }
    //Info.stopProgress();
    if (count == 0) {
      isSyncedData = true;
      //Info.successSnackBar('Regions are up to date!!!');
    } else {
      isSyncedData = true;
      //Info.successSnackBar('Regions record inserted successfully!!!');
    }
    return regionList;
  }

  Future<List<Area>> fetchAreas() async {
    int count = 0;
    List<Area> areaList = [];
    int id = 0;
    String date = "";
    List<SyncDataModel> syncList = await DatabaseHelper.instance.getSyncDataHistory();
    syncList.forEach((element) {
      id = element.SyncID!;
      date = element.AreaSyncDate == null ? "" : element.AreaSyncDate!;
    });
    //Info.startProgress();
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_AREAS}?areaid=0");
    if (response.isEmpty) {
      return areaList;
    }
    var areaApiResponse = areaApiResponseFromJson(response);
    if (areaApiResponse.data != null) {
      areaApiResponse.data!.forEach((element) async {
        await insertUpdateAreas(element);
        count++;
      });
      if (count > 0) {
        syncList.length == 0
            ? await DatabaseHelper.instance.insertSyncDataHistory(SyncDataModel(
                AreaSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                LastSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))
            : await DatabaseHelper.instance
                .updateAreaSyncDate(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), id);
      }
    }
    //Info.stopProgress();
    if (count == 0) {
      isSyncedData = true;
      //Info.successSnackBar('Areas are up to date!!!');
    } else {
      isSyncedData = true;
      //Info.successSnackBar('Areas record inserted successfully!!!');
    }
    return areaList;
  }

  Future<List<SalePerson>> fetchSalePersons() async {
    int count = 0;
    List<SalePerson> spList = [];
    int id = 0;
    String date = "";
    List<SyncDataModel> syncList = await DatabaseHelper.instance.getSyncDataHistory();
    syncList.forEach((element) {
      id = element.SyncID!;
      date = element.SalePersonSyncDate == null ? "" : element.SalePersonSyncDate!;
    });
    //Info.startProgress();
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_SALE_PERSONS}?spid=0");
    if (response.isEmpty) {
      return spList;
    }
    var spApiResponse = salePersonApiResponseFromJson(response);
    if (spApiResponse.data != null) {
      spApiResponse.data!.forEach((element) async {
        await insertUpdateSalePersons(element);
        count++;
      });
      if (count > 0) {
        syncList.length == 0
            ? await DatabaseHelper.instance.insertSyncDataHistory(SyncDataModel(
                SalePersonSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                LastSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))
            : await DatabaseHelper.instance.updateSalePersonSyncDate(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), id);
      }
    }
    //Info.stopProgress();
    if (count == 0) {
      isSyncedData = true;
      //Info.successSnackBar('Sale Persons are up to date!!!');
    } else {
      isSyncedData = true;
      //Info.successSnackBar('Sale Persons record inserted successfully!!!');
    }
    return spList;
  }

  Future<List<TradeChannel>> fetchTcs() async {
    int count = 0;
    List<TradeChannel> tcList = [];
    int id = 0;
    String date = "";
    List<SyncDataModel> syncList = await DatabaseHelper.instance.getSyncDataHistory();
    syncList.forEach((element) {
      id = element.SyncID!;
      date = element.TradeChannelSyncDate == null ? "" : element.TradeChannelSyncDate!;
    });
    //Info.startProgress();
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_TCS}");
    if (response.isEmpty) {
      return tcList;
    }
    var tcApiResponse = tcApiResponseFromJson(response);
    if (tcApiResponse.data != null) {
      tcApiResponse.data!.forEach((element) async {
        await insertUpdateTcs(element);
        count++;
      });
      if (count > 0) {
        syncList.length == 0
            ? await DatabaseHelper.instance.insertSyncDataHistory(SyncDataModel(
                TradeChannelSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                LastSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))
            : await DatabaseHelper.instance.updateTradeChannelSyncDate(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), id);
      }
    }
    //Info.stopProgress();
    if (count == 0) {
      isSyncedData = true;
      //Info.successSnackBar('Trade Channels are up to date!!!');
    } else {
      isSyncedData = true;
      //Info.successSnackBar('Trade Channels record inserted successfully!!!');
    }
    return tcList;
  }

  Future fetchSalePersonDetail() async {
    int count = 0;
    int id = 0;
    String date = "";
    List<SyncDataModel> syncList = await DatabaseHelper.instance.getSyncDataHistory();
    syncList.forEach((element) {
      id = element.SyncID!;
      date = element.TradeChannelSyncDate == null ? "" : element.TradeChannelSyncDate!;
    });
    String response = await ApiServices.getMethodApi(ApiUrls.IMPORT_SALE_PERSONS_DETAIL);
    if (response.isNotEmpty) {
      var apiResponseFromJson = salePersonDetailApiResponseFromJson(response);
      if (apiResponseFromJson.data != null) {
        apiResponseFromJson.data!.forEach((element) {
          insertUpdateSalePersonDetail(element);
          count++;
        });
      }
      if (count > 0) {
        isSyncedData = true;
        syncList.length == 0
            ? await DatabaseHelper.instance.insertSyncDataHistory(SyncDataModel(
                SalePersonDetailSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                LastSyncDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))
            : await DatabaseHelper.instance.updateSalePersonDetailSyncDate(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), id);
      } else {
        isSyncedData = true;
      }
    }
  }

  // void syncData() async {
  //   try {
  //     Info.startProgress();
  //     if (isSyncItem) {
  //       await fetchItems();
  //       await Future.delayed(Duration(seconds: 2));
  //     }
  //     if (isSyncBranch) {
  //       await fetchBranches();
  //       await Future.delayed(Duration(seconds: 2));
  //     }
  //     if (isSyncSp) {
  //       await fetchSalePersons();
  //       await Future.delayed(Duration(seconds: 2));
  //     }
  //     if (isSyncSpDetail) {
  //       await fetchSalePersonDetail();
  //       await Future.delayed(Duration(seconds: 2));
  //     }
  //     if (isSyncArea) {
  //       await fetchAreas();
  //       await Future.delayed(Duration(seconds: 2));
  //     }
  //     if (isSyncRegion) {
  //       await fetchRegions();
  //       await Future.delayed(Duration(seconds: 2));
  //     }
  //     if (isSyncTc) {
  //       await fetchTcs();
  //       await Future.delayed(Duration(seconds: 2));
  //     }
  //     if (isSyncShop) {
  //       await fetchShops();
  //       await syncShops();
  //     }
  //     if (isSyncedData) {
  //       Info.stopProgress();
  //       Info.successSnackBar('Data synced successfully!!!');
  //     } else {
  //       Info.stopProgress();
  //       Info.infoSnackBar('Select Items for sync.');
  //     }
  //   } catch (e) {
  //     Info.stopProgress();
  //     Info.errorSnackBar(e.toString());
  //     print(e.toString());
  //   }
  // }

  void lastSyncDate() async {
    List<SyncDataModel> lst = await DatabaseHelper.instance.getSyncDataHistory();
    lst.forEach((element) {
      syncDate = element.LastSyncDate != null ? element.LastSyncDate! : "";
    });
  }

  Future insertUpdateItems(Items row) async {
    await DatabaseHelper.instance.insertItems(Items(
        itemID: row.itemID,
        itemCatID: row.itemCatID,
        itemSubCatID: row.itemSubCatID,
        itemType: row.itemType,
        itemCode: row.itemCode,
        itemName: row.itemName,
        description: row.description,
        isActive: row.isActive,
        purchaseRate: row.purchaseRate,
        saleRate: row.saleRate,
        uOMID: row.uOMID,
        reorderLevel: row.reorderLevel,
        imageUrl: row.imageUrl,
        unitQuantity: row.unitQuantity,
        reOrderQuantity: row.reOrderQuantity,
        autoCode: row.autoCode,
        sortID: row.sortID,
        partyID: row.partyID,
        saleTaxRate: row.saleTaxRate));
  }

  Future insertShops(ShopsModel row) async {
    var shopsRow = await DatabaseHelper.instance.getShopByShopId(row.shopID!);
    if (shopsRow.IsModify == 0 || shopsRow.IsModify == null) {
      var result = await DatabaseHelper.instance.deleteImportedShops(
          row.shopID!, DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.updatedOn!)));
      if (result > 0) {
        print('Shop has been deleted');
      }
      await DatabaseHelper.instance.insertShops(ShopsModel(
          shopID: row.shopID,
          shopName: row.shopName,
          shopCode: row.shopCode,
          contactPerson: row.contactPerson,
          contactNo: row.contactNo,
          nTNNO: row.nTNNO,
          regionID: row.regionID,
          areaID: row.areaID,
          salePersonID: row.salePersonID,
          createdByID: row.createdByID,
          updatedByID: row.updatedByID,
          systemNotes: row.systemNotes,
          remarks: row.remarks,
          description: row.description,
          entryDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.entryDate!)),
          branchID: row.branchID,
          longitiude: row.longitiude,
          latitiude: row.latitiude,
          googleAddress: row.googleAddress,
          createdOn: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.createdOn!)),
          updatedOn: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.updatedOn!)),
          tradeChannelID: row.tradeChannelID,
          route: row.route,
          vPO: row.vPO,
          sEO: row.sEO,
          imageUrl: row.imageUrl,
          IsModify: 0));
    }
  }

  Future insertUpdateSyncedShops(ShopsModel row) async {
    await DatabaseHelper.instance.insertShops(ShopsModel(
        ID: row.ID,
        shopID: row.shopID,
        shopName: row.shopName,
        shopCode: row.shopCode,
        contactPerson: row.contactPerson,
        contactNo: row.contactNo,
        nTNNO: row.nTNNO,
        regionID: row.regionID,
        areaID: row.areaID,
        salePersonID: row.salePersonID,
        createdByID: row.createdByID,
        updatedByID: row.updatedByID,
        systemNotes: row.systemNotes,
        remarks: row.remarks,
        description: row.description,
        entryDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.entryDate!)),
        branchID: row.branchID,
        longitiude: row.longitiude,
        latitiude: row.latitiude,
        googleAddress: row.googleAddress,
        createdOn: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.createdOn!)),
        updatedOn: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.updatedOn!)),
        tradeChannelID: row.tradeChannelID,
        route: row.route,
        vPO: row.vPO,
        sEO: row.sEO,
        imageUrl: row.imageUrl,
        IsModify: 0));
  }

  Future insertUpdateBranches(Branch branchRow) async {
    await DatabaseHelper.instance.insertBranches(Branch(
        branchID: branchRow.branchID,
        branchName: branchRow.branchName,
        address: branchRow.address,
        phone: branchRow.phone,
        email: branchRow.email,
        website: branchRow.website,
        isHeadOffice: branchRow.isHeadOffice,
        branchCode: branchRow.branchCode,
        nTN: branchRow.nTN,
        sTRN: branchRow.sTRN,
        imageUrl: branchRow.imageUrl));
  }

  Future insertUpdateAreas(Area areaRow) async {
    await DatabaseHelper.instance.insertArea(Area(
        areaID: areaRow.areaID,
        regionID: areaRow.regionID,
        areaName: areaRow.areaName,
        isActive: areaRow.isActive));
  }

  Future insertUpdateRegions(Region regionRow) async {
    await DatabaseHelper.instance.insertRegion(Region(
        regionID: regionRow.regionID,
        regionCode: regionRow.regionCode,
        regionName: regionRow.regionName,
        isActive: regionRow.isActive));
  }

  Future insertUpdateSalePersons(SalePerson spRow) async {
    await DatabaseHelper.instance.insertSalePerson(SalePerson(
        salePersonID: spRow.salePersonID,
        salePersonName: spRow.salePersonName,
        salePersonFullName: spRow.salePersonFullName,
        parentID: spRow.parentID,
        parentName: spRow.parentName,
        designation: spRow.designation,
        commission: spRow.commission,
        email: spRow.email,
        phone: spRow.phone,
        userID: spRow.userID,
        parentLevel: spRow.parentLevel,
        regionID: spRow.regionID,
        areaID: spRow.areaID,
        isActive: spRow.isActive,
        branchID: spRow.branchID));
  }

  Future insertUpdateTcs(TradeChannel row) async {
    await DatabaseHelper.instance
        .insertTcs(TradeChannel(tradeChannelID: row.tradeChannelID, channelName: row.channelName));
  }

  Future insertUpdateSalePersonDetail(SalePersonDetail row) async {
    await DatabaseHelper.instance.insertSalePersonDetail(SalePersonDetail(
        salePersonDetailID: row.salePersonDetailID,
        areaID: row.areaID,
        salePersonID: row.salePersonID,
        routDay: row.routDay,
        checked: row.checked));
  }

  @override
  String getTag() {
    return "import_data_controller";
  }
}
