import 'package:consus_erp/Model/Items/get_items.dart';
import 'package:consus_erp/Providers/AreaRegionTradeChannel/trade_channel_ares_regions.dart';
import 'package:consus_erp/Providers/OrdersProvider/add_new_order_provider.dart';
import 'package:consus_erp/Providers/ShopsProvider/shops_provider.dart';
import 'package:consus_erp/Widgets/DropDownField/dropdown_textfield.dart';
import 'package:consus_erp/Widgets/form_field.dart';
import 'package:consus_erp/theme/constant.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddNewOrders extends StatefulWidget {
  const AddNewOrders({Key? key}) : super(key: key);

  @override
  State<AddNewOrders> createState() => _AddNewOrdersState();
}

class _AddNewOrdersState extends State<AddNewOrders> {

  late ShopsProvider shopsProvider;
  late AddNewOrderProvider orderProvider;

  @override
  void initState() {
    // TODO: implement initState
    shopsProvider = Provider.of<ShopsProvider>(context, listen:false);
    orderProvider = Provider.of<AddNewOrderProvider>(context, listen: false);
    orderProvider.getItemsFromLocal();
    orderProvider.initTextEditingControllers();
    shopsProvider.fillShopsDropDown();
    orderProvider.newRecord();
    orderProvider.getCurrentPosition();
    logger.i('<<<Shops list count>>> ${shopsProvider.getShopsData?.shopList.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Order',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),

      ),
      bottomNavigationBar:

      /// Actions Buttons
      shopsProvider.getShopsData!.shopList.isEmpty
      ? syncInfo
      : Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            actionButton(
                onTap: () async {
                  Get.defaultDialog(
                      barrierDismissible: true,
                      content: Text("Do you want to cancel?"),
                      onCancel: () {},
                      onConfirm: () {
                        Get.back();
                      });
                },
                text: 'New Entry',
                buttonColor: Colors.green[400]),
            actionButton(
                onTap: () async {
                  if(orderProvider.isAwayFromShop == true || orderProvider.qty == 0.0) {
                    if(orderProvider.qty == 0){
                      orderProvider.setQtyFlag(true);
                    }
                    else{
                      orderProvider.setQtyFlag(false);
                    }
                    if(orderProvider.isAwayFromShop == true){
                      orderProvider.setDistanceFlag(true);
                    }
                    else{
                      orderProvider.setDistanceFlag(false);
                    }
                  }
                  else{
                    bool result = await orderProvider.saveOrderToLocal();
                    logger.i("<<Local save result is $result>>");
                    if(result == true)
                      Navigator.pop(context);
                  }
                },
                text: 'Save Entry',
                buttonColor: Colors.blue[400]),
            // actionButton(
            //     onTap: () {
            //
            //     },
            //     text: 'Submit',
            //     buttonColor: Colors.tealAccent[400])
          ],
        ),
      ),
      body: Form(
        key: orderProvider.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
          child: Center(
            child: Column(
              children: [
                Consumer<AddNewOrderProvider>(
                  builder: (BuildContext context, value, Widget? child){
                    return value.isAwayFromShop
                        ? alertDistance('Cannot save, ${value.distance.round()} meters away from shop', true)
                        : alertDistance('Cannot save, ${value.distance.round()} meters away from shop', false);
                  },
                ),
                Consumer<AddNewOrderProvider>(
                  builder: (BuildContext context, value, Widget? child){
                    return value.isQtyZero
                        ? alertQty('Cannot save, order quantity is zero', true)
                        : alertQty('Cannot save, order quantity is zero', false);
                  },
                ),
                Row(
                  children: [
                    /// Shops
                    Expanded(
                      child: Consumer<ShopsProvider>(
                        builder: (BuildContext context, value, Widget? child) {
                          return value.lstShops.isEmpty
                              ? Text("Please Sync Shops")
                              : DropDownTextField(
                            enableSearch: true,
                            label: "Shops",
                            dropDownList: value.lstShops,
                            initialValue: null,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "*Required";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: (value) {
                              orderProvider.shopId.text = value.value.toString();
                              orderProvider.shopName.text = value.name;
                              logger.i(int.parse(value.value.toString()));
                              orderProvider.calculateDistance(orderProvider.txtLat.text.isEmpty ? 0 : double.parse(orderProvider.txtLat.text),
                                  orderProvider.txtLong.text.isEmpty ? 0 : double.parse(orderProvider.txtLong.text),
                                  value.value.toString().isEmpty ? 0 : int.parse(value.value.toString()));
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),

                /// Remarks
                AppFormField(
                  labelText: "Remarks",
                  controller: orderProvider.txtRemarks,
                ),
                const SizedBox(
                  height: 5.0,
                ),

                /// Latitude and Longitude
                Row(
                  children: [
                    /// Latitude
                    Expanded(
                      flex: 10,
                      child: AppFormField(
                        labelText: "Latitude",
                        controller: orderProvider.txtLat,
                        readOnly: true,
                        validator: (v){
                          if(v!.isEmpty || v! == '0'){
                            return "*Required";
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(child: Text('')),
                    /// Longitude
                    Expanded(
                      flex: 10,
                      child: AppFormField(
                        labelText: "Longitude",
                        controller: orderProvider.txtLong,
                        readOnly: true,
                        validator: (v){
                          if(v!.isEmpty || v! == '0'){
                            return "*Required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),

                /// Total Qty
                Padding(
                    padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Consumer<AddNewOrderProvider>(
                      builder: (BuildContext context, value, Widget? child){
                        return Text('Total Quantity : ${value.qty}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),);
                      },
                    ),
                  ),
                ),

                /// Detail Headers
                SizedBox(
                  height: 40.0,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: Row(
                        children: [
                          Expanded(child: Text('Sr#', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                          Expanded(flex: 2, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),),
                          Expanded(flex: 4, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                        ],
                      ),
                    ),
                  ),
                ),
                /// Orders Detail
                Consumer<AddNewOrderProvider>(
                  builder: (BuildContext context, value, Widget? child){
                    return value.lstItems.isNotEmpty
                        ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: orderProvider.lstItems.length,
                        itemBuilder: (BuildContext context, index) {
                          final ItemsModel items = orderProvider.lstItems[index];
                          final TextEditingController? itemIdCtrl = orderProvider.itemIdController[index];
                          final TextEditingController? itemQtyCtrl = orderProvider.itemQtyController[index];
                          return ordersDetailTiles(items, index+1, itemIdCtrl, itemQtyCtrl);
                        })
                        : Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: ListTile(
                              title: Text('Sync Items First To Add Orders.'),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),

                // tradeChannelAreasRegionsProvider.lstItems.isNotEmpty
                //     ? ListView.builder(
                //     shrinkWrap: true,
                //     physics: ScrollPhysics(),
                //     itemCount: tradeChannelAreasRegionsProvider.lstItems.length,
                //     itemBuilder: (BuildContext context, index) {
                //       final ItemsModel items = tradeChannelAreasRegionsProvider.lstItems[index];
                //       return ordersDetailTiles(items, index+1);
                //     })
                //     : Row(
                //   children: [
                //     Expanded(
                //       child: Card(
                //         child: ListTile(
                //           title: Text('Sync Items First To Add Orders.'),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
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

  Padding syncInfo = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      "Please Sync Shops before adding new orders",
      style: TextStyle(color: Colors.red),
    ),
  );

  /// Orders Detail List
  Widget ordersDetailTiles(ItemsModel items, int index, TextEditingController? itemIdController, TextEditingController? itemQtyController){
    return Consumer<AddNewOrderProvider>(
      builder: (BuildContext context, value, Widget? child){
        return Card(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(
                        children: [
                          Visibility(
                            visible: false,
                            child: Expanded(
                                child: AppFormField(
                                  controller: itemIdController,
                                ),
                            ),
                          ),
                          Text('$index'),
                        ],
                      )
                  ),
                  Expanded(
                    flex: 2,
                      child: Text('${items.itemName}')
                  ),
                  Expanded(
                    flex: 4,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: AppFormField(
                          controller: itemQtyController,
                          keyboardType: TextInputType.number,
                          onChanged: (val){
                            value.calculateDetailQty();
                          },
                        ),
                      )
                  ),
                ],
              ),
            )
        );
      },
    );
  }

  Widget alertDistance(String text, bool isAway) {
    return Visibility(
        visible: isAway ? true : false,
        child: Column(
            children: [
              FxContainer(
                color: Colors.redAccent.withAlpha(220),
                child: Row(
                  children: [
                    FxText.bodySmall(
                      'Alert: ',
                      color: Constant.softColors.green.onColor,
                      fontWeight: 700,
                    ),
                    FxText.bodySmall(
                      overflow: TextOverflow.ellipsis,
                      text,
                      color: Constant.softColors.green.onColor,
                      fontWeight: 600,
                      fontSize: 12,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,)
            ]
        )
    );
  }

  Widget alertQty(String text, bool isQtyZero) {
    return Visibility(
        visible: isQtyZero ? true : false,
        child: Column(
            children: [
              FxContainer(
                color: Colors.redAccent.withAlpha(220),
                child: Row(
                  children: [
                    FxText.bodySmall(
                      'Alert: ',
                      color: Constant.softColors.green.onColor,
                      fontWeight: 700,
                    ),
                    FxText.bodySmall(
                      overflow: TextOverflow.ellipsis,
                      text,
                      color: Constant.softColors.green.onColor,
                      fontWeight: 600,
                      fontSize: 12,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,)
            ]
        )
    );
  }
}
