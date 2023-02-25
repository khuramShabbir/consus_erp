import 'dart:async';

import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/views/full_app.dart';
import 'package:consus_erp/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    navigateToLogin();
  }

  navigateToLogin() async {
    await Future.delayed(Duration(seconds: 3), () {});

    bool result = await Provider.of<LoginProvider>(context, listen: false).checkUserStatus();

    print(result);
    if (result) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ShoppingManagerFullApp()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/consus_logo.png'),
          ),
        ],
      ),
    );
    ;
  }
}
