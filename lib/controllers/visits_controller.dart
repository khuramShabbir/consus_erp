import 'dart:async';
import 'dart:io';

import 'package:consus_erp/Services/ApiServices/api_services.dart';
import 'package:consus_erp/Services/ApiServices/api_urls.dart';
import 'package:consus_erp/controllers/visits_list_controller.dart';
import 'package:consus_erp/data/database_helper.dart';
import 'package:consus_erp/model/sale_person.dart';
import 'package:consus_erp/model/shops_model.dart';
import 'package:consus_erp/model/user.dart';
import 'package:consus_erp/model/visits_model.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx/core/state_management/state_management.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class VisitsController extends FxController {
  final formKey = GlobalKey<FormState>();
  SalePerson? salePerson;
  ShopsModel? shops;
  User user = new User();
  SalePerson salePersonData = new SalePerson();
  TextEditingController visitNo = TextEditingController();
  TextEditingController visitDate = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController systemNotes = TextEditingController();
  int selectedRecordId = 0;
  VisitsListController visitsListController = new VisitsListController();
  List<SalePerson> spList = [];
  List<ShopsModel> shopsList = [];
  List<VisitsDetail> lstVisitsDetail = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Info.errorSnackBar(
          'Location services are disabled. Please enable location services in order to save Shop.');
      await Future.delayed(Duration(seconds: 3));
      //await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Info.errorSnackBar('Location permission is denied. Allow the app to use your location.');
        await Future.delayed(Duration(seconds: 3));
        return false;
      }
      if (permission == LocationPermission.deniedForever) {
        Info.errorSnackBar(
            'Location permissions are permanently denied, go to settings and give this app permission manually to proceed with Shop.');
        return false;
      }
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    Info.startProgress();
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      longitude.text = position.longitude.toString();
      latitude.text = position.latitude.toString();
      Info.stopProgress();
    }).catchError((e) {
      Info.stopProgress();
      debugPrint(e);
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var data = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    print(data);
    return data;
  }

  Future<List<SalePerson>> getSalePersonSupervisorWise(int spId) async {
    List<SalePerson> lst = [];
    String response = await ApiServices.getMethodApi("${ApiUrls.IMPORT_SALE_PERSONS}?spid=$spId");
    if (response.isEmpty) {
      return lst;
    }

    var apiResponseFromJson = salePersonApiResponseFromJson(response);

    if (apiResponseFromJson.data != null) {
      lst.addAll(apiResponseFromJson.data!);
    }
    return lst;
  }

  Future<List<ShopsModel>> getShopsSalePersonWise(int spId) async {
    List<ShopsModel> lst = [];
    String response =
        await ApiServices.getMethodApi("${ApiUrls.IMPORT_SHOPS_SALE_PERSON_WISE}?spid=$spId");
    if (response.isEmpty) {
      return lst;
    }

    var apiResponseFromJson = shopsApiResponseFromJson(response);

    if (apiResponseFromJson.data != null) {
      lst.addAll(apiResponseFromJson.data!);
    }
    return lst;
  }

  Future getUserData() async {
    salePersonData = await DatabaseHelper.instance.getSalePersonByUserID(user.userID!);
  }

  Future getData(int spId) async {
    spList = await getSalePersonSupervisorWise(spId);
    shopsList = await getShopsSalePersonWise(spId);
    if (spList.isNotEmpty) {
      salePerson = spList[0];
    }
    if (shopsList.isNotEmpty) {
      shops = new ShopsModel();
    }
  }

  void salePersonOnChanged(SalePerson sp) {
    salePerson = sp;
    print('Sale person id on changed is : ${salePerson!.salePersonID}');
  }

  void shopsOnChanged(ShopsModel shop) {
    shops = shop;
    print('Shop id on changed is : ${shops!.shopID}');
  }

  Future saveVisits(List<VisitsDetail> lstVisitsDetail, int salePersonId, int shopId) async {
    try {
      //DateTime vDate = new DateFormat("yyyy-MM-dd").parse(visitDate.text);
      DateFormat inputFormat = DateFormat("dd-MM-yyyy");
      DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = inputFormat.parse(visitDate.text);
      String outputDateString = outputFormat.format(dateTime);

      //var vDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      var created = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      var updated = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      var body = VisitsModel(
              visitsDetail: lstVisitsDetail,
              visitId: selectedRecordId,
              shopId: shopId,
              visitNo: visitNo.text,
              ShopName: "",
              SalePersonName: "",
              visitDate: DateTime.parse(outputDateString),
              salePersonId: salePersonId,
              longitude: double.parse(longitude.text),
              latitude: double.parse(latitude.text),
              googleAddress: "",
              createdBy: salePersonId,
              createdOn: DateTime.parse(created),
              updatedBy: selectedRecordId == 0 ? 0 : salePersonId,
              updatedOn: DateTime.parse(updated),
              remarks: remarks.text,
              systemNotes: systemNotes.text,
              verify: false)
          .toJson();

      Info.startProgress();
      var response = await ApiServices.postSyncMethodApi(body, ApiUrls.SYNC_VISITS);
      Info.stopProgress();

      if (response.isNotEmpty && response.contains("Successfull")) {
        Info.successSnackBar('Visit saved successfully.');
        int count = 0;
        lstVisitsDetail.forEach((element) async {
          await uploadFileToFtp(element.imageUrl!);
          count++;
        });
        if (lstVisitsDetail.length == count) {
          Info.stopProgress();
        }
      } else {
        Info.errorSnackBar('Failed to save visit, try again.');
        Info.stopProgress();
      }
    } catch (e) {
      Info.stopProgress();
      print('Failed to insert/update shop because of $e');
    }
  }

  Future uploadFileToFtp(String path) async {
    FTPConnect ftpConnect =
        FTPConnect('wh962111.ispot.cc', user: 'consuserp@wh962111.ispot.cc', pass: 'Lahore5400');
    try {
      File fileUpload = File(path);
      await ftpConnect.connect();
      // Change to the desired directory
      ftpConnect.changeDirectory('Test');
      bool response = await ftpConnect.uploadFile(fileUpload);
      await ftpConnect.disconnect();
      print('File uploaded to ftp: $response');
      if (await fileUpload.exists()) {
        await fileUpload.delete();
        print('File has been deleted from local app directory.');
      }
    } catch (e) {
      Info.stopProgress();
      print(e);
    }
  }

  Future openRecord(int visitId) async {
    var response =
        await ApiServices.getMethodApi('${ApiUrls.GET_VISITS_BY_VISIT_ID}?visitID=$visitId');
    if (response.isNotEmpty) {
      var apiResponseFromJson = visitsApiResponseFromJson(response);
      if (apiResponseFromJson.data != null) {
        apiResponseFromJson.data.forEach((element) {
          visitNo.text = element.visitNo;
          visitDate.text = DateFormat('dd-MM-yyyy').format(element.visitDate).toString();
          salePerson = new SalePerson(
              salePersonID: element.salePersonId, salePersonName: element.SalePersonName);
          shops = new ShopsModel(shopID: element.shopId, shopName: element.ShopName);
          remarks.text = element.remarks;
          longitude.text = element.longitude.toString();
          latitude.text = element.latitude.toString();
          systemNotes.text = element.systemNotes.toString();
          lstVisitsDetail = element.visitsDetail;
          // if(element.visitsDetail.isNotEmpty){
          //   element.visitsDetail.forEach((detail) async {
          //     VisitsDetail visitDetails = new VisitsDetail();
          //     visitDetails.visitDetailId = detail.visitDetailId;
          //     visitDetails.visitId = detail.visitId;
          //     visitDetails.narration = detail.narration;
          //     var file = await retrieveFileFromFtp(detail.imageUrl!);
          //     visitDetails.imageUrl = file.path;
          //     lstVisitsDetail.add(visitDetails);
          //   });
          // }
        });
      }
    }
  }

  void newRecord() {
    visitNo.text = '';
    visitDate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    remarks.text = '';
    longitude.text = '';
    latitude.text = '';
    systemNotes.text = '';
    selectedRecordId = 0;
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

  Future deleteFileFromFtpDirectory(String fileName) async {
    FTPConnect ftpConnect =
        FTPConnect('wh962111.ispot.cc', user: 'consuserp@wh962111.ispot.cc', pass: 'Lahore5400');
    try {
      String file = "";
      List<String> elements = fileName.split('/');
      if (elements.length > 0) {
        file = elements.last;
      } else {
        file = fileName;
      }
      Info.startProgress();
      await ftpConnect.connect();
      ftpConnect.changeDirectory('Test');
      bool response = await ftpConnect.deleteFile(file);
      ftpConnect.disconnect();
      Info.stopProgress();
      print('File has been deleted from ftp directory : $response');
      print(fileName);
    } catch (e) {
      Info.stopProgress();
      print(e);
    }
  }

  Future deleteMultipleFilesFromFtpDirectory(List<VisitsDetail> lst) async {
    try {
      lst.forEach((element) async {
        await deleteFileFromFtpDirectory(element.imageUrl!);
      });
    } catch (e) {
      Info.stopProgress();
      print(e);
    }
  }

  Future<bool> deleteVisits(int visitId) async {
    bool result = false;
    try {
      String id = visitId.toString();
      Info.startProgress();
      String response = await ApiServices.deleteAlbum(id);
      Info.stopProgress();
      if (response.isNotEmpty) {
        if (response.contains("Successfull")) {
          print('Visit has been delete successfully.');
          result = true;
        }
      }
      if (result == true) {
        Info.successSnackBar('Visit has been deleted successfully.');
        // lstVisitsDetail.forEach((element) async{
        //   await deleteFileFromFtpDirectory(element.imageUrl!);
        // });
        Info.stopProgress();
      }
    } catch (e) {
      Info.stopProgress();
      print('Visit delete process failed due to $e');
    }
    return result;
  }

  @override
  String getTag() {
    return "visits_controller";
  }
}
