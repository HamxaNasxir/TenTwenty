import 'package:flutter/material.dart';
import 'package:tentwenty/views/menus/mediaPage.dart';
import 'package:tentwenty/views/menus/morePage.dart';
import 'package:tentwenty/views/menus/watchPage.dart';

import '../utils/enums.dart';
import '../network_service/models/bottomNavModel.dart';
import '../utils/images.dart';
import '../views/menus/dashboard.dart';

class BottomNavProvider with ChangeNotifier {
  int pageSelectionIndex = 0;

  int get fetchCurrentScreenIndex => pageSelectionIndex;

  void updatePageSelection(int index) {
    pageSelectionIndex = index;
    notifyListeners();
  }

  List<dynamic> screens = [
    DashboardPage(),
    WatchPage(),
    MediaPage(),
    MorePage(),
  ];

  List<BottomNavItem> navItems = [];

  List<BottomNavItem> get getNavItemList => getNavItems();

  List<BottomNavItem> getNavItems() {
    return [
      const BottomNavItem(
        navTitle: "Dashboard",
        iconData: menuDashboard,
        menuCode: MenuCode.DASHBOARD,
      ),
      const BottomNavItem(
        navTitle: "Watch",
        iconData: menuWatch,
        menuCode: MenuCode.WATCH,
      ),
      const BottomNavItem(
        navTitle: "Media Library",
        iconData: menuMedia,
        menuCode: MenuCode.MEDIA,
      ),
      const BottomNavItem(
        navTitle: "More",
        iconData: menuMore,
        menuCode: MenuCode.MORE,
      ),
    ];
  }
}
