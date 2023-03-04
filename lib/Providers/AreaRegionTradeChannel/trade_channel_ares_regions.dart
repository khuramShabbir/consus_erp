import 'package:consus_erp/Model/AreasAndregion/get_all_regions.dart';
import 'package:consus_erp/Model/AreasAndregion/get_areas.dart';
import 'package:consus_erp/Model/TradeChannel/trade_channel.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/Services/ApiServices/api_urls.dart';
import 'package:consus_erp/Services/StorageServices/storage_services.dart';
import 'package:consus_erp/Widgets/DropDownField/dropdown_textfield.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';

class TradeChannelAreasRegionsProvider extends ChangeNotifier {
  GetAllTradeChannelResponse? tradeChannels;
  GetAllRegionsResponse? regionsResponse;
  GetAreasResponse? getAreasResponse;

  List<DropDownValueModel> channelList = <DropDownValueModel>[];
  List<DropDownValueModel> regionsList = <DropDownValueModel>[];
  List<DropDownValueModel> areasList = <DropDownValueModel>[];

  Future<void> getTradeChannel() async {
    String response = await ApiServices.getMethodApi(ApiUrls.GET_TRADE_CHANNEL);
    logger.i("<<<<<<All Trade Channels>>>>>>$response");
    if (response.isEmpty) return;
   await saveTradeChannel(response);
    getTradeChannelLocal();

    notifyListeners();
  }
  Future<void> saveTradeChannel(String value) async {
    await LocalStorage.box.write(LocalStorage.Trade_Channel, value);
    notifyListeners();
  }

  void getTradeChannelLocal() {
    if (LocalStorage.box.hasData(LocalStorage.Trade_Channel))
      tradeChannels = getAllTradeChannelResponseFromJson(LocalStorage.box.read(LocalStorage.Trade_Channel));

    tradeChannels?.channel?.forEach(
          (element) {
        channelList.add(DropDownValueModel(name: element.channelName ?? "", value: element.tradeChannelId));
      },
    );
    notifyListeners();
  }


  // void getRegions() async {
  //   String response = await ApiServices.getMethodApi(ApiUrls.GET_REGIONS + "0");
  //   logger.i("<<<<<<All GET_REGIONS >>>>>>$response");
  //   if (response.isEmpty) return;
  //   regionsResponse = getAllRegionsResponseFromJson(response);
  //
  //   regionsResponse?.regions?.forEach(
  //     (element) {
  //       regionsList.add(DropDownValueModel(name: element.regionName ?? "", value: element.regionId));
  //     },
  //   );
  //
  //   notifyListeners();
  // }

  Future<void> getAreas() async {
    String response = await ApiServices.getMethodApi(
        "Areas/GetAreaBySalePerson?SalePersonID=${LoginProvider.getUser().salePersonId}");
    logger.i("<<<<<<All GET_REGIONS >>>>>>$response");
    if (response.isEmpty) return;
  await  saveAreas(response);

    getAreasFromLocal();
    notifyListeners();
  }

  Future<void> saveAreas(String value) async {
    await LocalStorage.box.write(LocalStorage.AREAS, value);
    notifyListeners();
  }

  void getAreasFromLocal() {
    if (LocalStorage.box.hasData(LocalStorage.AREAS))
      getAreasResponse = getAreasResponseFromJson(LocalStorage.box.read(LocalStorage.AREAS));
    getAreasResponse?.areas?.forEach(
      (element) {
        areasList.add(DropDownValueModel(name: element.areaName ?? "", value: element.areaId));
      },
    );
    notifyListeners();
  }
}
