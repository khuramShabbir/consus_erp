import 'dart:convert';

TradeChannelApiResponse tcApiResponseFromJson(String str) =>
    TradeChannelApiResponse.fromJson(json.decode(str));

class TradeChannelApiResponse {
  String? responseMessage;
  List<TradeChannel>? data;
  bool? isValid;
  bool? error;
  Null? errorDetail;

  TradeChannelApiResponse(
      {this.responseMessage,
        this.data,
        this.isValid,
        this.error,
        this.errorDetail});

  TradeChannelApiResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['ResponseMessage'];
    if (json['Data'] != null) {
      data = <TradeChannel>[];
      json['Data'].forEach((v) {
        data!.add(new TradeChannel.fromJson(v));
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

class TradeChannel {
  int? tradeChannelID;
  String? channelName;

  TradeChannel({this.tradeChannelID, this.channelName});

  TradeChannel.fromJson(Map<String, dynamic> json) {
    tradeChannelID = json['TradeChannelID'];
    channelName = json['ChannelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TradeChannelID'] = this.tradeChannelID;
    data['ChannelName'] = this.channelName;
    return data;
  }
}
