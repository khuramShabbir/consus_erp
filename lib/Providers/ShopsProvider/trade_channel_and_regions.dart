import 'package:consus_erp/Model/TradeChannel/trade_channel.dart';
import 'package:consus_erp/Providers/ShopsProvider/get_all_regions.dart';
import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/Services/ApiServices/api_urls.dart';
import 'package:consus_erp/Widgets/DropDownField/dropdown_textfield.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';

class TradeChannelAndRegionsProvider extends ChangeNotifier {
  GetAllTradeChannelResponse? tradeChannels;
  GetAllRegionsResponse? regionsResponse;

  List<DropDownValueModel> channelList = <DropDownValueModel>[];
  List<DropDownValueModel> regionsList = <DropDownValueModel>[];

  void getTradeChannel() async {
    String response = await ApiServices.getMethodApi(ApiUrls.GET_TRADE_CHANNEL);
    logger.i("<<<<<<All Trade Channels>>>>>>$response");
    if (response.isEmpty) return;
    tradeChannels = getAllTradeChannelResponseFromJson(response);

    tradeChannels?.channel?.forEach(
      (element) {
        channelList.add(
            DropDownValueModel(name: element.channelName ?? "", value: element.tradeChannelId));
      },
    );

    notifyListeners();
  }

  void getRegions() async {
    String response = await ApiServices.getMethodApi(ApiUrls.GET_REGIONS + "0");
    logger.i("<<<<<<All GET_REGIONS >>>>>>$response");
    if (response.isEmpty) return;
    regionsResponse = getAllRegionsResponseFromJson(response);

    regionsResponse?.regions?.forEach(
      (element) {
        regionsList
            .add(DropDownValueModel(name: element.regionName ?? "", value: element.regionId));
      },
    );

    notifyListeners();
  }
}
