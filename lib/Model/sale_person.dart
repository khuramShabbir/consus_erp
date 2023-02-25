import 'dart:convert';

SalePersonApiResponse salePersonApiResponseFromJson(String str) =>
    SalePersonApiResponse.fromJson(json.decode(str));

class SalePersonApiResponse {
  String? responseMessage;
  List<SalePerson>? data;
  bool? isValid;
  bool? error;
  Null errorDetail;

  SalePersonApiResponse(
      {this.responseMessage, this.data, this.isValid, this.error, this.errorDetail});

  SalePersonApiResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <SalePerson>[];
      json['Data'].forEach((v) {
        data!.add(new SalePerson.fromJson(v));
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

class SalePerson {
  int? salePersonID;
  String? salePersonName;
  String? salePersonFullName;
  int? parentID;
  String? parentName;
  String? designation;
  double? commission;
  String? email;
  String? phone;
  int? userID;
  int? parentLevel;
  int? regionID;
  int? areaID;
  bool? isActive;
  int? branchID;

  SalePerson(
      {this.salePersonID,
      this.salePersonName,
      this.salePersonFullName,
      this.parentID,
      this.parentName,
      this.designation,
      this.commission,
      this.email,
      this.phone,
      this.userID,
      this.parentLevel,
      this.regionID,
      this.areaID,
      this.isActive,
      this.branchID});

  SalePerson.fromJson(Map<String, dynamic> json) {
    salePersonID = json['SalePersonID'];
    salePersonName = json['SalePersonName'];
    salePersonFullName = json['SalePersonFullName'];
    parentID = json['ParentID'];
    parentName = json['ParentName'];
    designation = json['Designation'];
    commission = json['Commission'];
    email = json['Email'];
    phone = json['Phone'];
    userID = json['UserID'];
    parentLevel = json['ParentLevel'];
    regionID = json['RegionID'];
    areaID = json['AreaID'];
    isActive = json['IsActive'];
    branchID = json['BranchID'];
  }

  SalePerson.fromMap(Map<String, dynamic> json) {
    salePersonID = json['SalePersonID'];
    salePersonName = json['SalePersonName'];
    salePersonFullName = json['SalePersonFullName'];
    parentID = json['ParentID'];
    parentName = json['ParentName'];
    designation = json['Designation'];
    commission = json['Commission'];
    email = json['Email'];
    phone = json['Phone'];
    userID = json['UserID'];
    parentLevel = json['ParentLevel'];
    regionID = json['RegionID'];
    areaID = json['AreaID'];
    isActive = json['IsActive'] == 0 ? false : true;
    branchID = json['BranchID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SalePersonID'] = this.salePersonID;
    data['SalePersonName'] = this.salePersonName;
    data['SalePersonFullName'] = this.salePersonFullName;
    data['ParentID'] = this.parentID;
    data['ParentName'] = this.parentName;
    data['Designation'] = this.designation;
    data['Commission'] = this.commission;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['UserID'] = this.userID;
    data['ParentLevel'] = this.parentLevel;
    data['RegionID'] = this.regionID;
    data['AreaID'] = this.areaID;
    data['IsActive'] = this.isActive;
    data['BranchID'] = this.branchID;
    return data;
  }
}

SalePersonDetailApiResponse salePersonDetailApiResponseFromJson(String str) =>
    SalePersonDetailApiResponse.fromJson(json.decode(str));

class SalePersonDetailApiResponse {
  String? responseMessage;
  List<SalePersonDetail>? data;
  bool? isValid;
  bool? error;
  Null errorDetail;

  SalePersonDetailApiResponse(
      {this.responseMessage, this.data, this.isValid, this.error, this.errorDetail});

  SalePersonDetailApiResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <SalePersonDetail>[];
      json['Data'].forEach((v) {
        data!.add(new SalePersonDetail.fromJson(v));
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

class SalePersonDetail {
  int? salePersonDetailID;
  int? areaID;
  int? salePersonID;
  int? routDay;
  int? checked;

  SalePersonDetail(
      {this.salePersonDetailID, this.areaID, this.salePersonID, this.routDay, this.checked});

  SalePersonDetail.fromJson(Map<String, dynamic> json) {
    salePersonDetailID = json['SalePersonDetailID'];
    areaID = json['AreaID'];
    salePersonID = json['SalePersonID'];
    routDay = json['RoutDay'];
    checked = json['Checked'] == true ? 1 : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SalePersonDetailID'] = this.salePersonDetailID;
    data['AreaID'] = this.areaID;
    data['SalePersonID'] = this.salePersonID;
    data['RoutDay'] = this.routDay;
    data['Checked'] = this.checked;
    return data;
  }
}
