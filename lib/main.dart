import 'dart:io';

import 'package:consus_erp/Providers/OrdersProvider/add_new_order_provider.dart';
import 'package:consus_erp/Providers/OrdersProvider/orders_provider.dart';

import '/Providers/AreaRegionTradeChannel/trade_channel_ares_regions.dart';
import '/Providers/LocationServices/location_provider.dart';
import '/Providers/ShopsProvider/add_new_shop_provider.dart';
import '/Providers/ShopsProvider/shops_provider.dart';
import '/Providers/UserAuth/login_provider.dart';
import '/localizations/app_localization_delegate.dart';
import '/localizations/language.dart';
import '/splash.dart';
import '/theme/app_notifier.dart';
import '/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
/// MAIN FOR RUN APP
Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  AppTheme.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppNotifier()),
        ChangeNotifierProvider.value(value: LoginProvider()),
        ChangeNotifierProvider.value(value: ShopsProvider()),
        ChangeNotifierProvider.value(value: AddNewShopProvider()),
        ChangeNotifierProvider.value(value: LocationProvider()),
        ChangeNotifierProvider.value(value: TradeChannelAreasRegionsProvider()),
        ChangeNotifierProvider.value(value: OrdersProvider()),
        ChangeNotifierProvider.value(value: AddNewOrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          builder: (context, child) {
            return Directionality(
              textDirection: AppTheme.textDirection,
              child: child!,
            );
          },
          localizationsDelegates: [
            AppLocalizationsDelegate(context),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Language.getLocales(),
          home: Splash(),
        );
      },
    );
  }
}
