import 'dart:convert';

ItemApiResponse itemApiResponseFromJson(String str) => ItemApiResponse.fromJson(json.decode(str));

class ItemApiResponse {
  String? responseMessage;
  List<Items>? data;
  bool? isValid;
  bool? error;
  Null errorDetail;

  ItemApiResponse({this.responseMessage, this.data, this.isValid, this.error, this.errorDetail});

  ItemApiResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <Items>[];
      json['Data'].forEach((v) {
        data!.add(new Items.fromJson(v));
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

class Items {
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

  Items(
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

  Items.fromJson(Map<String, dynamic> json) {
    itemID = json['ItemID'];
    itemCatID = json['ItemCatID'];
    itemSubCatID = json['ItemSubCatID'];
    itemType = json['ItemType'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    description = json['Description'];
    isActive = json['IsActive'];
    purchaseRate = json['PurchaseRate'];
    saleRate = json['SaleRate'];
    uOMID = json['UOMID'];
    reorderLevel = json['ReorderLevel'];
    imageUrl = json['ImageUrl'];
    unitQuantity = json['UnitQuantity'];
    reOrderQuantity = json['ReOrderQuantity'];
    autoCode = json['AutoCode'];
    sortID = json['SortID'];
    partyID = json['PartyID'];
    saleTaxRate = json['SaleTaxRate'];
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
