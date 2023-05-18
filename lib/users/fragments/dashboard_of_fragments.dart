
import 'package:etradinggradproj/users/fragments/profile_fragment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../userPreferences/current_user.dart';
import 'favorites_fragment_screen.dart';
import 'home_fragment_screen.dart';
import 'order_fragment_screen.dart';


class DashboardOfFragments extends StatelessWidget
{
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  final List<Widget> _fragmentScreens =
  [
    HomeFragmentScreen(),
    FavoritesFragmentScreen(),
    OrderFragmentScreen(),
    ProfileFragmentScreen(),
  ];

  final List _navigationButtonsProperties =
  [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border,
      "label": "Favorites",
    },
    {
      "active_icon": Icons.delivery_dining,
      "non_active_icon": Icons.delivery_dining_sharp,
      "label": "Orders",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Profile",
    },
  ];

  final RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState)
      {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller)
      {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Obx(
                ()=> _fragmentScreens[_indexNumber.value]
            ),
          ),
          bottomNavigationBar: Obx(
              ()=> BottomNavigationBar(
                currentIndex: _indexNumber.value,
                onTap: (value)
                {
                  _indexNumber.value = value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white24,
                items: List.generate(4, (index) 
                {
                  var navBtnProperty = _navigationButtonsProperties[index];
                  return BottomNavigationBarItem(
                    backgroundColor: Colors.black,
                    icon: Icon(navBtnProperty["non_active_icon"]),
                    activeIcon: Icon(navBtnProperty["active_icon"]),
                    label: navBtnProperty["label"],
                  );
                }),
              ),
          ),
        );
      },
    );
  }
}
