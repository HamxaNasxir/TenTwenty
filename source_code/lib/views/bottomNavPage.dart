import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../view_model/bottomNavProvider.dart';
import '../view_model/moviesProvider.dart';
import '../network_service/models/bottomNavModel.dart';

class BottomNavPage extends StatelessWidget {
  final Key bottomNavKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Color selectedItemColor = whiteColor;
    Color unselectedItemColor = greyColor;

    final navProvider = Provider.of<BottomNavProvider>(context);
    int currentScreenIndex = navProvider.fetchCurrentScreenIndex;

    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          key: bottomNavKey,
          items: navProvider.getNavItemList
              .map(
                (BottomNavItem navItem) => BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Image.asset(
                        navItem.iconData,
                        width: 18,
                        height: 18,
                        color: navProvider.getNavItemList.indexOf(navItem) == navProvider.pageSelectionIndex ? selectedItemColor : unselectedItemColor,
                      ),
                    ),
                    label: navItem.navTitle,
                    tooltip: ""),
              )
              .toList(),
          elevation: 1,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: bottomNavColor,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          currentIndex: navProvider.pageSelectionIndex,
          onTap: (index) {
            navProvider.updatePageSelection(index);
          },
        ),
      ),
      body: navProvider.screens[currentScreenIndex],
    );
  }
}
