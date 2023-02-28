import 'dart:convert';

GetAreasResponse getAreasResponseFromJson(String str) =>
    GetAreasResponse.fromJson(json.decode(str));

class GetAreasResponse {
  GetAreasResponse({
    this.responseMessage,
    this.areas,
    this.isValid,
    this.error,
    this.errorDetail,
  });

  String? responseMessage;
  List<Areas>? areas;
  bool? isValid;
  bool? error;
  String? errorDetail;

  factory GetAreasResponse.fromJson(Map<String, dynamic> json) => GetAreasResponse(
        responseMessage: json["ResponseMessage"],
        areas: json["Data"] != null
            ? List<Areas>.from(json["Data"].map((x) => Areas.fromJson(x)))
            : null,
        isValid: json["IsValid"],
        error: json["Error"],
        errorDetail: json["ErrorDetail"],
      );

  Map<String, dynamic> toJson() => {
        "ResponseMessage": responseMessage,
        "Data": areas != null ? List<dynamic>.from(areas!.map((x) => x.toJson())) : null,
        "IsValid": isValid,
        "Error": error,
        "ErrorDetail": errorDetail,
      };
}

class Areas {
  Areas({
    this.areaId,
    this.regionId,
    this.areaName,
    this.isActive,
  });

  int? areaId;
  int? regionId;
  String? areaName;
  bool? isActive;

  factory Areas.fromJson(Map<String, dynamic> json) => Areas(
        areaId: json["AreaID"],
        regionId: json["RegionID"],
        areaName: json["AreaName"],
        isActive: json["IsActive"],
      );

  Map<String, dynamic> toJson() => {
        "AreaID": areaId,
        "RegionID": regionId,
        "AreaName": areaName,
        "IsActive": isActive,
      };
}
