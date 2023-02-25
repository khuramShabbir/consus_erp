import 'package:consus_erp/Views/add_new_shops_screen.dart';
import 'package:consus_erp/data/database_helper.dart';
import 'package:consus_erp/model/sale_person.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImportData extends StatefulWidget {
  const ImportData({Key? key}) : super(key: key);

  @override
  State<ImportData> createState() => _ImportDataState();
}

class _ImportDataState extends State<ImportData> {
  final fromDate = TextEditingController();
  final toDate = TextEditingController();
  final searchItemsController = TextEditingController();
  final sampleItems = List<String>.generate(10, (index) => 'Salman Ali $index');
  final items = <String>[];
  int selectedIndex = 0;

  @override
  void initState() {
    items.addAll(sampleItems);
    super.initState();
  }

  void filterSearchedShops(String search) {
    List<String> shopsList = <String>[];
    shopsList.addAll(sampleItems);
    if (search.isNotEmpty) {
      List<String> searchedShops = <String>[];
      shopsList.forEach((searchedItem) {
        if (searchedItem.contains(search)) {
          searchedShops.add(searchedItem);
        }
        setState(() {
          items.clear();
          items.addAll(searchedShops);
        });
      });
    } else {
      setState(() {
        items.clear();
        items.addAll(sampleItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Shops List',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewShops()));
              },
              icon: Icon(Icons.add),
              label: Text('New Shop'),
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 18,
                    child: buildSalePerson(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  Expanded(
                    flex: 18,
                    child: buildShop(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 18,
                    child: buildSalePerson(),
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
              child: FutureBuilder<List<SalePerson>>(
                future: DatabaseHelper.instance.getSalePerson(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('Loading shops please wait...'),
                    );
                  }

                  return snapshot.data!.isEmpty
                      ? Center(
                          child: Text('No shops found...'),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
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
                                                'Shop Code: ${snapshot.data![index].salePersonName!}'),
                                            Text(
                                                'Shop Name: ${snapshot.data![index].salePersonName}'),
                                            Text(
                                                'Sale Person: ${snapshot.data![index].salePersonName}'),
                                            Text(
                                                'Area Name: ${snapshot.data![index].salePersonName}'),
                                            Text('VPO: ${snapshot.data![index].salePersonName!}'),
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
                                                  'Contact Person: ${snapshot.data![index].salePersonName!}'),
                                              Text(
                                                  'Trade Channel: ${snapshot.data![index].salePersonName!}'),
                                              Text(
                                                  'Contact No: ${snapshot.data![index].salePersonName!}'),
                                              Text(
                                                  'Date: ${snapshot.data![index].salePersonName!}'),
                                              Text('SEO: ${snapshot.data![index].salePersonName!}'),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedIndex = index;
                                                print(selectedIndex);
                                              });
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

  Widget buildSalePerson() => DropdownSearch<String>(
        popupProps: PopupProps.menu(
          showSearchBox: true,
          showSelectedItems: true,
          disabledItemFn: (String s) => s.startsWith('I'),
        ),
        items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Sale Person",
            hintText: "country in menu mode",
          ),
        ),
        onChanged: print,
        selectedItem: "Brazil",
      );

  Widget buildShop() => DropdownSearch<String>(
        popupProps: PopupProps.menu(
          showSearchBox: true,
          showSelectedItems: true,
          disabledItemFn: (String s) => s.startsWith('I'),
        ),
        items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Shop",
            hintText: "country in menu mode",
          ),
        ),
        onChanged: print,
        selectedItem: "Brazil",
      );

  Widget buildFromDate() => TextField(
        controller: fromDate,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'From Date',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedFromDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2050),
          );
          if (pickedFromDate != null) {
            setState(() {
              fromDate.text = DateFormat.yMd().format(pickedFromDate).toString();
            });
          }
        },
      );

  Widget buildToDate() => TextField(
      controller: toDate,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'To Date',
        prefixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedToDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2050),
        );
        if (pickedToDate != null) {
          setState(() {
            toDate.text = DateFormat.yMd().format(pickedToDate).toString();
          });
        }
      });

  Widget buildSearchBox() => TextField(
        controller: searchItemsController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search Shops',
          prefixIcon: Icon(Icons.search_sharp),
          hintText: 'Search Shops Here...',
        ),
        onChanged: (value) {
          filterSearchedShops(value);
        },
      );
}
