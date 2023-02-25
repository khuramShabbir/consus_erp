import 'dart:convert';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

class ApiResponse{

  String responseMessage;
  Map<String, dynamic>? data;
  bool isValid;
  bool error;
  dynamic errorDetail;

  ApiResponse({
    required this.responseMessage,
    this.data,
    required this.isValid,
    required this.error,
    required this.errorDetail,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    responseMessage: json["ResponseMessage"],
    data: json["Data"],
    isValid: json["IsValid"],
    error: json["Error"],
    errorDetail: json["ErrorDetail"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseMessage": responseMessage,
    "Data": data,
    "IsValid": isValid,
    "Error": error,
    "ErrorDetail": errorDetail,
  };

}