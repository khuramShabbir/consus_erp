import 'package:consus_erp/Model/Orders/get_orders.dart';
import 'package:consus_erp/extensions/date_time_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersCard extends StatelessWidget {

  final int? index;
  final OrdersModel? ordersModel;

  const OrdersCard({this.ordersModel, this.index, Key? key}) : super(key: key);

  final Color color = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all(color: CupertinoColors.black, width: 1.5)),
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
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("${index}",style: TextStyle(color: Colors.brown),),
                  ),
                  Icon(Icons.shopping_bag_outlined),
                  SizedBox(width: 10),
                  Text(
                    ordersModel?.shopName ?? "",
                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: SizedBox()),
                  ordersModel?.isSync == true
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : Icon(Icons.info, color: Colors.redAccent)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Order Date
                shopTile("Order Date", "${ordersModel?.orderDate?.day}, "
                    "${ordersModel?.orderDate?.monthName}, "
                    "${ordersModel?.orderDate?.year}"),

                /// Shop Name
                shopTile("Shop Name", ordersModel?.shopName),

                /// Sale Person
                shopTile("Sale Person", ordersModel?.salePersonName),

                /// Region Name
                shopTile("Region Name", ordersModel?.regionName),

                /// Quantity
                shopTile("Quantity", ordersModel?.qty.toString()),

                /// Remarks
                shopTile("Remarks", ordersModel?.remarks),
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.all(10),
          //   child: Align(
          //     alignment: Alignment.bottomRight,
          //     child: GestureDetector(
          //       onTap: () {
          //
          //       },
          //       child: Text(
          //         "View Detail",
          //         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          // )
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
