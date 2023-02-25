import 'dart:io';

import 'package:consus_erp/controllers/visits_controller.dart';
import 'package:consus_erp/model/sale_person.dart';
import 'package:consus_erp/model/shops_model.dart';
import 'package:consus_erp/model/visits_model.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

class Visits extends StatefulWidget {
  const Visits({Key? key, required this.controller}) : super(key: key);

  final VisitsController controller;

  @override
  State<Visits> createState() => _VisitsState();
}

class _VisitsState extends State<Visits> {
  final testController = TextEditingController();
  List<VisitsDetail> lstVisitsDetail = [];
  late VisitsDetail visitDetails;
  var distance = 0.0;
  //late VisitsController controller;

  @override
  void initState() {
    // TODO: implement initState
    //controller.getUserData();
    visitDetails = new VisitsDetail();
    widget.controller.visitDate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    print('Visit Id id : ${widget.controller.selectedRecordId}');
    if (widget.controller.selectedRecordId == 0) {
      print('New Record');
    } else {
      setState(() {
        //widget.controller.openRecord(widget.recordId);
      });
      print('Open Record');
    }
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (widget.controller.selectedRecordId > 0) {
      await widget.controller.openRecord(widget.controller.selectedRecordId);
      //refreshListViewBuilder(widget.controller.lstVisitsDetail);
      setState(() {
        lstVisitsDetail = widget.controller.lstVisitsDetail;
      });
    }
  }

  Future<List<VisitsDetail>> refreshListViewBuilder(List<VisitsDetail> lst) async {
    List<VisitsDetail> data = [];
    if (lst.isNotEmpty) {
      lst.forEach((detail) async {
        VisitsDetail visitDetails = new VisitsDetail();
        FTPConnect ftpConnect = FTPConnect('wh962111.ispot.cc',
            user: 'consuserp@wh962111.ispot.cc', pass: 'Lahore5400');
        try {
          Info.startProgress();
          await ftpConnect.connect();
          // Change to the desired directory
          //ftpConnect.changeDirectory('ErpAppTest');
          String fileName = '../Test/${detail.imageUrl}';
          final directory = await getApplicationDocumentsDirectory();

          //here we just prepare a file as a path for the downloaded file
          var retrievedFile = File('${directory.path}/${detail.imageUrl}');
          bool response = await ftpConnect.downloadFile(fileName, retrievedFile);
          await ftpConnect.disconnect();
          Info.stopProgress();
          print('File downloaded from ftp: $response');
          visitDetails.visitDetailId = detail.visitDetailId;
          visitDetails.visitId = detail.visitId;
          visitDetails.narration = detail.narration;
          visitDetails.imageUrl = retrievedFile.path;
        } catch (e) {
          Info.stopProgress();
          print(e);
        }
        data.add(visitDetails);
        print('Length is updated list is ${data.length}');
        if (lst.length == data.length) {
          setState(() {
            lstVisitsDetail = data;
          });
        }
      });
    }
    return data;
  }

  Future<File> retrieveFileFromFtp(String img) async {
    File? retrievedFile;
    FTPConnect ftpConnect =
        FTPConnect('wh962111.ispot.cc', user: 'consuserp@wh962111.ispot.cc', pass: 'Lahore5400');
    try {
      await ftpConnect.connect();
      // Change to the desired directory
      //ftpConnect.changeDirectory('ErpAppTest');
      String fileName = '../Test/$img';
      final directory = await getApplicationDocumentsDirectory();

      //here we just prepare a file as a path for the downloaded file
      retrievedFile = File('${directory.path}/$img');
      bool response = await ftpConnect.downloadFile(fileName, retrievedFile);
      await ftpConnect.disconnect();
      print('File downloaded from ftp: $response');
    } catch (e) {
      print(e);
    }
    return retrievedFile!;
  }

  void getLocation() async {
    await widget.controller.getCurrentPosition();
  }

  void addItemToList() {
    if (testController.text.isNotEmpty) {
      setState(() {
        visitDetails = new VisitsDetail();
        visitDetails.imageUrl = 'Test Image';
        visitDetails.narration = testController.text;
        lstVisitsDetail.insert(0, visitDetails);
      });
    }
  }

  Future captureImage() async {
    try {
      // using your method of getting an image
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      // converting it to file object
      final captured = File(image.path);

      // getting a directory path for saving
      final directory = await getApplicationDocumentsDirectory();

      // getting basename of image
      final name = Path.basename(captured.path);

      // copy the file to a new path
      final savedImage = await captured.copy('${directory.path}/$name');

      if (widget.controller.longitude.text.isEmpty || widget.controller.latitude.text.isEmpty) {
        getLocation();
      }

      setState(() {
        visitDetails = new VisitsDetail();
        visitDetails.imageUrl = savedImage.path;
        visitDetails.narration = testController.text;
        lstVisitsDetail.insert(0, visitDetails);
        testController.text = "";
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future uploadFileToFtp(String path) async {
    FTPConnect ftpConnect = FTPConnect('104.219.233.99', user: 'consuserp', pass: 'Lahore5400');
    try {
      File fileUpload = File(path);
      await ftpConnect.connect();
      // Change to the desired directory
      ftpConnect.changeDirectory('ErpAppTest');
      bool response = await ftpConnect.uploadFile(fileUpload);
      await ftpConnect.disconnect();
      print('File uploaded to ftp: $response');
    } catch (e) {
      print(e);
    }
  }

  Future<bool> fileExists(String path) async {
    var res = await File(path).exists();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visits',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        //centerTitle: true,
      ),
      body: Form(
        key: widget.controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
          child: Center(
            child: Column(
              children: [
                buildVisitNo(),
                const SizedBox(
                  height: 30,
                ),
                buildDate(),
                const SizedBox(
                  height: 24,
                ),
                buildSalePerson(),
                const SizedBox(
                  height: 24,
                ),
                buildShop(),
                const SizedBox(
                  height: 24,
                ),
                buildVisitDetailRow(),
                const SizedBox(
                  height: 24,
                ),
                lstVisitsDetail.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: lstVisitsDetail.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: FutureBuilder(
                                    future: fileExists(lstVisitsDetail[index].imageUrl!),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.data!
                                            ? Image.file(
                                                File(lstVisitsDetail[index].imageUrl!),
                                                fit: BoxFit.cover,
                                                height: 100,
                                                width: 100,
                                              )
                                            : InkWell(
                                                child: Text('View Image'),
                                                onTap: () async {
                                                  await refreshListViewBuilder(lstVisitsDetail);
                                                },
                                              );
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(lstVisitsDetail[index].narration!),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(90, 0, 0, 0),
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    if (widget.controller.selectedRecordId > 0) {
                                      await widget.controller.deleteFileFromFtpDirectory(
                                          lstVisitsDetail[index].imageUrl!);
                                    }
                                    setState(() {
                                      lstVisitsDetail.removeAt(index);
                                    });
                                  },
                                ),
                              )),
                            ],
                          ));
                        })
                    : Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: ListTile(
                                title: Text('Add items to list.'),
                              ),
                            ),
                          )
                        ],
                      ),
                const SizedBox(
                  height: 24,
                ),
                buildRemarks(),
                const SizedBox(
                  height: 24,
                ),
                buildLongAndLat(),
                const SizedBox(
                  height: 30,
                ),
                buildSystemNotes(),
                const SizedBox(
                  height: 40,
                ),
                buildActions()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildVisitDetailRow() => Row(
        children: [
          Expanded(
            flex: 1,
            child: CircleAvatar(
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  captureImage();
                },
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: TextField(
              controller: testController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Description'),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: CircleAvatar(
          //     child: IconButton(
          //       icon: Icon(Icons.save),
          //       onPressed: (){
          //         countries.forEach((element) {
          //           uploadFileToFtp(element.imageUrl!);
          //         });
          //       },
          //     ),
          //   ),
          // )
        ],
      );

  Widget buildVisitNo() => TextField(
        controller: widget.controller.visitNo,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Visit No',
          // icon: Icon(Icons.person),
          // prefixIcon: Icon(Icons.person),
          //suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.close)),
        ),
        readOnly: true,
        enabled: false,
      );

  Widget buildRemarks() => TextField(
        controller: widget.controller.remarks,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Remarks',
        ),
      );

  Widget buildLongAndLat() => Row(
        children: [
          Expanded(
              flex: 18,
              child: TextFormField(
                controller: widget.controller.longitude,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Longitude',
                  // icon: Icon(Icons.contact_phone),
                  // prefixIcon: Icon(Icons.contact_phone),
                  //suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.close)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Turn on location';
                  }
                  return null;
                },
                readOnly: true,
                enabled: false,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              )),
          Expanded(
            flex: 1,
            child: Text(''),
          ),
          Expanded(
              flex: 18,
              child: TextFormField(
                controller: widget.controller.latitude,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Latitude',
                  // icon: Icon(Icons.code),
                  // prefixIcon: Icon(Icons.code),
                  //suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.close)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
                readOnly: true,
                enabled: false,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              )),
        ],
      );

  Widget buildSystemNotes() => TextField(
        controller: widget.controller.systemNotes,
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

  Widget buildDate() => TextFormField(
        controller: widget.controller.visitDate,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Date',
          prefixIcon: Icon(Icons.calendar_today_sharp),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter visit date';
          }
          return null;
        },
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2050));
          if (pickedDate != null) {
            setState(() {
              widget.controller.visitDate.text =
                  DateFormat('dd-MM-yyyy').format(pickedDate).toString();
            });
          }
        },
      );

  Widget buildShop() => DropdownSearch<ShopsModel>(
        items: widget.controller.shopsList,
        itemAsString: (ShopsModel shop) => shop.shopName != null ? shop.shopName! : "",
        onChanged: (ShopsModel? data) {
          widget.controller.shopsOnChanged(data!);
          getLocation();
          distance = widget.controller.calculateDistance(
              widget.controller.latitude.text.isEmpty
                  ? 0
                  : double.parse(widget.controller.latitude.text),
              widget.controller.longitude.text.isEmpty
                  ? 0
                  : double.parse(widget.controller.longitude.text),
              data.latitiude!,
              data.longitiude!);
        },
        validator: (value) {
          if (value == null) {
            return 'Please select shop';
          }
          // else if(value!.shopID != null && (distance < 0 || distance > 200)){
          // var d = distance/1000;
          // return "${d.round()} km away from shop, you can't proceed with your order";
          // }
          print("Distance between shop and visit place is : $distance");
          return null;
        },
        popupProps: PopupProps.menu(
          showSearchBox: true,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration:
              InputDecoration(labelText: "Shops", border: OutlineInputBorder()),
        ),
        selectedItem: widget.controller.shops,
      );

  Widget buildSalePerson() => DropdownSearch<SalePerson>(
        items: widget.controller.spList,
        itemAsString: (SalePerson sp) => sp.salePersonName != null ? sp.salePersonName! : "",
        onChanged: (SalePerson? data) {
          widget.controller.salePersonOnChanged(data!);
        },
        autoValidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null) {
            return 'Please select sale person';
          }
          return null;
        },
        popupProps: PopupProps.menu(
          showSearchBox: true,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration:
              InputDecoration(labelText: "Sale Person", border: OutlineInputBorder()),
        ),
        selectedItem: widget.controller.salePerson,
      );

  Widget buildActions() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
            child: ElevatedButton(
              onPressed: () async {
                Info.startProgress();
                await widget.controller.getData(widget.controller.user.salePersonID!);
                Info.stopProgress();
                setState(() {
                  widget.controller.newRecord();
                  lstVisitsDetail = [];
                });
              },
              child: Text('New'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
            child: ElevatedButton(
              onPressed: () async {
                if (lstVisitsDetail.length > 0) {
                  if (widget.controller.formKey.currentState!.validate()) {
                    //widget.controller.selectedRecordId = widget.recordId;
                    await widget.controller.saveVisits(
                        lstVisitsDetail,
                        widget.controller.salePerson!.salePersonID!,
                        widget.controller.shops!.shopID!);
                    Navigator.pop(context);
                  }
                } else {
                  Info.errorSnackBar('Please add minimum 1 picture.');
                }
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Save & New'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
              ),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () async {
                if (widget.controller.selectedRecordId > 0) {
                  widget.controller.lstVisitsDetail = lstVisitsDetail;
                  var result =
                      await widget.controller.deleteVisits(widget.controller.selectedRecordId);
                  print('Pop result is : $result');
                  if (result == true) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
              ),
            ),
          )
        ],
      );
}

void getSelectedItem(String? s) {
  print('$s');
}
