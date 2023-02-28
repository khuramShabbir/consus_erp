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
  late ShopsController controller;
  late AddNewShopProvider shopsProvider;

  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    return GeolocatorPlatform.instance.getPositionStream(
      locationSettings: locationSettings,
    );
  }

  @override
  void initState() {
    shopsProvider = Provider.of<AddNewShopProvider>(context, listen: false);

    shopsProvider.salePersonCtrl.text = LoginProvider.getUser().fullName ?? "";
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
            actionButton(
                onTap: () async {
                  final po = await getPositionStream();

                  final p = await po.first;

                  // Position? position = await Geolocator.getCurrentPosition();
                  logger.i(p.latitude);

                  // shopsProvider.submitSavedShop();
                },
                text: 'New Entry',
                buttonColor: Colors.green[400]),
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
          padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
          child: Center(
            child: Column(
              children: [
                /// Sale Person Name
                AppFormField(
                  autoValidateMode: AutovalidateMode.always,
                  readOnly: true,
                  controller: shopsProvider.salePersonCtrl,
                  labelText: "Sale Person",
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
                ),

                /// Shop Name
                AppFormField(
                  autoValidateMode: AutovalidateMode.always,
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
                  labelText: "Shop Name",
                  controller: shopsProvider.shopNameCtrl,
                ),

                /// Shop Code
                AppFormField(
                  labelText: "Shop Code",
                  controller: shopsProvider.shopCodeCtrl,
                  readOnly: true,
                ),

                /// Contact Person

                AppFormField(
                  autoValidateMode: AutovalidateMode.always,
                  labelText: "Contact Person",
                  controller: shopsProvider.contactPersonCtrl,
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
                ),

                ///Contact Number
                AppFormField(
                  autoValidateMode: AutovalidateMode.always,
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

                /// Area
                Consumer<TradeChannelAreasRegionsProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    return value.areasList.isEmpty
                        ? SizedBox()
                        : DropDownTextField(
                            label: "Area",
                            dropDownList: value.areasList,
                            initialValue: null,
                            validator: (value) {
                              if (shopsProvider.areaCtrl.text.isEmpty) {
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

                /// Trade Chanel Consumer

                Consumer<TradeChannelAreasRegionsProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    return value.channelList.isEmpty
                        ? SizedBox()
                        : DropDownTextField(
                            dropDownList: value.channelList,
                            autovalidateMode: AutovalidateMode.always,
                            label: "Trade Channel",
                            validator: (value) {
                              if (shopsProvider.tradeChanelCtrl.text.isEmpty) {
                                return "*Required";
                              }
                              return null;
                            },
                            initialValue: null,
                            onChanged: (value) {
                              shopsProvider.tradeChanelCtrl.text = value.value.toString();

                              logger.i(value.value);

                              // shopsProvider.tradeChanelID = value.id;
                            },
                          );
                  },
                ),

                /// Route
                AppFormField(
                  autoValidateMode: AutovalidateMode.always,
                  labelText: "Route",
                  controller: shopsProvider.routeCtrl,
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
                ),

                /// VPO
                AppFormField(
                  readOnly: true,
                  autoValidateMode: AutovalidateMode.always,
                  labelText: "VPO",
                  controller: shopsProvider.vpoCtrl,
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
                ),

                /// SEO
                AppFormField(
                  autoValidateMode: AutovalidateMode.always,
                  readOnly: true,
                  labelText: "SEO",
                  controller: shopsProvider.seoCtrl,
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
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
                  autoValidateMode: AutovalidateMode.always,
                  labelText: "Geo Location",
                  controller: shopsProvider.geoLocationCtrl,
                  validator: (v) {
                    if (v!.isEmpty) return "*Required";
                    return null;
                  },
                ),

                ///SystemNotes
                AppFormField(
                  labelText: "System Notes",
                  controller: shopsProvider.systemNotesCtrl,
                ),

                /// Remarks
                AppFormField(
                  labelText: "Remarks",
                  controller: shopsProvider.remarksCtrl,
                ),

                ///Description
                AppFormField(
                  labelText: "Description",
                  controller: shopsProvider.descriptionCtrl,
                  height: 500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget actionButton(
      {required VoidCallback onTap,
      required String text,
      required Color? buttonColor,
      Icon? icon}) {
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
