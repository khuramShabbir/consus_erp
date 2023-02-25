import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

import 'orders_screen.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final fromDate = TextEditingController();
  final toDate = TextEditingController();
  final searchItemsController = TextEditingController();
  final sampleItems = List<String>.generate(10, (index) => 'Salman Ali $index');
  final items = <String>[];
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    items.addAll(sampleItems);
    super.initState();
  }

  void fillSearchedItems(String query){
    List<String> duplicateItems = <String>[];
    duplicateItems.addAll(sampleItems);
    if(query.isNotEmpty){
      List<String> searchedItems = <String>[];
      duplicateItems.forEach((search) {
        if(search.contains(query)){
          searchedItems.add(search);
        }
      });
      setState(() {
        items.clear();
        items.addAll(searchedItems);
      });
    }
    else{
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
                flex: 5,
                child: Text('Orders List', style: TextStyle(
                  color: Colors.black,
                ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Orders()));
                  },
                  icon: Icon(Icons.add),
                  label: Text('Order'),
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
                    child:
                    buildFromDate(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  Expanded(
                    flex: 18,
                    child:
                    buildToDate(),
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
                    child:
                    buildSalePerson(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  Expanded(
                    flex: 18,
                    child:
                    buildRegion(),
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
                    child:Text(''),
                  ),
                  Expanded(
                    flex: 1,
                    child:Text(''),
                  ),
                  Expanded(
                    flex: 18,
                    child:buildSearchBox(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.length > 0 ?
              ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index){
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
                                mainAxisAlignment:MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Shop Code: ${items[index]}'),
                                  Text('Shop Name: ${items[index]}'),
                                  Text('Sale Person: ${items[index]}'),
                                  Text('Area Name: ${items[index]}'),
                                  Text('VPO: ${items[index]}'),
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
                                  mainAxisAlignment:MainAxisAlignment.start ,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Contact Person: ${items[index]}'),
                                    Text('Trade Channel: ${items[index]}'),
                                    Text('Contact No: ${items[index]}'),
                                    Text('Date: ${items[index]}'),
                                    Text('SEO: ${items[index]}'),
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                  onPressed:(){
                                    setState(() {
                                      selectedIndex = index;
                                      print(selectedIndex);
                                    });
                                  },
                                  icon: Icon(Icons.edit))
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  :
              Center(child: Text('No Items Found...'),),
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

  Widget buildRegion() => DropdownSearch<String>(
    popupProps: PopupProps.menu(
      showSearchBox: true,
      showSelectedItems: true,
      disabledItemFn: (String s) => s.startsWith('I'),
    ),
    items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
    dropdownDecoratorProps: DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        labelText: "Region",
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
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
      );
      if(pickedDate != null){
        setState(() {
          fromDate.text = DateFormat.yMd().format(pickedDate).toString();
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
    onTap: () async{
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2050),
      );
      if(pickedDate != null){
        setState(() {
          toDate.text = DateFormat.yMd().format(pickedDate).toString();
        });
      }
    },
  );

  Widget buildSearchBox() => TextField(
    controller: searchItemsController,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Search Orders',
      prefixIcon: Icon(Icons.search_sharp),
      hintText: 'Search Orders Here...',
    ),
    onChanged: (value){
      fillSearchedItems(value);
    },
  );
}
