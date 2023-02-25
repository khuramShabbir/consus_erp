import 'dart:convert';

AreaApiResponse areaApiResponseFromJson(String str) => AreaApiResponse.fromJson(json.decode(str));

class AreaApiResponse {
  String? responseMessage;
  List<Area>? data;
  bool? isValid;
  bool? error;
  Null errorDetail;

  AreaApiResponse(
      {required this.responseMessage, this.data, this.isValid, this.error, this.errorDetail});

  AreaApiResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <Area>[];
      json['Data'].forEach((v) {
        data!.add(new Area.fromJson(v));
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

class Area {
  int? areaID;
  int? regionID;
  String? areaName;
  bool? isActive;

  Area({this.areaID, this.regionID, this.areaName, this.isActive});

  Area.fromJson(Map<String, dynamic> json) {
    areaID = json['AreaID'];
    regionID = json['RegionID'];
    areaName = json['AreaName'];
    isActive = json['IsActive'];
  }

  Area.fromMap(Map<String, dynamic> json) {
    areaID = json['AreaID'];
    regionID = json['RegionID'];
    areaName = json['AreaName'];
    isActive = json['IsActive'] == 0 ? false : true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AreaID'] = this.areaID;
    data['RegionID'] = this.regionID;
    data['AreaName'] = this.areaName;
    data['IsActive'] = this.isActive;
    return data;
  }
}
