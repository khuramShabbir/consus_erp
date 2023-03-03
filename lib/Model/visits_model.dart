import 'dart:convert';

VisitsApiResponse visitsApiResponseFromJson(String str) => VisitsApiResponse.fromJson(json.decode(str));

String visitsApiResponseToJson(VisitsApiResponse data) => json.encode(data.toJson());

class VisitsApiResponse {
  VisitsApiResponse({
    required this.responseMessage,
    required this.data,
    required this.isValid,
    required this.error,
    this.errorDetail,
  });

  String responseMessage;
  List<VisitsModel> data;
  bool isValid;
  bool error;
  dynamic errorDetail;

  factory VisitsApiResponse.fromJson(Map<String, dynamic> json) => VisitsApiResponse(
    responseMessage: json["ResponseMessage"],
    data: List<VisitsModel>.from(json["Data"].map((x) => VisitsModel.fromJson(x))),
    isValid: json["IsValid"],
    error: json["Error"],
    errorDetail: json["ErrorDetail"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseMessage": responseMessage,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "IsValid": isValid,
    "Error": error,
    "ErrorDetail": errorDetail,
  };
}

class VisitsModel {
  VisitsModel({
    required this.visitsDetail,
    required this.visitId,
    required this.shopId,
    required this.visitNo,
    required this.ShopName,
    required this.SalePersonName,
    required this.visitDate,
    required this.salePersonId,
    required this.longitude,
    required this.latitude,
    required this.googleAddress,
    required this.createdBy,
    required this.createdOn,
    required this.updatedBy,
    required this.updatedOn,
    required this.remarks,
    required this.systemNotes,
    required this.verify,
  });

  List<VisitsDetail> visitsDetail;
  int visitId;
  int shopId;
  String visitNo;
  String ShopName;
  String SalePersonName;
  DateTime visitDate;
  int salePersonId;
  double longitude;
  double latitude;
  String googleAddress;
  int createdBy;
  DateTime createdOn;
  int updatedBy;
  DateTime updatedOn;
  String remarks;
  String systemNotes;
  bool verify;

  factory VisitsModel.fromJson(Map<String, dynamic> json) => VisitsModel(
    visitsDetail: List<VisitsDetail>.from(json["visitsDetail"].map((x) => VisitsDetail.fromJson(x))),
    visitId: json["VisitID"],
    shopId: json["ShopID"],
    visitNo: json["VisitNo"],
    ShopName: json["ShopName"],
    SalePersonName: json["SalePersonName"],
    visitDate: DateTime.parse(json["VisitDate"]),
    salePersonId: json["SalePersonID"],
    longitude: json["Longitude"]?.toDouble(),
    latitude: json["Latitude"]?.toDouble(),
    googleAddress: json["GoogleAddress"],
    createdBy: json["CreatedBy"],
    createdOn: DateTime.parse(json["CreatedOn"]),
    updatedBy: json["UpdatedBy"],
    updatedOn: DateTime.parse(json["UpdatedOn"]),
    remarks: json["Remarks"],
    systemNotes: json["SystemNotes"],
    verify: json["Verify"],
  );

  Map<String, dynamic> toJson() => {
    "visitsDetail": List<dynamic>.from(visitsDetail.map((x) => x.toJson())),
    "VisitID": visitId,
    "ShopID": shopId,
    "VisitNo": visitNo,
    "ShopName": ShopName,
    "SalePersonName": SalePersonName,
    "VisitDate": visitDate.toIso8601String(),
    "SalePersonID": salePersonId,
    "Longitude": longitude,
    "Latitude": latitude,
    "GoogleAddress": googleAddress,
    "CreatedBy": createdBy,
    "CreatedOn": createdOn.toIso8601String(),
    "UpdatedBy": updatedBy,
    "UpdatedOn": updatedOn.toIso8601String(),
    "Remarks": remarks,
    "SystemNotes": systemNotes,
    "Verify": verify,
  };
}

class VisitsDetail {
  VisitsDetail({
    this.visitDetailId,
    this.visitId,
    this.narration,
    this.imageUrl,
  });

  int? visitDetailId;
  int? visitId;
  String? narration;
  String? imageUrl;

  factory VisitsDetail.fromJson(Map<String, dynamic> json) => VisitsDetail(
    visitDetailId: json["VisitDetailID"],
    visitId: json["VisitID"],
    narration: json["Narration"],
    imageUrl: json["ImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "VisitDetailID": 0,
    "VisitID": visitId,
    "Narration": narration,
    "ImageUrl": imageUrl,
  };
}

class VisitListDetails{
  int? srNo;
  String? imageUrl;
  String? description;
  VisitListDetails({this.srNo, this.imageUrl, this.description});

  VisitListDetails.fromJson(Map<String, dynamic> json){
    srNo = json['srNo'];
    imageUrl = json['imageUrl'];
    description = json['description'];
  }

  Map<String, dynamic> toJson(){
    return{
      'srNo' : this.srNo,
      'imageUrl' : this.imageUrl,
      'description' : this.description
    };
  }
}

VisitsListApiResponse visitsListApiResponseFromJson(String str) =>
    VisitsListApiResponse.fromJson(json.decode(str));

class VisitsListApiResponse {
  String? responseMessage;
  List<AppVisitsList>? data;
  bool? isValid;
  bool? error;
  Null errorDetail;

  VisitsListApiResponse(
      {this.responseMessage,
        this.data,
        this.isValid,
        this.error,
        this.errorDetail});

  VisitsListApiResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <AppVisitsList>[];
      json['Data'].forEach((v) {
        data!.add(new AppVisitsList.fromJson(v));
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

class AppVisitsList {
  int? visitID;
  String? visitNo;
  String? visitDate;
  String? visitTime;
  String? salePersonName;
  String? shopName;
  String? regionName;
  String? imageUrl;
  String? googleAddress;
  String? remarks;

  AppVisitsList(
      {this.visitID,
        this.visitNo,
        this.visitDate,
        this.visitTime,
        this.salePersonName,
        this.shopName,
        this.regionName,
        this.imageUrl,
        this.googleAddress,
        this.remarks});

  AppVisitsList.fromJson(Map<String, dynamic> json) {
    visitID = json['VisitID'];
    visitNo = json['VisitNo'];
    visitDate = json['VisitDate'];
    visitTime = json['VisitTime'];
    salePersonName = json['SalePersonName'];
    shopName = json['ShopName'];
    regionName = json['RegionName'];
    imageUrl = json['ImageUrl'];
    googleAddress = json['GoogleAddress'];
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VisitID'] = this.visitID;
    data['VisitNo'] = this.visitNo;
    data['VisitDate'] = this.visitDate;
    data['VisitTime'] = this.visitTime;
    data['SalePersonName'] = this.salePersonName;
    data['ShopName'] = this.shopName;
    data['RegionName'] = this.regionName;
    data['ImageUrl'] = this.imageUrl;
    data['GoogleAddress'] = this.googleAddress;
    data['Remarks'] = this.remarks;
    return data;
  }
}
