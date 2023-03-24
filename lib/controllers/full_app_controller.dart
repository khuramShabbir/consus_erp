import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';

import '../views/dashboard_screen.dart';
import '../views/Orders/orders_list.dart';
import '../views/profile_screen.dart';
import '../views/shops_list.dart';
import '../views/visits_list.dart';

class NavItem {
  final String title;
  final IconData iconData;

  NavItem(this.title, this.iconData);
}

class FullAppController extends FxController {
  int currentIndex = 0;
  int pages = 5;
  late TabController tabController;

  final TickerProvider tickerProvider;

  late List<NavItem> navItems;
  late List<Widget> items;

  FullAppController(this.tickerProvider) {
    tabController =
        TabController(length: pages, vsync: tickerProvider, initialIndex: 0);

    navItems = [
      NavItem('Dashboard', FeatherIcons.airplay),
      NavItem('Shops', FeatherIcons.shoppingBag),
      NavItem('Visits', FeatherIcons.truck),
      NavItem('Orders', FeatherIcons.box),
      NavItem('Profile', FeatherIcons.user),
    ];

    items = [
      DashboardScreen(),
      ShopsList(),
      VisitsList(),
      OrdersList(),
      ProfileScreen(),
    ];
  }

  // void navigateToVisitsList() async{
  //   Info.startProgress();
  //   await visitsListController.getUserData();
  //   await visitsListController.getData(visitsListController.user.salePersonID!, 0);
  //   Info.stopProgress();
  // }

  @override
  void initState() {
    super.initState();
    tabController.addListener(handleTabSelection);
    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
        update();
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
        update();
      }
    });
  }

  handleTabSelection() {
    currentIndex = tabController.index;
    update();
  }

  @override
  String getTag() {
    return "shopping_manager_full_app_controller";
  }
}
