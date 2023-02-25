import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Widget'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Shop Info'
                ),
              ),
              Tab(
                child: Text(
                    'Items'
                ),
              ),
              Tab(
                child: Text(
                    'Remarks'
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: ListView(
                padding: EdgeInsets.all(30),
                children: [
                  buildSalePerson(),
                  const SizedBox(height: 30,),
                  buildShop(),
                  const SizedBox(height: 40,),
                  buildNextActionBtn(),
                ],
              ),
            ),
            Center(
              child: ListView(
                padding: EdgeInsets.all(30),
                children: [
                  Text('Items content goes here...'),
                  const SizedBox(height: 40,),
                  buildActions(),
                ],
              ),
            ),
            Center(
              child: ListView(
                padding: EdgeInsets.all(30),
                children: [
                  buildRemarks(),
                  const SizedBox(height: 24,),
                  buildLatitude(),
                  const SizedBox(height: 24,),
                  buildLongitude(),
                  const SizedBox(height: 24,),
                  buildGeoLocation(),
                  const SizedBox(height: 30,),
                  buildSystemNotes(),
                  const SizedBox(height: 40,),
                  buildRemarksActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget buildRemarks() => TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Remarks',
    ),
  );

  Widget buildLatitude() => TextField(
    //controller: SPNameController,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Latitude',
      // icon: Icon(Icons.code),
      // prefixIcon: Icon(Icons.code),
      //suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.close)),
    ),
    readOnly: true,
    enabled: false,
  );

  Widget buildLongitude() => TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Longitude',
      // icon: Icon(Icons.contact_phone),
      // prefixIcon: Icon(Icons.contact_phone),
      //suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.close)),
    ),
    readOnly: true,
    enabled: false,
  );

  Widget buildSystemNotes() => TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'System Notes',
      // icon: Icon(Icons.add),
      // prefixIcon: Icon(Icons.add),
      //suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.close)),
    ),
    keyboardType: TextInputType.multiline,
    maxLines: 3,
    readOnly: true,
    enabled: false,
  );

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

  Widget buildGeoLocation() => TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'GEO Location',
    ),
    keyboardType: TextInputType.multiline,
    maxLines: 3,
    readOnly: true,
    enabled: false,
  );

  Widget buildNextActionBtn() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(onPressed: (){}, child: Text('Next'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[400],
        ),
      ),
    ],
  );

  Widget buildActions() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
        child: ElevatedButton(onPressed: (){}, child: Text('Back'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[400],
          ),),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
        child: ElevatedButton(
          onPressed: (){},
          child: Text('Next'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[400],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
        child: ElevatedButton(
          onPressed: (){},
          child: Text('Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[400],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
        child: ElevatedButton(
          onPressed: (){},
          child: Text('Save & New'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[400],
          ),
        ),
      ),
      ElevatedButton(
        onPressed: (){},
        child: Text('Delete'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
        ),
      ),
    ],
  );

  Widget buildRemarksActions() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
        child: ElevatedButton(onPressed: (){}, child: Text('Back'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[400],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
        child: ElevatedButton(
          onPressed: (){},
          child: Text('Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[400],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
        child: ElevatedButton(
          onPressed: (){},
          child: Text('Save & New'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[400],
          ),
        ),
      ),
      ElevatedButton(
        onPressed: (){},
        child: Text('Delete'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
        ),
      ),
    ],
  );
}

void getSelectedItem(String? s){
  print('$s');
}