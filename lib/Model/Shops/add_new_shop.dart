import 'dart:convert';

import 'shop_model.dart';

AddShopResponse addShopResponseFromJson(String str) => AddShopResponse.fromJson(json.decode(str));

List<ShopData> shopsListFromJson(String str) =>
    List<ShopData>.from(json.decode(str).map((x) => ShopData.fromJson(x)));

class AddShopResponse {
  AddShopResponse({
    this.responseMessage,
    this.data,
    this.isValid,
    this.error,
    this.errorDetail,
  });

  String? responseMessage;
  ShopData? data;
  bool? isValid;
  bool? error;
  dynamic errorDetail;

  factory AddShopResponse.fromJson(Map<String, dynamic> json) => AddShopResponse(
        responseMessage: json["ResponseMessage"],
        data: json["Data"] != null ? ShopData.fromJson(json["Data"]) : null,
        isValid: json["IsValid"],
        error: json["Error"],
        errorDetail: json["ErrorDetail"],
      );

  Map<String, dynamic> toJson() => {
        "ResponseMessage": responseMessage,
        "Data": data?.toJson(),
        "IsValid": isValid,
        "Error": error,
        "ErrorDetail": errorDetail,
      };
}
