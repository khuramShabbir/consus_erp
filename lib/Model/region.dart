import 'dart:convert';

RegionApiResponse regionApiResponseFromJson(String str) =>
    RegionApiResponse.fromJson(json.decode(str));

class RegionApiResponse {
  String? responseMessage;
  List<Region>? data;
  bool? isValid;
  bool? error;
  Null errorDetail;

  RegionApiResponse({this.responseMessage, this.data, this.isValid, this.error, this.errorDetail});

  RegionApiResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <Region>[];
      json['Data'].forEach((v) {
        data!.add(new Region.fromJson(v));
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

class Region {
  int? regionID;
  String? regionCode;
  String? regionName;
  bool? isActive;

  Region({required this.regionID, this.regionCode, this.regionName, this.isActive});

  Region.fromJson(Map<String, dynamic> json) {
    regionID = json['RegionID'];
    regionCode = json['RegionCode'];
    regionName = json['RegionName'];
    isActive = json['IsActive'];
  }

  Region.fromMap(Map<String, dynamic> json) {
    regionID = json['RegionID'];
    regionCode = json['RegionCode'];
    regionName = json['RegionName'];
    isActive = json['IsActive'] == 0 ? false : true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RegionID'] = this.regionID;
    data['RegionCode'] = this.regionCode;
    data['RegionName'] = this.regionName;
    data['IsActive'] = this.isActive;
    return data;
  }
}
