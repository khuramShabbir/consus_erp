import 'dart:convert';

GetItemsData getItemsDataFromJson(String str)=> GetItemsData.fromJson(json.decode(str));

String getItemsDataToJson(GetItemsData data)=> json.encode(data.toJson());

class GetItemsData {
  String? responseMessage;
  List<ItemsModel>? data;
  bool? isValid;
  bool? error;
  Null? errorDetail;

  GetItemsData(
      {this.responseMessage,
        this.data,
        this.isValid,
        this.error,
        this.errorDetail});

  GetItemsData.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <ItemsModel>[];
      json['Data'].forEach((v) {
        data!.add(new ItemsModel.fromJson(v));
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

class ItemsModel {
  int? itemID;
  int? itemCatID;
  int? itemSubCatID;
  String? itemType;
  String? itemCode;
  String? itemName;
  String? description;
  bool? isActive;
  double? purchaseRate;
  double? saleRate;
  int? uOMID;
  double? reorderLevel;
  String? imageUrl;
  double? unitQuantity;
  double? reOrderQuantity;
  bool? autoCode;
  int? sortID;
  int? partyID;
  double? saleTaxRate;

  ItemsModel(
      {this.itemID,
        this.itemCatID,
        this.itemSubCatID,
        this.itemType,
        this.itemCode,
        this.itemName,
        this.description,
        this.isActive,
        this.purchaseRate,
        this.saleRate,
        this.uOMID,
        this.reorderLevel,
        this.imageUrl,
        this.unitQuantity,
        this.reOrderQuantity,
        this.autoCode,
        this.sortID,
        this.partyID,
        this.saleTaxRate});

  ItemsModel.fromJson(Map<String, dynamic> json) {
    itemID = json["ItemID"] != null ? int.parse(json["ItemID"].toString()) : null;
    itemCatID = json["ItemCatID"] != null ? int.parse(json["ItemCatID"].toString()) : null;
    itemSubCatID = json["ItemSubCatID"] != null ? int.parse(json["ItemSubCatID"].toString()) : null;
    itemType = json['ItemType'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    description = json['Description'];
    isActive = json["IsActive"] != null ? json["IsActive"].toString().parseBool() : false;
    purchaseRate = json["PurchaseRate"] != null ? double.parse(json["PurchaseRate"].toString()) : null;
    saleRate = json["SaleRate"] != null ? double.parse(json["SaleRate"].toString()) : null;
    uOMID = json["UOMID"] != null ? int.parse(json["UOMID"].toString()) : null;
    reorderLevel = json["ReorderLevel"] != null ? double.parse(json["ReorderLevel"].toString()) : null;
    imageUrl = json['ImageUrl'];
    unitQuantity = json["UnitQuantity"] != null ? double.parse(json["UnitQuantity"].toString()) : null;
    reOrderQuantity = json["ReOrderQuantity"] != null ? double.parse(json["ReOrderQuantity"].toString()) : null;
    autoCode = json["AutoCode"] != null ? json["AutoCode"].toString().parseBool() : false;
    sortID = json["SortID"] != null ? int.parse(json["SortID"].toString()) : null;
    partyID = json["PartyID"] != null ? int.parse(json["PartyID"].toString()) : null;
    saleTaxRate = json["SaleTaxRate"] != null ? double.parse(json["SaleTaxRate"].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemID'] = this.itemID;
    data['ItemCatID'] = this.itemCatID;
    data['ItemSubCatID'] = this.itemSubCatID;
    data['ItemType'] = this.itemType;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Description'] = this.description;
    data['IsActive'] = this.isActive;
    data['PurchaseRate'] = this.purchaseRate;
    data['SaleRate'] = this.saleRate;
    data['UOMID'] = this.uOMID;
    data['ReorderLevel'] = this.reorderLevel;
    data['ImageUrl'] = this.imageUrl;
    data['UnitQuantity'] = this.unitQuantity;
    data['ReOrderQuantity'] = this.reOrderQuantity;
    data['AutoCode'] = this.autoCode;
    data['SortID'] = this.sortID;
    data['PartyID'] = this.partyID;
    data['SaleTaxRate'] = this.saleTaxRate;
    return data;
  }
}

extension BoolParsing on String {
  bool parseBool() {
    if (this.toLowerCase() == 'true') {
      return true;
    } else if (this.toLowerCase() == 'false') {
      return false;
    }

    throw '"$this" can not be parsed to boolean.';
  }
}