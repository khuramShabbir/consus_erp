import 'dart:convert';

ShopsApiResponse shopsApiResponseFromJson(String str) =>
    ShopsApiResponse.fromJson(json.decode(str));

class ShopsApiResponse {
  String? responseMessage;
  List<ShopsModel>? data;
  bool? isValid;
  bool? error;
  String? errorDetail;

  ShopsApiResponse({this.responseMessage, this.data, this.isValid, this.error, this.errorDetail});

  ShopsApiResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <ShopsModel>[];
      json['Data'].forEach((v) {
        data!.add(new ShopsModel.fromMap(v));
      });
    }
    isValid = json['IsValid'];
    error = json['Error'];
    errorDetail = json['ErrorDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResponseMessage'] = this.responseMessage;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['IsValid'] = this.isValid;
    data['Error'] = this.error;
    data['ErrorDetail'] = this.errorDetail;
    return data;
  }
}

class ShopsModel {
  int? ID;
  int? shopID;
  String? shopName;
  String? shopCode;
  String? contactPerson;
  String? contactNo;
  String? nTNNO;
  int? regionID;
  int? areaID;
  int? salePersonID;
  int? createdByID;
  int? updatedByID;
  String? createdOn;
  String? updatedOn;
  String? systemNotes;
  String? remarks;
  String? description;
  String? entryDate;
  int? branchID;
  double? latitiude;
  double? longitiude;
  String? googleAddress;
  int? tradeChannelID;
  int? route;
  String? vPO;
  String? sEO;
  String? imageUrl;
  int? IsModify;

  ShopsModel(
      {this.ID,
      this.shopID,
      this.shopName,
      this.shopCode,
      this.contactPerson,
      this.contactNo,
      this.nTNNO,
      this.regionID,
      this.areaID,
      this.salePersonID,
      this.createdByID,
      this.updatedByID,
      this.createdOn,
      this.updatedOn,
      this.systemNotes,
      this.remarks,
      this.description,
      this.entryDate,
      this.branchID,
      this.latitiude,
      this.longitiude,
      this.googleAddress,
      this.tradeChannelID,
      this.route,
      this.vPO,
      this.sEO,
      this.imageUrl,
      this.IsModify});

  ShopsModel.fromJson(Map<String, dynamic> json) {
    shopID = json['ShopID'];
    shopName = json['ShopName'];
    shopCode = json['ShopCode'];
    contactPerson = json['ContactPerson'];
    contactNo = json['ContactNo'];
    nTNNO = json['NTNNO'];
    regionID = json['RegionID'];
    areaID = json['AreaID'];
    salePersonID = json['SalePersonID'];
    createdByID = json['CreatedByID'];
    updatedByID = json['UpdatedByID'];
    createdOn = json['CreatedOn'];
    updatedOn = json['UpdatedOn'];
    systemNotes = json['SystemNotes'];
    remarks = json['Remarks'];
    description = json['Description'];
    entryDate = json['EntryDate'];
    branchID = json['BranchID'];
    latitiude = json['Latitiude'];
    longitiude = json['Longitiude'];
    googleAddress = json['GoogleAddress'];
    tradeChannelID = json['TradeChannelID'];
    route = json['Route'];
    vPO = json['VPO'];
    sEO = json['SEO'];
    imageUrl = json['ImageUrl'];
  }

  ShopsModel.fromMap(Map<String, dynamic> json) {
    ID = json['ID'];
    shopID = json['ShopID'];
    shopName = json['ShopName'];
    shopCode = json['ShopCode'];
    contactPerson = json['ContactPerson'];
    contactNo = json['ContactNo'];
    nTNNO = json['NTNNO'];
    regionID = json['RegionID'];
    areaID = json['AreaID'];
    salePersonID = json['SalePersonID'];
    createdByID = json['CreatedByID'];
    updatedByID = json['UpdatedByID'];
    createdOn = json['CreatedOn'];
    updatedOn = json['UpdatedOn'];
    systemNotes = json['SystemNotes'];
    remarks = json['Remarks'];
    description = json['Description'];
    entryDate = json['EntryDate'];
    branchID = json['BranchID'];
    latitiude = json['Latitiude'];
    longitiude = json['Longitiude'];
    googleAddress = json['GoogleAddress'];
    tradeChannelID = json['TradeChannelID'];
    route = json['Route'];
    vPO = json['VPO'];
    sEO = json['SEO'];
    imageUrl = json['ImageUrl'];
    IsModify = json['IsModify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.ID;
    data['ShopID'] = this.shopID;
    data['ShopName'] = this.shopName;
    data['ShopCode'] = this.shopCode;
    data['ContactPerson'] = this.contactPerson;
    data['ContactNo'] = this.contactNo;
    data['NTNNO'] = this.nTNNO;
    data['RegionID'] = this.regionID;
    data['AreaID'] = this.areaID;
    data['SalePersonID'] = this.salePersonID;
    data['CreatedByID'] = this.createdByID;
    data['UpdatedByID'] = this.updatedByID;
    data['CreatedOn'] = this.createdOn;
    data['UpdatedOn'] = this.updatedOn;
    data['SystemNotes'] = this.systemNotes;
    data['Remarks'] = this.remarks;
    data['Description'] = this.description;
    data['EntryDate'] = this.entryDate;
    data['BranchID'] = this.branchID;
    data['Latitiude'] = this.latitiude;
    data['Longitiude'] = this.longitiude;
    data['GoogleAddress'] = this.googleAddress;
    data['TradeChannelID'] = this.tradeChannelID;
    data['Route'] = this.route;
    data['VPO'] = this.vPO;
    data['SEO'] = this.sEO;
    data['ImageUrl'] = this.imageUrl;
    data['IsModify'] = this.IsModify;
    return data;
  }
}

class SyncDataModel {
  int? SyncID;
  String? ShopSyncDate;
  String? ItemSyncDate;
  String? SalePersonSyncDate;
  String? SalePersonDetailSyncDate;
  String? BranchSyncDate;
  String? RegionSyncDate;
  String? AreaSyncDate;
  String? TradeChannelSyncDate;
  String? LastSyncDate;

  SyncDataModel(
      {this.SyncID,
      this.ShopSyncDate,
      this.ItemSyncDate,
      this.SalePersonSyncDate,
      this.SalePersonDetailSyncDate,
      this.BranchSyncDate,
      this.RegionSyncDate,
      this.AreaSyncDate,
      this.TradeChannelSyncDate,
      this.LastSyncDate});

  factory SyncDataModel.fromJson(Map<String, dynamic> json) => SyncDataModel(
      SyncID: json['SyncID'],
      ShopSyncDate: json['ShopSyncDate'],
      ItemSyncDate: json['ItemSyncDate'],
      SalePersonSyncDate: json['SalePersonSyncDate'],
      SalePersonDetailSyncDate: json['SalePersonDetailSyncDate'],
      BranchSyncDate: json['BranchSyncDate'],
      RegionSyncDate: json['RegionSyncDate'],
      AreaSyncDate: json['AreaSyncDate'],
      TradeChannelSyncDate: json['TradeChannelSyncDate'],
      LastSyncDate: json['LastSyncDate']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SyncID'] = this.SyncID;
    data['ShopSyncDate'] = this.ShopSyncDate;
    data['ItemSyncDate'] = this.ItemSyncDate;
    data['SalePersonSyncDate'] = this.SalePersonSyncDate;
    data['SalePersonDetailSyncDate'] = this.SalePersonDetailSyncDate;
    data['BranchSyncDate'] = this.BranchSyncDate;
    data['RegionSyncDate'] = this.RegionSyncDate;
    data['AreaSyncDate'] = this.AreaSyncDate;
    data['TradeChannelSyncDate'] = this.TradeChannelSyncDate;
    data['LastSyncDate'] = this.LastSyncDate;

    return data;
  }
}
