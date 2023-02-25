import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/area.dart';
import '../model/branch.dart';
import '../model/items.dart';
import '../model/region.dart';
import '../model/sale_person.dart';
import '../model/shops_list_model.dart';
import '../model/shops_model.dart';
import '../model/trade_channel.dart';

class DatabaseHelper {
  static final tableItems = "Items";
  static final shopsTable = "Shops";
  static final branchTable = "Branch";
  static final areaTable = "Area";
  static final regionTable = "Region";
  static final salePersonTable = "SalePerson";
  static final tcTable = "TradeChannel";
  static final syncDataTable = "SyncDataHistory";
  static final salePersonDetailTable = "SalePersonDetail";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "erp.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
    CREATE TABLE $tableItems(
    ItemID INTEGER PRIMARY KEY,
    ItemCatID INTEGER,
    ItemSubCatID INTEGER,
    ItemType TEXT,
    ItemCode TEXT,
    ItemName TEXT,
    Description TEXT,
    IsActive BOOLEAN,
    PurchaseRate REAL,
    SaleRate REAL,
    UOMID INTEGER,
    ReorderLevel REAL,
    ImageUrl TEXT,
    UnitQuantity REAL,
    ReOrderQuantity REAL,
    AutoCode REAL,
    SortID INTEGER,
    PartyID INTEGER,
    SaleTaxRate REAL
    )''');

    batch.execute('''
     CREATE TABLE $shopsTable (
     ID INTEGER PRIMARY KEY AUTOINCREMENT,
     ShopID INTEGER NOT NULL,
     ShopName TEXT,
     ShopCode TEXT,
     ContactPerson TEXT,
     ContactNo TEXT,
     NTNNo TEXT,
     RegionID INTEGER,
     AreaID INTEGER,
     SalePersonID INTEGER,
     CreatedByID INTEGER,
     UpdatedByID INTEGER,
     SystemNotes TEXT,
     Remarks TEXT,
     Description TEXT,
     EntryDate TEXT,
     BranchID INTEGER,
     Latitiude REAL,
     Longitiude REAL,
     GoogleAddress TEXT,
     CreatedOn TEXT,
     UpdatedOn TEXT,
     TradeChannelID INTEGER,
     Route INTEGER,
     VPO TEXT,
     SEO TEXT,
     ImageUrl TEXT,
     IsModify INTEGER
     )''');

    batch.execute('''
     CREATE TABLE $branchTable (
     BranchID INTEGER PRIMARY KEY,
    BranchName TEXT,
    Address TEXT,
    Phone TEXT,
    Email TEXT,
    Website TEXT,
    IsHeadOffice BOOLEAN,
    BranchCode TEXT,
    ImageUrl TEXT,
    NTN TEXT,
    STRN TEXT
     )''');

    batch.execute('''
     CREATE TABLE $areaTable (
     AreaID INTEGER PRIMARY KEY,
    RegionID INTEGER,
    AreaName TEXT,
    IsActive INTEGER
     )''');

    batch.execute('''
     CREATE TABLE $regionTable (
     RegionID INTEGER PRIMARY KEY,
    RegionCode TEXT,
    RegionName TEXT,
    IsActive BOOLEAN
     )''');

    batch.execute('''
     CREATE TABLE $salePersonTable (
     SalePersonID INTEGER PRIMARY KEY,
    SalePersonName TEXT,
    SalePersonFullName TEXT,
    ParentID INTEGER,
    ParentName TEXT,
    Designation TEXT,
    Commission REAL,
    Email TEXT,
    Phone TEXT,
    UserID INTEGER,
    ParentLevel INTEGER,
    RegionID INTEGER,
    AreaID INTEGER,
    IsActive BOOLEAN,
    BranchID INTEGER
     )''');

    batch.execute('''
    CREATE TABLE $tcTable(
    TradeChannelID INTEGER PRIMARY KEY,
    ChannelName TEXT)''');

    batch.execute('''
      CREATE TABLE $syncDataTable(
      SyncID INTEGER PRIMARY KEY AUTOINCREMENT,
      ShopSyncDate TEXT,
      ItemSyncDate TEXT,
      SalePersonSyncDate TEXT,
      SalePersonDetailSyncDate TEXT,
      BranchSyncDate TEXT,
      RegionSyncDate TEXT,
      AreaSyncDate TEXT,
      TradeChannelSyncDate TEXT,
      LastSyncDate TEXT
      )''');

    batch.execute('''
      CREATE TABLE $salePersonDetailTable (
      SalePersonDetailID INTEGER PRIMARY KEY,
      AreaID INTEGER,
      SalePersonID INTEGER,
      RoutDay INTEGER,
      Checked INTEGER
       )''');

    List<dynamic> response = await batch.commit();
  }

  // UPGRADE DATABASE TABLES
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      //db.execute("ALTER TABLE $shopsTable ADD COLUMN IsSync BOOLEAN;");
    }
  }

  Future<List<Items>> getItems() async {
    Database db = await instance.database;
    var items = await db.query("$tableItems", orderBy: "ItemCode");
    List<Items> itemsList = items.isNotEmpty ? items.map((e) => Items.fromJson(e)).toList() : [];
    return itemsList;
  }

  Future<void> insertSyncDataHistory(SyncDataModel row) async {
    Database db = await instance.database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      batch.insert("$syncDataTable", row.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      await batch.commit(noResult: true);
    });
  }

  Future<List<SyncDataModel>> getSyncDataHistory() async {
    Database db = await instance.database;
    var sync = await db.query("$syncDataTable", orderBy: "SyncID");
    List<SyncDataModel> syncList =
        sync.isNotEmpty ? sync.map((e) => SyncDataModel.fromJson(e)).toList() : [];
    return syncList;
  }

  Future<void> updateShopSyncDate(String? pDate, int id) async {
    Database db = await instance.database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      batch.rawUpdate(
          "UPDATE SyncDataHistory SET ShopSyncDate = ?, LastSyncDate = ? WHERE SyncID = ?",
          [pDate, pDate, id]);
      await batch.commit(noResult: true);
    });
  }

  Future<int> updateItemSyncDate(String? pDate, int id) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
          "UPDATE SyncDataHistory SET ItemSyncDate = ?, LastSyncDate = ? WHERE SyncID = ?",
          [pDate, pDate, id]);
    });
    return result;
  }

  Future<int> updateBranchSyncDate(String? pDate, int id) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
          "UPDATE SyncDataHistory SET BranchSyncDate = ?, LastSyncDate = ? WHERE SyncID = ?",
          [pDate, pDate, id]);
    });
    return result;
  }

  Future<int> updateSalePersonSyncDate(String? pDate, int id) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
          "UPDATE SyncDataHistory SET SalePersonSyncDate = ?, LastSyncDate = ? WHERE SyncID = ?",
          [pDate, pDate, id]);
    });
    return result;
  }

  Future<int> updateSalePersonDetailSyncDate(String? pDate, int id) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
          "UPDATE SyncDataHistory SET SalePersonDetailSyncDate = ?, LastSyncDate = ? WHERE SyncID = ?",
          [pDate, pDate, id]);
    });
    return result;
  }

  Future<void> updateAreaSyncDate(String? pDate, int id) async {
    Database db = await instance.database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      batch.rawUpdate(
          "UPDATE SyncDataHistory SET AreaSyncDate = ?, LastSyncDate = ? WHERE SyncID = ?",
          [pDate, pDate, id]);
      await batch.commit();
    });
  }

  Future<int> updateRegionSyncDate(String? pDate, int id) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
          "UPDATE SyncDataHistory SET RegionSyncDate = ?, LastSyncDate = ? WHERE SyncID = ?",
          [pDate, pDate, id]);
    });
    return result;
  }

  Future<int> updateTradeChannelSyncDate(String? pDate, int id) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn.rawUpdate(
          "UPDATE SyncDataHistory SET TradeChannelSyncDate = ?, LastSyncDate = ? WHERE SyncID = ?",
          [pDate, pDate, id]);
    });
    return result;
  }

  Future<int> insertItems(Items itemsRow) async {
    int result = 0;
    Database db = await instance.database;
    var batch = db.batch();
    batch.insert("$tableItems", itemsRow.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
    return result;
  }

  Future updateItems(Items row) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn
          .update("$tableItems", row.toJson(), where: "ItemID = ?", whereArgs: [row.itemID]);
    });
    return result;
  }

  Future<bool> itemRecordExist(int id) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
      'SELECT * FROM Items WHERE ItemID = $id',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<int> deleteItems(int itemId) async {
    Database db = await instance.database;
    return await db.delete("$tableItems", where: "ItemID = ?", whereArgs: [itemId]);
  }

  Future<List<ShopsModel>> getShops() async {
    Database db = await instance.database;
    var shops = await db.query("$shopsTable", orderBy: "ShopID");
    List<ShopsModel> shopsList =
        shops.isNotEmpty ? shops.map((e) => ShopsModel.fromMap(e)).toList() : [];
    return shopsList;
  }

  Future<void> insertShops(ShopsModel shopsRow) async {
    Database db = await instance.database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      batch.insert("$shopsTable", shopsRow.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      await batch.commit(noResult: true);
    });
  }

  Future<int> updateShop(ShopsModel row) async {
    int result = 0;
    Database db = await instance.database;
    var batch = db.batch();
    batch.update("$shopsTable", row.toJson(), where: "ID = ?", whereArgs: [row.ID]);
    await batch.commit(noResult: true);
    return result;
  }

  Future<int> updateImportedShops(ShopsModel row) async {
    int result = 0;
    Database db = await instance.database;
    var batch = db.batch();
    batch.rawUpdate(
        "UPDATE Shops SET ShopName = ?, ShopCode = ?, ContactPerson = ?, ContactNo = ?, NTNNo = ?, RegionID = ?, AreaID = ?, SalePersonID = ?, CreatedByID = ?, UpdatedByID = ?, SystemNotes = ?, Remarks = ?, Description = ?, EntryDate = ?, BranchID = ?, Latitiude = ?, Longitiude = ?, GoogleAddress = ?, CreatedOn = ?, UpdatedOn = ?, TradeChannelID = ?, Route = ?, VPO = ?, SE0 = ?, ImageUrl = ?, IsSync = ? WHERE ShopID = ?",
        [
          row.shopName,
          row.shopCode,
          row.contactPerson,
          row.contactNo,
          row.nTNNO,
          row.regionID,
          row.areaID,
          row.salePersonID,
          row.createdByID,
          row.updatedByID,
          row.systemNotes,
          row.remarks,
          row.description,
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.entryDate!)),
          row.branchID,
          row.latitiude,
          row.longitiude,
          row.googleAddress,
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.createdOn!)),
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(row.updatedOn!)),
          row.tradeChannelID,
          row.route,
          row.vPO,
          row.sEO,
          row.imageUrl,
          false,
          row.shopID
        ]);
    await batch.commit(noResult: true);
    return result;
  }

  Future<List<ShopsModel>> syncModifiedShops() async {
    Database db = await instance.database;
    var shop = await db.rawQuery("SELECT * FROM Shops WHERE IsModify = 1");
    List<ShopsModel> lst = shop.isNotEmpty ? shop.map((e) => ShopsModel.fromMap(e)).toList() : [];
    return lst;
  }

  Future<ShopsModel> getShopByShopId(int shopId) async {
    ShopsModel shopsModel = new ShopsModel();
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT * FROM Shops WHERE ShopID = $shopId");
    if (result.isNotEmpty) {
      return shopsModel = ShopsModel.fromMap(result[0]);
    } else {
      return shopsModel;
    }
  }

  // Future<int> getShopsCount() async {
  //   Database db = await instance.database;
  //   var result = await db.query('$shopsTable');
  //   int count = result.isNotEmpty ? result.length : 0;
  //   return count;
  // }

  Future<int> getShopsCount(int id) async {
    Database db = await instance.database;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $shopsTable WHERE SalePersonID = $id OR $id = 0'));
    if (count != null) {
      return count;
    } else {
      return 0;
    }
  }

  Future<int> getSupervisorShopsCount(int id) async {
    Database db = await instance.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM SHOPS LEFT JOIN SalePerson ON Shops.SalePersonID = SalePerson.SalePersonID WHERE SalePerson.SalePersonID = $id OR SalePerson.ParentID = $id'));
    if (count != null) {
      return count;
    } else {
      return 0;
    }
  }

  Future<int> deleteImportedShops(int shopID, String updatedDate) async {
    Database db = await instance.database;
    return await db.delete("$shopsTable",
        where: 'ShopID = ? AND UpdatedOn <= ?', whereArgs: [shopID, updatedDate]);
  }

  Future<bool> shopRecordExist(int id) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
      'SELECT * FROM Shops WHERE ShopID = $id',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<int> deleteShops(int shopId) async {
    Database db = await instance.database;
    return await db.delete("$shopsTable", where: "ID = ?", whereArgs: [shopId]);
  }

  Future<List<Branch>> getBranches() async {
    Database db = await instance.database;
    var branch = await db.query("$branchTable", orderBy: "BranchName");
    List<Branch> branchList =
        branch.isNotEmpty ? branch.map((e) => Branch.fromMap(e)).toList() : [];
    return branchList;
  }

  Future<int> insertBranches(Branch row) async {
    int result = 0;
    Database db = await instance.database;
    var batch = db.batch();
    batch.insert("$branchTable", row.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
    return result;
  }

  Future<int> updateBranches(Branch row) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn
          .update("$branchTable", row.toJson(), where: 'BranchID = ?', whereArgs: [row.branchID]);
    });
    return result;
  }

  Future<bool> branchRecordExist(int id) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
      'SELECT * FROM Branch WHERE BranchID = $id',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<int> deleteBranches(int branchId) async {
    Database db = await instance.database;
    return await db.delete("$branchTable", where: "BranchID = ?", whereArgs: [branchId]);
  }

  Future<List<Area>> getArea() async {
    Database db = await instance.database;
    var area = await db.query("$areaTable", orderBy: "AreaID");
    List<Area> areaList = area.isNotEmpty ? area.map((e) => Area.fromMap(e)).toList() : [];
    return areaList;
  }

  Future<List<Area>> fillAreaByAreaId(int id) async {
    Database db = await instance.database;
    var area =
        await db.rawQuery("SELECT * FROM Area WHERE AreaID = $id OR $id = 0 ORDER BY AreaID");
    List<Area> areaList = area.isNotEmpty ? area.map((e) => Area.fromMap(e)).toList() : [];
    return areaList;
  }

  Future insertArea(Area row) async {
    Database db = await instance.database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      batch.insert("$areaTable", row.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      await batch.commit();
    });
  }

  Future<int> updateArea(Area row) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn
          .update("$areaTable", row.toJson(), where: 'AreaID = ?', whereArgs: [row.areaID]);
    });
    return result;
  }

  Future<bool> areaRecordExist(int id) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
      'SELECT * FROM Area WHERE AreaID = $id',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<int> deleteArea(int areaId) async {
    Database db = await instance.database;
    return await db.delete("$areaTable", where: "AreaID = ?", whereArgs: [areaId]);
  }

  Future<List<Region>> getRegion() async {
    Database db = await instance.database;
    var region = await db.query("$regionTable", orderBy: "RegionID");
    List<Region> regionList =
        region.isNotEmpty ? region.map((e) => Region.fromMap(e)).toList() : [];
    return regionList;
  }

  Future<List<Region>> fillRegionByRegionId(int id) async {
    Database db = await instance.database;
    var region =
        await db.rawQuery("SELECT * FROM REGION WHERE RegionID = $id OR $id = 0 ORDER BY RegionID");
    List<Region> regionList =
        region.isNotEmpty ? region.map((e) => Region.fromMap(e)).toList() : [];
    return regionList;
  }

  Future<int> insertRegion(Region row) async {
    int result = 0;
    Database db = await instance.database;
    var batch = db.batch();
    batch.insert("$regionTable", row.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
    return result;
  }

  Future<int> updateRegion(Region row) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn
          .update("$regionTable", row.toJson(), where: 'RegionID = ?', whereArgs: [row.regionID]);
    });
    return result;
  }

  Future<bool> regionRecordExist(int id) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
      'SELECT * FROM Region WHERE RegionID = $id',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<int> deleteRegion(int regionId) async {
    Database db = await instance.database;
    return await db.delete("$regionTable", where: "RegionID = ?", whereArgs: [regionId]);
  }

  Future<List<SalePerson>> getSalePerson() async {
    Database db = await instance.database;
    var salePerson = await db.query("$salePersonTable", orderBy: "SalePersonID");
    List<SalePerson> salePersonList =
        salePerson.isNotEmpty ? salePerson.map((e) => SalePerson.fromMap(e)).toList() : [];
    return salePersonList;
  }

  Future<List<SalePerson>> fillSalePersonsById(int id) async {
    Database db = await instance.database;
    var salePerson = await db.rawQuery(
        "SELECT * from SalePerson Where SalePersonID = $id OR $id = 0 ORDER BY SalePersonID");
    List<SalePerson> salePersonList =
        salePerson.isNotEmpty ? salePerson.map((e) => SalePerson.fromMap(e)).toList() : [];
    return salePersonList;
  }

  Future<List<Area>> fillAreasBySalePersonsById(int SalePersonID, int RegionID) async {
    Database db = await instance.database;
    var spAreas = await db.rawQuery(
        "SELECT SalePersonDetail.AreaID, Area.AreaName from SalePersonDetail INNER JOIN Area on SalePersonDetail.AreaID = Area.AreaID AND SalePersonDetail.Checked = 1 LEFT OUTER JOIN SalePerson ON SalePerson.SalePersonID = SalePersonDetail.SalePersonID WHERE (SalePersonDetail.SalePersonID = $SalePersonID OR SalePerson.ParentID = $SalePersonID) AND (SalePerson.RegionID = $RegionID) GROUP BY SalePersonDetail.AreaID, Area.AreaName");
    List<Area> spAreasList =
        spAreas.isNotEmpty ? spAreas.map((e) => Area.fromJson(e)).toList() : [];
    return spAreasList;
  }

  Future<List<Area>> fillSuperVisorsAreas(int SalePersonID, int RegionID) async {
    Database db = await instance.database;
    var spAreas = await db.rawQuery(
        "SELECT SalePersonDetail.AreaID, Area.AreaName from SalePersonDetail INNER JOIN Area on SalePersonDetail.AreaID = Area.AreaID AND SalePersonDetail.Checked = 1 LEFT OUTER JOIN SalePerson ON SalePerson.SalePersonID = SalePersonDetail.SalePersonID WHERE (SalePersonDetail.SalePersonID = $SalePersonID OR SalePerson.ParentID = $SalePersonID) AND (SalePerson.RegionID = $RegionID OR $RegionID = 0) GROUP BY SalePersonDetail.AreaID, Area.AreaName");
    List<Area> spAreasList =
        spAreas.isNotEmpty ? spAreas.map((e) => Area.fromJson(e)).toList() : [];
    return spAreasList;
  }

  Future<List<SalePerson>> fillSuperVisorsById(int id) async {
    Database db = await instance.database;
    var salePerson = await db.rawQuery(
        "SELECT * from SalePerson Where SalePersonID = $id OR ParentID = $id ORDER BY SalePersonID");
    List<SalePerson> salePersonList =
        salePerson.isNotEmpty ? salePerson.map((e) => SalePerson.fromMap(e)).toList() : [];
    return salePersonList;
  }

  Future<List<Region>> fillSuperVisorsRegionById(int id) async {
    Database db = await instance.database;
    var region = await db.rawQuery(
        "SELECT Region.RegionID, Region.RegionName from Region LEFT JOIN SalePerson ON Region.RegionID = SalePerson.RegionID WHERE SalePerson.SalePersonID = $id OR SalePerson.ParentID = $id GROUP BY Region.RegionID, Region.RegionName");
    List<Region> regionList =
        region.isNotEmpty ? region.map((e) => Region.fromMap(e)).toList() : [];
    return regionList;
  }

  Future<int> insertSalePerson(SalePerson row) async {
    int result = 0;
    Database db = await instance.database;
    var batch = db.batch();
    batch.insert("$salePersonTable", row.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
    return result;
  }

  Future<int> updateSalePerson(SalePerson row) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn.update("$salePersonTable", row.toJson(),
          where: 'SalePersonID = ?', whereArgs: [row.salePersonID]);
    });
    return result;
  }

  Future<bool> spRecordExist(int id) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
      'SELECT * FROM SalePerson WHERE SalePersonID = $id',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<int> deleteSalePerson(int salePersonId) async {
    Database db = await instance.database;
    return await db
        .delete("$salePersonTable", where: "SalePersonID = ?", whereArgs: [salePersonId]);
  }

  Future<List<TradeChannel>> getTcs() async {
    Database db = await instance.database;
    var tc = await db.query("$tcTable", orderBy: "TradeChannelID");
    List<TradeChannel> tcList =
        tc.isNotEmpty ? tc.map((e) => TradeChannel.fromJson(e)).toList() : [];
    return tcList;
  }

  Future<bool> tcRecordExist(int id) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
      'SELECT * FROM TradeChannel WHERE TradeChannelID = $id',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<int> insertTcs(TradeChannel tcRow) async {
    int result = 0;
    Database db = await instance.database;
    var batch = db.batch();
    batch.insert("$tcTable", tcRow.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
    return result;
  }

  Future<int> updateTcs(TradeChannel row) async {
    int result = 0;
    Database db = await instance.database;
    await db.transaction((txn) async {
      result = await txn.update("$tcTable", row.toJson(),
          where: 'TradeChannelID = ?', whereArgs: [row.tradeChannelID]);
    });
    return result;
  }

  Future<List<ShopsListModel>> getShopsList(
      String fromDate, String toDate, int salePersonId, int regionId, int areaId) async {
    Database db = await instance.database;
    var shops = await db.rawQuery(
        "Select Shops.ID, Shops.ShopID, Shops.ShopCode, Shops.ShopName, SalePerson.SalePersonName,Area.AreaName, Shops.VPO, Shops.SEO, Shops.ContactPerson, ifnull(TradeChannel.ChannelName,'') ChannelName, Shops.ContactNo, Shops.EntryDate FROM Shops LEFT JOIN SalePerson ON Shops.SalePersonID = SalePerson.SalePersonID LEFT JOIN Area ON Shops.AreaID = Area.AreaID LEFT JOIN TradeChannel ON Shops.TradeChannelID = TradeChannel.TradeChannelID WHERE (date(Shops.EntryDate) BETWEEN '$fromDate' and '$toDate') AND (Shops.SalePersonID = $salePersonId OR $salePersonId = 0) AND (Area.RegionID = $regionId OR $regionId = 0) AND (Shops.AreaID = $areaId OR $areaId = 0) ORDER BY Shops.EntryDate DESC");
    List<ShopsListModel> shopsList =
        shops.isNotEmpty ? shops.map((e) => ShopsListModel.fromJson(e)).toList() : [];
    return shopsList;
  }

  Future<ShopsModel> getShopById(int shopId) async {
    ShopsModel shopList = new ShopsModel();
    Database db = await instance.database;
    var shop = await db.rawQuery("SELECT * from Shops Where ID = $shopId");
    if (shop.isNotEmpty) {
      return ShopsModel.fromMap(shop[0]);
    } else {
      return shopList;
    }
  }

  Future<SalePerson> getSalePersonById(int id) async {
    SalePerson salePerson = new SalePerson();
    Database db = await instance.database;
    var sp = await db.rawQuery("SELECT * from SalePerson Where SalePersonID = $id");
    List<SalePerson> spList = sp.isNotEmpty ? sp.map((e) => SalePerson.fromMap(e)).toList() : [];
    spList.forEach((element) {
      salePerson.salePersonID = element.salePersonID;
      salePerson.salePersonName = element.salePersonName;
    });
    return salePerson;
  }

  Future<Area> getAreaById(int id) async {
    Area areaRecord = new Area();
    Database db = await instance.database;
    var area = await db.rawQuery("SELECT * from Area Where AreaID =  $id");
    List<Area> areaList = area.isNotEmpty ? area.map((e) => Area.fromMap(e)).toList() : [];
    areaList.forEach((element) {
      areaRecord.areaID = element.areaID!;
      areaRecord.areaName = element.areaName;
    });
    return areaRecord;
  }

  Future<TradeChannel> getTcById(int id) async {
    TradeChannel tcRecord = new TradeChannel();
    Database db = await instance.database;
    var tc =
        await db.rawQuery("SELECT * FROM TradeChannel WHERE (TradeChannelID = $id OR $id = 0)");
    List<TradeChannel> tcList =
        tc.isNotEmpty ? tc.map((e) => TradeChannel.fromJson(e)).toList() : [];
    tcList.forEach((element) {
      tcRecord.tradeChannelID = element.tradeChannelID!;
      tcRecord.channelName = element.channelName!;
    });
    return tcRecord;
  }

  Future<SalePerson> getSalePersonByUserID(int userId) async {
    SalePerson sp = new SalePerson();
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT * FROM SalePerson WHERE UserID = $userId");
    if (result.isNotEmpty) {
      return SalePerson.fromMap(result[0]);
    } else {
      return sp;
    }
  }

  Future insertSalePersonDetail(SalePersonDetail row) async {
    Database db = await instance.database;
    var batch = db.batch();
    batch.insert("$salePersonDetailTable", row.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete("$tcTable");
  }
}
