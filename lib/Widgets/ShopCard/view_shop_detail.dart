import 'package:consus_erp/Model/Shops/shop_model.dart';
import 'package:consus_erp/Widgets/extended_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewShopDetail extends StatelessWidget {
  final ShopData? shopData;

  const ViewShopDetail(this.shopData, {Key? key}) : super(key: key);
  final Color color = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          shopData?.shopName ?? "",
          style: TextStyle(color: color),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: ExtendedButton(
                text: 'Create Order',
                onTap: () {},
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ExtendedButton(
                text: 'Visit',
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Contact Person
            infoTile("Contact Person", shopData?.contactPerson),

            /// Contact Number
            infoTile("Contact Number", shopData?.contactNo),

            /// Sale PersonName
            infoTile("Sale PersonName", shopData?.salePersonName),

            /// Created on

            infoTile("Created on", shopData?.createdOn.toString()),



            /// Area
            infoTile("Area", shopData?.areaName),

            /// Address
            detailTile("Address", shopData?.googleAddress),

            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }

  Widget infoTile(String title, String? value) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: Text(
        value ?? "Not Available",
        style: TextStyle(
            color: value != null ? Colors.black : Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget detailTile(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 10, spreadRadius: 1, color: Colors.grey.withOpacity(.5))
            ]),
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: color),
              ),
              Text(
                value ?? "Not Available",
                style: TextStyle(
                    color: value != null ? Colors.black : Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
