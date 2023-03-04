import 'package:consus_erp/Providers/AreaRegionTradeChannel/trade_channel_ares_regions.dart';
import 'package:consus_erp/Providers/ShopsProvider/add_new_shop_provider.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Views/Shops/view_saved_shops.dart';
import 'package:consus_erp/Widgets/DropDownField/dropdown_textfield.dart';
import 'package:consus_erp/Widgets/form_field.dart';
import 'package:consus_erp/controllers/shops_controller.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddNewShops extends StatefulWidget {
  const AddNewShops({Key? key}) : super(key: key);

  @override
  State<AddNewShops> createState() => _AddNewShopsState();
}

class _AddNewShopsState extends State<AddNewShops> {
  late AddNewShopProvider shopsProvider;
  late TradeChannelAreasRegionsProvider tradeChannelAreasRegionsProvider;

  @override
  void initState() {
    shopsProvider = Provider.of<AddNewShopProvider>(context, listen: false);
    tradeChannelAreasRegionsProvider = Provider.of<TradeChannelAreasRegionsProvider>(context, listen: false);
    shopsProvider.salePersonCtrl.text = LoginProvider.getUser().fullName ?? "";
    tradeChannelAreasRegionsProvider.getTradeChannelLocal();
    tradeChannelAreasRegionsProvider.getAreasFromLocal();
    shopsProvider.getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Shop',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                actionButton(
                  onTap: () {
                    Get.to(() => ViewSavedShops());
                  },
                  text: "Saved Shops",
                  buttonColor: Colors.green,
                  icon: Icon(Icons.visibility, color: Colors.white),
                ),
              ],
            ),
          )
        ],
        //centerTitle: true,
      ),
      bottomNavigationBar:

          /// Actions Buttons
          Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            actionButton(onTap: () async {}, text: 'New Entry', buttonColor: Colors.green[400]),
            actionButton(
                onTap: () {
                  shopsProvider.saveShop();
                },
                text: 'Save Entry',
                buttonColor: Colors.blue[400]),
            actionButton(
                onTap: () {
                  shopsProvider.addShop();
                },
                text: 'Submit',
                buttonColor: Colors.tealAccent[400])
          ],
        ),
      ),
      body: Form(
        key: shopsProvider.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Sale Person Name
                Text(
                  shopsProvider.salePersonCtrl.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    /// Area
                    Expanded(
                      child: Consumer<TradeChannelAreasRegionsProvider>(
                        builder: (BuildContext context, value, Widget? child) {
                          return value.areasList.isEmpty
                              ? Text("Please Sync Areas")
                              : DropDownTextField(
                                  label: "Area",
                                  dropDownList: value.areasList,
                                  initialValue: null,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*Required";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.always,
                                  onChanged: (value) {
                                    shopsProvider.areaCtrl.text = value.name;
                                    shopsProvider.areaCtrl.text = value.value.toString();
                                  },
                                );
                        },
                      ),
                    ),
                    SizedBox(width: 10),

                    /// Trade Chanel Consumer

                    Expanded(
                      child: Consumer<TradeChannelAreasRegionsProvider>(
                        builder: (BuildContext context, value, Widget? child) {
                          return value.channelList.isEmpty
                              ? Text("Please Sync TradeChannels")
                              : DropDownTextField(
                                  dropDownList: value.channelList,
                                  autovalidateMode: AutovalidateMode.always,
                                  label: "Trade Channel",
                                  initialValue: "None",
                                  onChanged: (value) {
                                    shopsProvider.tradeChanelCtrl.text = value.value.toString();

                                    logger.i(value.value);

                                    // shopsProvider.tradeChanelID = value.id;
                                  },
                                );
                        },
                      ),
                    ),
                  ],
                ),

                /// Shop Name
                AppFormField(
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
                  labelText: "Shop Name",
                  controller: shopsProvider.shopNameCtrl,
                ),

                /// Contact Person

                AppFormField(
                  labelText: "Contact Person",
                  controller: shopsProvider.contactPersonCtrl,
                ),

                ///Contact Number
                AppFormField(
                  keyboardType: TextInputType.number,
                  labelText: "Contact Number",
                  controller: shopsProvider.contactNumberCtrl,
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
                ),

                /// NTN Number
                AppFormField(
                  labelText: "NTN No",
                  controller: shopsProvider.ntnNoCtrl,
                ),

                /// Lnd and Lat
                AppFormField(
                  autoValidateMode: AutovalidateMode.always,
                  readOnly: true,
                  labelText: "Lat, Lng",
                  controller: shopsProvider.latLngCtrl,
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
                ),

                /// GEO Location
                AppFormField(
                  labelText: "Geo Location",
                  controller: shopsProvider.geoLocationCtrl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget actionButton({required VoidCallback onTap, required String text, required Color? buttonColor, Icon? icon}) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
      child: ElevatedButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) icon,
            if (icon != null) SizedBox(width: 5),
            Text(text),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
        ),
      ),
    );
  }
}
