import 'dart:convert';

GetAllRegionsResponse getAllRegionsResponseFromJson(String str) =>
    GetAllRegionsResponse.fromJson(json.decode(str));

class GetAllRegionsResponse {
  GetAllRegionsResponse({
    this.responseMessage,
    this.regions,
    this.isValid,
    this.error,
    this.errorDetail,
  });

  String? responseMessage;
  List<Regions>? regions;
  bool? isValid;
  bool? error;
  String? errorDetail;

  factory GetAllRegionsResponse.fromJson(Map<String, dynamic> json) => GetAllRegionsResponse(
        responseMessage: json["ResponseMessage"],
        regions: json["Data"] != null
            ? List<Regions>.from(json["Data"].map((x) => Regions.fromJson(x)))
            : null,
        isValid: json["IsValid"],
        error: json["Error"],
        errorDetail: json["ErrorDetail"],
      );

  Map<String, dynamic> toJson() => {
        "ResponseMessage": responseMessage,
        "Data": regions != null ? List<dynamic>.from(regions!.map((x) => x.toJson())) : null,
        "IsValid": isValid,
        "Error": error,
        "ErrorDetail": errorDetail,
      };
}

class Regions {
  Regions({
    this.regionId,
    this.regionCode,
    this.regionName,
    this.isActive,
  });

  int? regionId;
  String? regionCode;
  String? regionName;
  bool? isActive;

  factory Regions.fromJson(Map<String, dynamic> json) => Regions(
        regionId: json["RegionID"],
        regionCode: json["RegionCode"],
        regionName: json["RegionName"],
        isActive: json["IsActive"],
      );

  Map<String, dynamic> toJson() => {
        "RegionID": regionId,
        "RegionCode": regionCode,
        "RegionName": regionName,
        "IsActive": isActive,
      };
}
