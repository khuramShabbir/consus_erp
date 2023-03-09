import 'dart:convert';

import 'package:consus_erp/Model/Shops/shop_model.dart';

GetShops getShopsFromJson(String str) => GetShops.fromJson(json.decode(str));

String convertShopsToJson(GetShops data) {
  return json.encode(data.toJson());
}

class GetShops {
  GetShops({
    this.responseMessage,
    this.shopList = const<ShopData> [],
    this.isValid,
    this.error,
    this.errorDetail,
  });

  String? responseMessage;
  List<ShopData> shopList;
  bool? isValid;
  bool? error;
  String? errorDetail;

  factory GetShops.fromJson(Map<String, dynamic> json) => GetShops(
        responseMessage: json["ResponseMessage"],
        shopList: (json["Data"] != null && json["Data"].isNotEmpty)
            ? List<ShopData>.from(json["Data"].map((x) => ShopData.fromJson(x)))
            : <ShopData>[],
        isValid: json["IsValid"],
        error: json["Error"],
        errorDetail: json["ErrorDetail"],
      );

  Map<String, dynamic> toJson() {
    return {
        "ResponseMessage": responseMessage,
        "Data": shopList.isNotEmpty
            ? List<dynamic>.from(shopList.map((x) => x.toJson()))
            : [],
        "IsValid": isValid,
        "Error": error,
        "ErrorDetail": errorDetail,
      };
  }
}
