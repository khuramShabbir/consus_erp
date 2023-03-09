// import 'package:consus_erp/Providers/ShopsProvider/add_new_shop_provider.dart';
// import 'package:consus_erp/Widgets/ShopCard/shop_card.dart';
// import 'package:consus_erp/utils/info_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
//
// class ViewSavedShops extends StatefulWidget {
//   const ViewSavedShops({Key? key}) : super(key: key);
//
//   @override
//   State<ViewSavedShops> createState() => _ViewSavedShopsState();
// }
//
// class _ViewSavedShopsState extends State<ViewSavedShops> {
//   final AddNewShopProvider addNewShopProvider = Provider.of<AddNewShopProvider>(Get.context!, listen: false);
//
//   @override
//   void initState() {
//     addNewShopProvider.getSavedShops();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Saved Shop',
//           style: TextStyle(color: Colors.black, fontSize: 14),
//         ),
//         actions: [
//           Consumer<AddNewShopProvider>(
//             builder: (BuildContext context, value, Widget? child) {
//               return !value.loading
//                   ? Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: actionButton(
//                           onTap: () async {
//                             bool result = await value.submitSavedShop();
//                           },
//                           text: ' Submit ',
//                           buttonColor: Colors.green),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                       child: SizedBox(
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 1.5,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ),
//                     );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(child: Consumer<AddNewShopProvider>(
//             builder: (BuildContext context, value, Widget? child) {
//               return (addNewShopProvider.shopDataList != null && addNewShopProvider.shopDataList!.isNotEmpty)
//                   ? ListView.builder(
//                       itemCount: value.shopDataList?.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           child: ShopCard(
//                             value.shopDataList?[index],
//                             index: index+1,
//                           ),
//                         );
//                       },
//                     )
//                   : Center(
//                       child: Text(
//                         "No Data Found",
//                         style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
//                       ),
//                     );
//             },
//           ))
//         ],
//       ),
//     );
//   }
//
//   Widget actionButton({required VoidCallback onTap, required String text, required Color? buttonColor, Icon? icon}) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
//       child: ElevatedButton(
//         onPressed: onTap,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (icon != null) icon,
//             if (icon != null) SizedBox(width: 5),
//             Text(text),
//           ],
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: buttonColor,
//         ),
//       ),
//     );
//   }
// }
