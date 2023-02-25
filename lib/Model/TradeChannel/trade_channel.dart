import 'dart:convert';

GetAllTradeChannelResponse getAllTradeChannelResponseFromJson(String str) =>
    GetAllTradeChannelResponse.fromJson(json.decode(str));

class GetAllTradeChannelResponse {
  GetAllTradeChannelResponse({
    this.responseMessage,
    this.channel,
    this.isValid,
    this.error,
    this.errorDetail,
  });

  String? responseMessage;
  List<TradeChannel>? channel;
  bool? isValid;
  bool? error;
  String? errorDetail;

  factory GetAllTradeChannelResponse.fromJson(Map<String, dynamic> json) =>
      GetAllTradeChannelResponse(
        responseMessage: json["ResponseMessage"],
        channel: json["Data"] != null
            ? List<TradeChannel>.from(json["Data"].map((x) => TradeChannel.fromJson(x)))
            : null,
        isValid: json["IsValid"],
        error: json["Error"],
        errorDetail: json["ErrorDetail"],
      );

  Map<String, dynamic> toJson() => {
        "ResponseMessage": responseMessage,
        "Data": channel != null ? List<dynamic>.from(channel!.map((x) => x.toJson())) : null,
        "IsValid": isValid,
        "Error": error,
        "ErrorDetail": errorDetail,
      };
}

class TradeChannel {
  TradeChannel({
    this.tradeChannelId,
    this.channelName,
  });

  int? tradeChannelId;
  String? channelName;

  factory TradeChannel.fromJson(Map<String, dynamic> json) => TradeChannel(
        tradeChannelId: json["TradeChannelID"],
        channelName: json["ChannelName"],
      );

  Map<String, dynamic> toJson() => {
        "TradeChannelID": tradeChannelId,
        "ChannelName": channelName,
      };
}
