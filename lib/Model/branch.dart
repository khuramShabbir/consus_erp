import 'dart:convert';

BranchApiResponse branchApiResponseFromJson(String str) =>
    BranchApiResponse.fromJson(json.decode(str));

class BranchApiResponse {
  String? responseMessage;
  List<Branch>? data;
  bool? isValid;
  bool? error;
  Null errorDetail;

  BranchApiResponse({this.responseMessage, this.data, this.isValid, this.error, this.errorDetail});

  BranchApiResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <Branch>[];
      json['Data'].forEach((v) {
        data!.add(new Branch.fromJson(v));
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

class Branch {
  int? branchID;
  String? branchName;
  String? address;
  String? email;
  String? phone;
  String? website;
  bool? isHeadOffice;
  String? nTN;
  String? branchCode;
  String? sTRN;
  String? imageUrl;

  Branch(
      {this.branchID,
      this.branchName,
      this.address,
      this.email,
      this.phone,
      this.website,
      this.isHeadOffice,
      this.nTN,
      this.branchCode,
      this.sTRN,
      this.imageUrl});

  Branch.fromJson(Map<String, dynamic> json) {
    branchID = json['BranchID'];
    branchName = json['BranchName'];
    address = json['Address'];
    email = json['Email'];
    phone = json['Phone'];
    website = json['Website'];
    isHeadOffice = json['IsHeadOffice'];
    nTN = json['NTN'];
    branchCode = json['BranchCode'];
    sTRN = json['STRN'];
    imageUrl = json['ImageUrl'];
  }

  Branch.fromMap(Map<String, dynamic> json) {
    branchID = json['BranchID'];
    branchName = json['BranchName'];
    address = json['Address'];
    email = json['Email'];
    phone = json['Phone'];
    website = json['Website'];
    isHeadOffice = json['IsHeadOffice'] == 0 ? false : true;
    nTN = json['NTN'];
    branchCode = json['BranchCode'];
    sTRN = json['STRN'];
    imageUrl = json['ImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BranchID'] = this.branchID;
    data['BranchName'] = this.branchName;
    data['Address'] = this.address;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Website'] = this.website;
    data['IsHeadOffice'] = this.isHeadOffice;
    data['NTN'] = this.nTN;
    data['BranchCode'] = this.branchCode;
    data['STRN'] = this.sTRN;
    data['ImageUrl'] = this.imageUrl;
    return data;
  }
}
