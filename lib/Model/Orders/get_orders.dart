import 'dart:convert';

GetOrdersData getOrdersDataFromJson(String str) => GetOrdersData.fromJson(json.decode(str));

String getOrdersDataToJson(GetOrdersData data) => json.encode(data.toJson());

class GetOrdersData {
  String? responseMessage;
  List<OrdersModel>? data;
  bool? isValid;
  bool? error;
  String? errorDetail;

  GetOrdersData(
      {this.responseMessage,
        this.data,
        this.isValid,
        this.error,
        this.errorDetail});

  GetOrdersData.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <OrdersModel>[];
      json['Data'].forEach((v) {
        data!.add(new OrdersModel.fromJson(v));
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

class OrdersModel {
  List<OrdersDetail>? ordersDetail;
  int? orderID;
  String? orderNo;
  int? shopID;
  DateTime? orderDate;
  String? shopName;
  int? salePersonID;
  int? regionID;
  String? salePersonName;
  String? salePersonFullName;
  String?googleAddress;
  String? remarks;
  String? systemNotes;
  String? regionName;
  int? createdBy;
  int? updatedBy;
  double? longitude;
  double? latitude;
  DateTime? createdOn;
  DateTime? updatedOn;
  double? qty;
  bool? verify;
  String? imageAddress;
  int? TotalRows;
  bool? isSync;

  OrdersModel(
      {this.ordersDetail,
        this.orderID,
        this.orderNo,
        this.shopID,
        this.orderDate,
        this.shopName,
        this.salePersonID,
        this.regionID,
        this.salePersonName,
        this.salePersonFullName,
        this.googleAddress,
        this.remarks,
        this.systemNotes,
        this.regionName,
        this.createdBy,
        this.updatedBy,
        this.longitude,
        this.latitude,
        this.createdOn,
        this.updatedOn,
        this.qty,
        this.verify,
        this.imageAddress,
        this.TotalRows,
        this.isSync = true});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    if (json['OrdersDetail'] != null) {
      ordersDetail = <OrdersDetail>[];
      json['OrdersDetail'].forEach((v) {
        ordersDetail!.add(new OrdersDetail.fromJson(v));
      });
    }
    orderID = json["OrderID"] != null ? int.parse(json["OrderID"].toString()) : null;
    orderNo = json['OrderNo'];
    shopID = json["ShopID"] != null ? int.parse(json["ShopID"].toString()) : null;
    orderDate = json["OrderDate"] != null ? DateTime.parse(json["OrderDate"].toString()) : null;
    shopName = json['ShopName'];
    salePersonID = json["SalePersonID"] != null ? int.parse(json["SalePersonID"].toString()) : null;
    regionID = json["RegionID"] != null ? int.parse(json["RegionID"].toString()) : null;
    salePersonName = json['SalePersonName'];
    salePersonFullName = json['SalePersonFullName'];
    googleAddress = json['GoogleAddress'];
    remarks = json['Remarks'];
    systemNotes = json['SystemNotes'];
    regionName = json['RegionName'];
    createdBy = json["CreatedBy"] != null ? int.parse(json["CreatedBy"].toString()) : null;
    updatedBy = json["UpdatedBy"] != null ? int.parse(json["UpdatedBy"].toString()) : null;
    longitude = json["Longitude"] != null ? double.parse(json["Longitude"].toString()) : null;
    latitude = json["Latitude"] != null ? double.parse(json["Latitude"].toString()) : null;
    createdOn = json["CreatedOn"] != null ? DateTime.parse(json["CreatedOn"].toString()) : null;
    updatedOn = json["UpdatedOn"] != null ? DateTime.parse(json["UpdatedOn"].toString()) : null;
    qty = json["Qty"] != null ? double.parse(json["Qty"].toString()) : null;
    verify = json["Verify"] != null ? json["Verify"].toString().parseBool() : true;
    imageAddress = json['ImageAddress'];
    TotalRows = json["TotalRows"] != null ? int.parse(json["TotalRows"].toString()) : null;
    isSync = json["isSync"] != null ? json["isSync"].toString().parseBool() : true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ordersDetail != null) {
      data['OrdersDetail'] = this.ordersDetail!.map((v) => v.toJson()).toList();
    }
    data['OrderID'] = this.orderID;
    data['OrderNo'] = this.orderNo;
    data['ShopID'] = this.shopID;
    data['OrderDate'] = this.orderDate == null ? null : this.orderDate?.toIso8601String();
    data['ShopName'] = this.shopName;
    data['SalePersonID'] = this.salePersonID;
    data['RegionID'] = this.regionID;
    data['SalePersonName'] = this.salePersonName;
    data['SalePersonFullName'] = this.salePersonFullName;
    data['GoogleAddress'] = this.googleAddress;
    data['Remarks'] = this.remarks;
    data['SystemNotes'] = this.systemNotes;
    data['RegionName'] = this.regionName;
    data['CreatedBy'] = this.createdBy;
    data['UpdatedBy'] = this.updatedBy;
    data['Longitude'] = this.longitude;
    data['Latitude'] = this.latitude;
    data['CreatedOn'] = this.createdOn == null ? null : this.createdOn?.toIso8601String();
    data['UpdatedOn'] = this.updatedOn == null ? null : this.updatedOn?.toIso8601String();
    data['Qty'] = this.qty;
    data['Verify'] = this.verify;
    data['ImageAddress'] = this.imageAddress;
    data['TotalRows'] = this.TotalRows;
    data['isSync'] = this.isSync;
    return data;
  }
}

class OrdersDetail {
  int? orderDetailID;
  int? orderID;
  int? itemID;
  double? qty;

  OrdersDetail({this.orderDetailID, this.orderID, this.itemID, this.qty});

  OrdersDetail.fromJson(Map<String, dynamic> json) {
    orderDetailID = json["OrderDetailID"] != null ? int.parse(json["OrderDetailID"].toString()) : null;
    orderID = json["OrderID"] != null ? int.parse(json["OrderID"].toString()) : null;
    itemID = json["ItemID"] != null ? int.parse(json["ItemID"].toString()) : null;
    qty = json["Qty"] != null ? double.parse(json["Qty"].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderDetailID'] = this.orderDetailID;
    data['OrderID'] = this.orderID;
    data['ItemID'] = this.itemID;
    data['Qty'] = this.qty;
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

