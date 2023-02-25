import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class dataSynchronization{
  bool result = true;
  Future<bool> isInternet() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('Mobile Data Connection is available.');
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('Connected to internet');
        }
      } on SocketException catch (_) {
        print('Not Connected to internet');
        result = false;
      }
    }
    else if (connectivityResult == ConnectivityResult.wifi) {
      print('Wifi Data Connection is available.');
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('Connected to internet');
        }
      } on SocketException catch (_) {
        print('Not Connected to internet');
        result = false;
      }
    }
    else{
      print('Neither Wifi Data or Mobile Data Connection is available.');
      result = false;
    }
    return result;
  }
}