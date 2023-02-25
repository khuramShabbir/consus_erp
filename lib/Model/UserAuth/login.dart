import 'dart:convert';

import 'package:consus_erp/Model/UserAuth/user.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

class LoginResponse {
  LoginResponse({
    this.responseMessage,
    this.user,
    this.isValid,
    this.error,
    this.errorDetail,
  });

  String? responseMessage;
  User? user;
  bool? isValid;
  bool? error;
  dynamic errorDetail;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        responseMessage: json["ResponseMessage"],
        user: json["Data"] != null ? User.fromJson(json["Data"]) : null,
        isValid: json["IsValid"],
        error: json["Error"],
        errorDetail: json["ErrorDetail"],
      );

  Map<String, dynamic> toJson() => {
        "ResponseMessage": responseMessage,
        "Data": user?.toJson(),
        "IsValid": isValid,
        "Error": error,
        "ErrorDetail": errorDetail,
      };
}
