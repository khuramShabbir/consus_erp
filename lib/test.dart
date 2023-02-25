import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'utils/info_controller.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    return GeolocatorPlatform.instance.getPositionStream(
      locationSettings: locationSettings,
    );
  }

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

    return await Geolocator.getCurrentPosition();

    // logger.wtf(currentPosition);

    // await getAddressFromLatAndLong(currentPosition!);
  }

  String lat = "0.0";
  String lng = "0.0";

  @override
  void initState() {
    getCurrentPosition();
    getPositionStream().listen((event) {
      setState(() {
        lat = event.latitude.toString();
        lng = event.longitude.toString();
        logger.i(event.longitude);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(lat, style: TextStyle(color: Colors.black, fontSize: 25)),
            Text(lng, style: TextStyle(color: Colors.black, fontSize: 25)),
            ElevatedButton(
                onPressed: () async {
                  final po = await getPositionStream().first;

                  logger.i(po);

                  lat = po.latitude.toString();
                  lng = po.longitude.toString();
                  setState(() {});
                },
                child: Text("Get")),
          ],
        ),
      ),
    );
  }
}

main() {
  runApp(GetMaterialApp(
    home: Test(),
  ));
}
