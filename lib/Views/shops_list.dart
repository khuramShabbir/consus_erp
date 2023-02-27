import 'package:consus_erp/Model/Shops/shop_model.dart';
import 'package:consus_erp/Providers/ShopsProvider/shops_provider.dart';
import 'package:consus_erp/Providers/ShopsProvider/trade_channel_and_regions.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Views/add_new_shops_screen.dart';
import 'package:consus_erp/Widgets/DropDownField/dropdown_textfield.dart';
import 'package:consus_erp/Widgets/ShopCard/shop_card.dart';
import 'package:consus_erp/Widgets/form_field.dart';
import 'package:consus_erp/Widgets/static_widgets.dart';
import 'package:consus_erp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ShopsList extends StatefulWidget {
  const ShopsList({Key? key}) : super(key: key);

  @override
  State<ShopsList> createState() => _ShopsListState();
}

class _ShopsListState extends State<ShopsList> {
  late TradeChannelAndRegionsProvider tradeChannelProvider;
  late ShopsProvider shopProvider;

  @override
  void initState() {
    tradeChannelProvider = Provider.of<TradeChannelAndRegionsProvider>(context, listen: false);
    shopProvider = Provider.of<ShopsProvider>(context, listen: false);
    shopProvider.getShopsFromLocal();
    tradeChannelProvider.getTradeChannel();
    tradeChannelProvider.getRegions();

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
          children: [
            SizedBox(height: 10),

            /// Date From + Date To
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: AppFormField(
            //         controller: shopProvider.dateFromCtrl,
            //         prefixIcon: Icon(Icons.calendar_month),
            //         labelText: "From",
            //         readOnly: true,
            //         onTap: () async {
            //           await shopProvider.getFromDate();
            //         },
            //       ),
            //     ),
            //     SizedBox(width: 10),
            //     Expanded(
            //       child: AppFormField(
            //         controller: shopProvider.dateToCtrl,
            //         prefixIcon: Icon(Icons.calendar_month),
            //         labelText: "To",
            //         readOnly: true,
            //         onTap: () async {
            //           await shopProvider.getToDate();
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            //
            /// Sale Person + Region
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppFormField(
                    labelText: "Sale Person",
                    readOnly: true,
                    controller: TextEditingController(text: LoginProvider.getUser().fullName),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Consumer<TradeChannelAndRegionsProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      return value.regionsList.isEmpty
                          ? SizedBox()
                          : DropDownTextField(
                              label: "Region",
                              dropDownList: value.regionsList,
                              initialValue: value.regionsList.first.name,
                              onChanged: (value) {
                                shopProvider.regionCtrl.text = value.name;
                              },
                            );
                    },
                  ),
                ),
              ],
            ),

            /// Sync Shop
            Consumer<ShopsProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await value.getShopsAndSave();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: CustomTheme.skyBlue, borderRadius: BorderRadius.circular(3)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: !value.searching
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Sync",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.sync,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ],
                                )
                              : AppWidgets.syncGif,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: AppFormField(
                        // controller: value.shopSearchCtrl,
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
                        itemCount: shopProvider.getShopsData == null
                            ? 0
                            : shopProvider.getShopsData?.shopList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ShopData? shop = value.getShopsData?.shopList[index];

                          if (shop?.shopName != null &&
                                  shop!.shopName!
                                      .toLowerCase()
                                      .contains(value.shopSearchCtrl.text.toLowerCase()) ||
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
