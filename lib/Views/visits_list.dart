import 'dart:async';

import 'package:consus_erp/controllers/visits_controller.dart';
import 'package:consus_erp/controllers/visits_list_controller.dart';
import 'package:consus_erp/model/region.dart';
import 'package:consus_erp/model/sale_person.dart';
import 'package:consus_erp/model/shops_model.dart';
import 'package:consus_erp/model/visits_model.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:consus_erp/views/visits_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutx/core/state_management/state_management.dart';
import 'package:intl/intl.dart';

class VisitsList extends StatefulWidget {
  const VisitsList({Key? key}) : super(key: key);

  @override
  State<VisitsList> createState() => _VisitsListState();
}

class _VisitsListState extends State<VisitsList> {
  late Future<List<ShopsModel>> _shopsModel;
  late Future<List<AppVisitsList>> _futureVisitsList;
  ShopsModel? _shops;
  String searchString = "", from = "", to = "";
  int visitId = 0;
  final fromDate = TextEditingController();
  final toDate = TextEditingController();
  final searchItemsController = TextEditingController();
  final sampleItems = List<String>.generate(10, (index) => 'Salman Ali $index');
  final items = <String>[];
  int selectedIndex = 0;
  late VisitsController controller;
  late VisitsListController visitsListController;
  List<ShopsModel> lstShops = [];
  List<AppVisitsList> visitsData = [];
  List<AppVisitsList> unfilteredVisits = [];

  @override
  void initState() {
    // TODO: implement initState
    controller = FxControllerStore.putOrFind(VisitsController());
    visitsListController = FxControllerStore.putOrFind(VisitsListController());
    // controller.getUserData();
    visitsListController.fromDate.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now().add(const Duration(days: -30))).toString();
    visitsListController.toDate.text = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    from =
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: -30))).toString();
    to = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    items.addAll(sampleItems);
    _shopsModel = fillDropDowns();
    _futureVisitsList = getVisitsList();
    super.initState();
  }

  void navigateToList() {
    Route route = MaterialPageRoute(builder: (context) => Visits(controller: controller));
    Navigator.push(context, route).then((onGoBack));
  }

  void refreshShopsList() async {
    _futureVisitsList = getVisitsList();
  }

  FutureOr onGoBack(dynamic value) {
    refreshShopsList();
    setState(() {});
  }

  Future<List<AppVisitsList>> getVisitsList() async {
    List<AppVisitsList> data = [];
    try {
      await visitsListController.getUserData();
      var From = visitsListController.formatDate(visitsListController.fromDate.text);
      var To = visitsListController.formatDate(visitsListController.toDate.text);
      //Info.startProgress();
      data = await visitsListController.getVisitsSalePersonSupervisorWise(
          visitsListController.user.regionID!,
          visitsListController.user.salePersonID!,
          (_shops != null) ? _shops!.shopID! : 0,
          From,
          To);
      //Info.stopProgress();
      setState(() {
        visitsData = data;
        unfilteredVisits = visitsData;
      });
    } catch (e) {
      Info.stopProgress();
    }
    return data;
  }

  void filterVisitsList(String query) {
    if (query.isNotEmpty) {
      List<AppVisitsList> filteredList = [];
      unfilteredVisits.forEach((element) {
        if (element.visitNo!.contains(query) ||
            element.salePersonName!.toLowerCase().contains(query) ||
            element.shopName!.toLowerCase().contains(query) ||
            element.regionName!.toLowerCase().contains(query) ||
            element.remarks!.toLowerCase().contains(query)) {
          filteredList.add(element);
        }
      });
      setState(() {
        this.visitsData = filteredList;
      });
    } else {
      setState(() {
        this.visitsData = this.unfilteredVisits;
      });
    }
  }

  Future<List<ShopsModel>> fillDropDowns() async {
    List<ShopsModel> shop = [];
    try {
      await visitsListController.getUserData();
      print('${visitsListController.user.userID}');
      Info.startProgress();
      shop = await visitsListController.getShopsSalePersonRouteWise(
          visitsListController.user.salePersonID!, 0);
      Info.stopProgress();
      if (shop.isNotEmpty) {
        ShopsModel row = new ShopsModel();
        row.shopID = 0;
        row.shopName = "ALL";
        lstShops.add(row);
        lstShops.addAll(shop);
        shopOnChanged(row);
      }
    } catch (e) {
      Info.stopProgress();
    }
    return shop;
  }

  void shopOnChanged(ShopsModel shop) {
    setState(() {
      _shops = shop;
      print('Shop id on changed is : ${_shops!.shopID}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Visits List',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                Info.startProgress();
                await controller.getData(controller.user.salePersonID!);
                controller.newRecord();
                Info.stopProgress();
                navigateToList();
              },
              icon: Icon(Icons.add),
              label: Text('Visit'),
            ),
          ),
        ],
      )
          //centerTitle: true,
          //backgroundColor: Colors.deepOrange,
          ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 18,
                    child: buildFromDate(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  Expanded(
                    flex: 18,
                    child: buildToDate(),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: visitsListController.isAdmin,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 18,
                      child: buildRegion(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                    Expanded(
                      flex: 18,
                      child: buildSalePerson(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 18,
                    child: buildShop(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  Expanded(
                    flex: 18,
                    child: buildSearchBox(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<AppVisitsList>>(
                future: _futureVisitsList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('Loading visits please wait...'),
                    );
                  }
                  return visitsData.isEmpty
                      ? Center(
                          child: Text('No visits found...'),
                        )
                      : ListView.builder(
                          itemCount: visitsData.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool isEmpty = false;
                            return Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Card(
                                shadowColor: Colors.black,
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                'Visit No: ${visitsData[index].visitNo == null ? "--" : visitsData[index].visitNo}'),
                                            Text(
                                                'Visit Date: ${visitsData[index].visitDate == null ? DateFormat('dd-MM-yyyy').format(DateTime.now()) : visitsData[index].visitDate}'),
                                            Text(
                                                'Sale Person: ${visitsData[index].salePersonName == null ? 0 : visitsData[index].salePersonName}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  'Shop Name: ${visitsData[index].shopName == null ? "" : visitsData[index].shopName}'),
                                              Text(
                                                  'Region Name: ${visitsData[index].regionName == null ? "" : visitsData[index].regionName}'),
                                              Text(
                                                  'Remarks: ${visitsData[index].remarks == null ? "" : visitsData[index].remarks}'),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            onPressed: () async {
                                              Info.startProgress();
                                              await controller
                                                  .getData(controller.user.salePersonID!);
                                              controller.selectedRecordId =
                                                  visitsData[index].visitID!;
                                              Info.stopProgress();
                                              navigateToList();
                                            },
                                            icon: Icon(Icons.edit))),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSalePerson() => DropdownSearch<SalePerson>(
        items: controller.spList,
        itemAsString: (SalePerson sp) => sp.salePersonName!,
        onChanged: (SalePerson? data) {
          setState(() {
            visitsListController.salePersonOnChanged(data!);
          });
        },
        autoValidateMode: AutovalidateMode.onUserInteraction,
        popupProps: PopupProps.menu(
          showSearchBox: true,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration:
              InputDecoration(labelText: "Sale Person", border: OutlineInputBorder()),
        ),
        selectedItem: visitsListController.salePerson,
      );

  Widget buildRegion() => DropdownSearch<Region>(
        items: visitsListController.regionList,
        itemAsString: (Region r) => r.regionName!,
        onChanged: (Region? data) async {
          setState(() {
            visitsListController.regionOnChanged(data!);
          });
        },
        autoValidateMode: AutovalidateMode.onUserInteraction,
        popupProps: PopupProps.menu(
          showSearchBox: true,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration:
              InputDecoration(labelText: "Region", border: OutlineInputBorder()),
        ),
        selectedItem: visitsListController.region,
      );

  // Widget buildShop() => DropdownSearch<ShopsModel>(
  //   items: visitsListController.shopsList,
  //   itemAsString: (ShopsModel a) => a.shopName!,
  //   onChanged: (ShopsModel? data) {
  //     setState(() {
  //       visitsListController.shopsOnChanged(data!);
  //     });
  //   },
  //   autoValidateMode: AutovalidateMode.onUserInteraction,
  //   popupProps: PopupProps.menu(
  //     showSearchBox: true,
  //   ),
  //   dropdownDecoratorProps: DropDownDecoratorProps(
  //     dropdownSearchDecoration: InputDecoration(
  //         labelText: "Shops",
  //         border: OutlineInputBorder()
  //     ),
  //   ),
  //   selectedItem: _shops,
  // );

  Widget buildShop() => FutureBuilder<List<ShopsModel>>(
      future: _shopsModel,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownSearch<ShopsModel>(
            items: lstShops,
            itemAsString: (ShopsModel a) => a.shopName!,
            onChanged: (ShopsModel? data) {
              setState(() {
                visitsListController.shopsOnChanged(data!);
                shopOnChanged(data);
                _futureVisitsList = getVisitsList();
              });
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            popupProps: PopupProps.menu(
              showSearchBox: true,
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration:
                  InputDecoration(labelText: "Shops", border: OutlineInputBorder()),
            ),
            selectedItem: _shops,
          );
        }
        return DropdownSearch<ShopsModel>(
          items: visitsListController.shopsList,
          itemAsString: (ShopsModel a) => a.shopName!,
          onChanged: (ShopsModel? data) {
            setState(() {
              visitsListController.shopsOnChanged(data!);
              _futureVisitsList = getVisitsList();
            });
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          popupProps: PopupProps.menu(
            showSearchBox: true,
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration:
                InputDecoration(labelText: "Shops", border: OutlineInputBorder()),
          ),
          selectedItem: visitsListController.shops,
        );
      });

  Widget buildFromDate() => TextField(
        controller: visitsListController.fromDate,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'From Date',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2050),
          );
          if (pickedDate != null) {
            setState(() {
              visitsListController.fromDate.text =
                  DateFormat('dd-MM-yyyy').format(pickedDate).toString();
              _futureVisitsList = getVisitsList();
            });
          }
        },
      );

  Widget buildToDate() => TextField(
        controller: visitsListController.toDate,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'To Date',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2050),
          );
          if (pickedDate != null) {
            setState(() {
              visitsListController.toDate.text =
                  DateFormat('dd-MM-yyyy').format(pickedDate).toString();
              _futureVisitsList = getVisitsList();
            });
          }
        },
      );

  Widget buildSearchBox() => TextField(
        controller: searchItemsController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search Visits',
          prefixIcon: Icon(Icons.search_sharp),
          hintText: 'Search Visits Here...',
        ),
        onChanged: (value) {
          setState(() {
            searchString = value.toLowerCase();
            filterVisitsList(searchString);
          });
        },
      );
}
