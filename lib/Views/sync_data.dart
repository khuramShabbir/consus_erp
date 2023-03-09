import 'dart:async';

import '/Providers/AreaRegionTradeChannel/trade_channel_ares_regions.dart';
import '/Providers/ShopsProvider/shops_provider.dart';
import '/controllers/sync_controller.dart';
import '/utils/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

import '../controllers/import_data_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';


class SyncData extends StatefulWidget {
  const SyncData({Key? key}) : super(key: key);

  @override
  State<SyncData> createState() => _SyncDataState();
}

class _SyncDataState extends State<SyncData> {
  dataSynchronization syncController = new dataSynchronization();
  ImportDataFromJson importDataController = new ImportDataFromJson();
  bool shopChecked = true, itemChecked = true, branchChecked = true, regionChecked = true,
  areaChecked = true, spChecked = true, tcChecked = true, spDetailChecked = true, tradeChannel=true;
  /// TODO:


  late ShopsProvider shopsProvider;
  late TradeChannelAreasRegionsProvider tradeChannelAreasRegionsProvider;



  @override
  void initState() {

    shopsProvider=Provider.of<ShopsProvider>(context,listen: false);
    tradeChannelAreasRegionsProvider=Provider.of<TradeChannelAreasRegionsProvider>(context,listen: false);

    // TODO: implement initState
    //IsInternetAvailable();
    super.initState();
  }

  Future IsInternetAvailable() async{
    await syncController.isInternet().then((connection)async{
      if(connection){
        logger.i('Connected to internet');
     if(shopChecked)
    {

      await addNewShopProvider.submitSavedShop();
      await shopsProvider.getShopsViaPagination();



    }
     if(areaChecked)   await  tradeChannelAreasRegionsProvider.getAreas();
     if(tradeChannel)  await  tradeChannelAreasRegionsProvider.getTradeChannel();
      }
      else{
        print('Disconnected from internet');
        Info.errorSnackBar('No internet available, please connect to internet to sync data.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sync Data',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Sync Shops'),
              value: shopChecked,
              onChanged: (bool? value){
                setState(() {
                  shopChecked = value!;
                  importDataController.isSyncShop = shopChecked;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              secondary: Icon(FeatherIcons.shoppingBag)
            ),
             Consumer<ShopsProvider>(builder: (BuildContext context, value, Widget? child) { return

              value.searching? LinearPercentIndicator(percent: value.progressValue):SizedBox.shrink();


             },),



            CheckboxListTile(
                title: const Text('Sync Areas'),
                value: areaChecked,
                onChanged: (bool? value){
                  setState(() {
                    areaChecked = value!;
                    importDataController.isSyncArea = areaChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),
            CheckboxListTile(
                title: const Text('Sync Trade Channel'),
                value: tradeChannel,
                onChanged: (bool? value){
                  setState(() {
                    tradeChannel = value!;
                    importDataController.isTradeChannel = tradeChannel;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),

            FxSpacing.height(70),
            ElevatedButton(onPressed: (){




              IsInternetAvailable();
              setState(() {
                importDataController.lastSyncDate();
              });
            },
            child: const Text('Sync Data')
            )
          ],
        ),
      ),
    );
  }
}
