import 'package:consus_erp/Model/AreasAndregion/get_all_regions.dart';
import 'package:consus_erp/Model/AreasAndregion/get_areas.dart';
import 'package:consus_erp/Model/Items/get_items.dart';
import 'package:consus_erp/Model/TradeChannel/trade_channel.dart';
import 'package:consus_erp/Model/items.dart';
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
  GetItemsData? getItemsData;

  List<DropDownValueModel> channelList = <DropDownValueModel>[];
  List<DropDownValueModel> areasList = <DropDownValueModel>[];
  List<ItemsModel> lstItems = <ItemsModel>[];

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
    Future.delayed(Duration.zero,()=>notifyListeners());
  }
  
  Future<void> getItemsList() async{
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_ITEMS}?itemid=0");
    logger.i("<<<All Items Response>>> $response");
    if(response.isEmpty) return;
    saveItemsToLocal(response);
    getItemsFromLocal();
    notifyListeners();
  }

  void saveItemsToLocal(String response) async{
    if(response.isEmpty) return;
    await LocalStorage.box.write(LocalStorage.Add_Items, response);
    notifyListeners();
  }

  void getItemsFromLocal(){
    lstItems = <ItemsModel>[];
    if(!LocalStorage.box.hasData(LocalStorage.Add_Items)) return;
    String data = LocalStorage.box.read(LocalStorage.Add_Items);
    logger.i(data);
    getItemsData = getItemsDataFromJson(data);
    getItemsData!.data!.forEach((element) {
      lstItems.add(element);
    });
    Future.delayed(Duration.zero,()=>notifyListeners());
  }

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
    Future.delayed(Duration.zero,()=>notifyListeners());
  }
}
