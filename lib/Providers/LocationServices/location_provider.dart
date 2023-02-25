import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

LocationProvider locationProvider = Provider.of(Get.context!, listen: false);

class LocationProvider extends ChangeNotifier {
  Position? currentPosition;
  String currentAddress = "";

  /// Get current Position
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Info.errorSnackBar('Location services are disabled.');
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Info.errorSnackBar('Location permissions are denied');
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Info.errorSnackBar(
          'Location permissions are permanently denied, We cannot request permissions. '
          'please grant location permission from settings');
      return null;
    }

    currentPosition = await Geolocator.getCurrentPosition();

    logger.wtf(currentPosition);

    await getAddressFromLatAndLong(currentPosition!);
    return currentPosition;
  }

  /// Get Address From LatAndLong
  Future<void> getAddressFromLatAndLong(Position position) async {
    if (currentPosition == null) return;
    // List<Placemark> placeMark = await GeocodingPlatform.instance.placemarkFromCoordinates(
    //     currentPosition!.latitude, currentPosition!.longitude,
    //     localeIdentifier: "en");
    // Placemark place = placeMark[0];
    // currentAddress =
    //     '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  }

  /// Open Google Map from OS

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
