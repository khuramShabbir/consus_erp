import 'package:consus_erp/Model/Shops/shop_model.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view_shop_detail.dart';

class ShopCard extends StatelessWidget {
  final ShopData? shopData;
  const ShopCard(this.shopData, {Key? key}) : super(key: key);

  final Color color = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CupertinoColors.black, width: 1.5)),
      child: Column(
        children: [
          /// sale   Person
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    LoginProvider.getUser().fullName ?? "",
                    style:
                        TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ViewShopDetail(shopData));
                    },
                    child: Text(
                      "View Detail",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Shop name
                shopTile("Shop name", shopData?.shopName),

                /// Contact Person
                shopTile("Contact Person", shopData?.contactPerson),

                /// Contact Number
                shopTile("Contact Number", shopData?.contactNo),

                /// Sale PersonName
                shopTile("Sale PersonName", shopData?.salePersonName),

                /// Created on

                shopTile("Created on", shopData?.createdOn.toString()),

                /// Route

                shopTile("Route", shopData?.route.toString()),

                /// Area
                shopTile("Area", shopData?.areaName),

                /// Address
                shopTile("Address", shopData?.googleAddress),

                /// Address
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget shopTile(String title, String? value) {
    if (value != null)
      return Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      );
    return SizedBox.shrink();
  }
}
