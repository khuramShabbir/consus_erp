import 'package:consus_erp/Model/Shops/shop_model.dart';
import 'package:consus_erp/Providers/ShopsProvider/shops_provider.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Views/add_new_shops_screen.dart';
import 'package:consus_erp/Widgets/DropDownField/dropdown_textfield.dart';
import 'package:consus_erp/Widgets/ShopCard/shop_card.dart';
import 'package:consus_erp/Widgets/form_field.dart';
import 'package:consus_erp/Widgets/static_widgets.dart';
import 'package:consus_erp/theme/app_theme.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../Providers/AreaRegionTradeChannel/trade_channel_ares_regions.dart';

class ShopsList extends StatefulWidget {
  const ShopsList({Key? key}) : super(key: key);

  @override
  State<ShopsList> createState() => _ShopsListState();
}

class _ShopsListState extends State<ShopsList> {
  late TradeChannelAreasRegionsProvider tradeChannelProvider;
  late ShopsProvider shopProvider;

  @override
  void initState() {
    tradeChannelProvider = Provider.of<TradeChannelAreasRegionsProvider>(context, listen: false);
    shopProvider = Provider.of<ShopsProvider>(context, listen: false);
    shopProvider.getShopsFromLocal();
    tradeChannelProvider.getTradeChannel();
    // tradeChannelProvider.getRegions();
    // tradeChannelProvider.getAreas();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Shops List',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.to(() => AddNewShops());
            },
            icon: Icon(Icons.add),
            label: Text('Shop'),
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER NAME

            Text(
              LoginProvider.getUser().fullName ?? "",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),

            /// Sync Shop
            Consumer<ShopsProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppFormField(
                        labelText: "Search Shop",
                        onChanged: (String _value) {
                          value.searchShop(_value);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            /// Shops List

            Expanded(child: Consumer<ShopsProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return value.getShopsData?.shopList.isNotEmpty == true
                    ? ListView.builder(
                        itemCount: shopProvider.getShopsData == null ? 0 : shopProvider.getShopsData?.shopList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ShopData? shop = value.getShopsData?.shopList[index];

                          if (shop?.shopName != null &&
                                  shop!.shopName!.toLowerCase().contains(value.shopSearchCtrl.text.toLowerCase()) ||
                              value.shopSearchCtrl.text.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: ShopCard(shop),
                            );
                          } else
                            return SizedBox.shrink();
                        },
                      )
                    : noDataFound();
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget noDataFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "NO DATA FOUND",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          Text(
            "Please Sync Shops or Add Shops",
            style: TextStyle(color: Colors.grey.withOpacity(.5)),
          )
        ],
      ),
    );
  }
}
