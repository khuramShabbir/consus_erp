import 'dart:async';

import 'package:consus_erp/Model/order.dart';
import 'package:consus_erp/Providers/OrdersProvider/add_new_order_provider.dart';
import 'package:consus_erp/Providers/OrdersProvider/orders_provider.dart';

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
  bool shopChecked = true, itemChecked = true, branchChecked = true, regionChecked = true, ordersChecked = true,
  areaChecked = true, spChecked = true, tcChecked = true, spDetailChecked = true, tradeChannel=true;
  /// TODO:


  late ShopsProvider shopsProvider;
  late TradeChannelAreasRegionsProvider tradeChannelAreasRegionsProvider;
  late OrdersProvider ordersProvider;
  late AddNewOrderProvider addNewOrderProvider;


  @override
  void initState() {

    shopsProvider=Provider.of<ShopsProvider>(context,listen: false);
    tradeChannelAreasRegionsProvider=Provider.of<TradeChannelAreasRegionsProvider>(context,listen: false);
    ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    addNewOrderProvider = Provider.of<AddNewOrderProvider>(context, listen: false);
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
       if(ordersChecked){
         await addNewOrderProvider.submitSavedOrders();
         await ordersProvider.getOrdersList();
       }
       if(itemChecked) await tradeChannelAreasRegionsProvider.getItemsList();
       if(areaChecked) await tradeChannelAreasRegionsProvider.getAreas();
       if(tradeChannel) await tradeChannelAreasRegionsProvider.getTradeChannel();
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


            /// Sync Shops
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


            /// Sync Orders
            CheckboxListTile(
                title: const Text('Sync Orders'),
                value: ordersChecked,
                onChanged: (bool? value){
                  setState(() {
                    ordersChecked = value!;
                    importDataController.isSyncOrders = ordersChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),

            Consumer<OrdersProvider>(
              builder: (BuildContext context, value, Widget? child){
                return value.searching? LinearPercentIndicator(percent: value.progressValue,) : SizedBox.shrink();
              },
            ),


            ///Sync Items
            CheckboxListTile(
                title: const Text('Sync Items'),
                value: itemChecked,
                onChanged: (bool? value){
                  setState(() {
                    itemChecked = value!;
                    importDataController.isSyncItem = itemChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),


            /// Sync Areas
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

            ///Sync Trade Channel
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
