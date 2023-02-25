import 'dart:async';

import 'package:consus_erp/controllers/sync_controller.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';

import '../controllers/import_data_controller.dart';

class SyncData extends StatefulWidget {
  const SyncData({Key? key}) : super(key: key);

  @override
  State<SyncData> createState() => _SyncDataState();
}

class _SyncDataState extends State<SyncData> {
  dataSynchronization syncController = new dataSynchronization();
  ImportDataFromJson importDataController = new ImportDataFromJson();
  bool shopChecked = true, itemChecked = true, branchChecked = true, regionChecked = true,
  areaChecked = true, spChecked = true, tcChecked = true, spDetailChecked = true;

  @override
  void initState() {
    // TODO: implement initState
    //IsInternetAvailable();
    super.initState();
    setState(() {
      importDataController.isSyncShop = shopChecked;
      importDataController.isSyncItem = itemChecked;
      importDataController.isSyncBranch = branchChecked;
      importDataController.isSyncRegion = regionChecked;
      importDataController.isSyncArea = areaChecked;
      importDataController.isSyncSp = spChecked;
      importDataController.isSyncTc = tcChecked;
      importDataController.isSyncSpDetail = spDetailChecked;
    });
  }

  Future IsInternetAvailable() async{
    await syncController.isInternet().then((connection){
      if(connection){
        print('Connected to internet');
        importDataController.syncData();
      }
      else{
        print('Disconnected from internet');
        Info.errorSnackBar('No internet available, please connect to internet to sync data.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sync Data',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Sync Shops'),
              value: shopChecked,
              onChanged: (bool? value){
                setState(() {
                  shopChecked = value!;
                  importDataController.isSyncShop = shopChecked;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              secondary: Icon(FeatherIcons.shoppingBag)
            ),
            CheckboxListTile(
                title: const Text('Sync Items'),
                value: itemChecked,
                onChanged: (bool? value){
                  setState(() {
                    itemChecked = value!;
                    importDataController.isSyncItem = itemChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),
            CheckboxListTile(
                title: const Text('Sync Branches'),
                value: branchChecked,
                onChanged: (bool? value){
                  setState(() {
                    branchChecked = value!;
                    importDataController.isSyncBranch = branchChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),
            CheckboxListTile(
                title: const Text('Sync Sale Persons'),
                value: spChecked,
                onChanged: (bool? value){
                  setState(() {
                    spChecked = value!;
                    importDataController.isSyncSp = spChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),
            CheckboxListTile(
                title: const Text('Sync Sale Person Detail'),
                value: spDetailChecked,
                onChanged: (bool? value){
                  setState(() {
                    spDetailChecked = value!;
                    importDataController.isSyncSpDetail = spDetailChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),
            CheckboxListTile(
                title: const Text('Sync Areas'),
                value: areaChecked,
                onChanged: (bool? value){
                  setState(() {
                    areaChecked = value!;
                    importDataController.isSyncArea = areaChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),
            CheckboxListTile(
                title: const Text('Sync Regions'),
                value: regionChecked,
                onChanged: (bool? value){
                  setState(() {
                    regionChecked = value!;
                    importDataController.isSyncRegion = regionChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),
            CheckboxListTile(
                title: const Text('Sync Trade Channels'),
                value: tcChecked,
                onChanged: (bool? value){
                  setState(() {
                    tcChecked = value!;
                    importDataController.isSyncTc = tcChecked;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(FeatherIcons.shoppingBag)
            ),
            FxSpacing.height(70),
            ElevatedButton(onPressed: (){
              IsInternetAvailable();
              setState(() {
                importDataController.lastSyncDate();
              });
            },
            child: const Text('Sync Data')
            )
          ],
        ),
      ),
    );
  }
}
