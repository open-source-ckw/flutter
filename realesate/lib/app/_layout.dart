import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'contact.dart';
import 'core/global.dart' as global;
import 'no_connection.dart';

class ULayout extends StatelessWidget {
  ULayout({Key? key}) : super(key: key);

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      //Homepage(), //COMMENTED
      // GMap(),
      Contact(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(context) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: Theme.of(context).primaryColor,
        activeColorSecondary: Theme.of(context).primaryColor,
        inactiveColorPrimary: Colors.white,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/layout': (context) => ULayout(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.map),
          title: ("Map"),
          activeColorPrimary: Theme.of(context).primaryColor,
          activeColorSecondary: Theme.of(context).primaryColor,
          inactiveColorPrimary: Colors.white,
          inactiveColorSecondary: Colors.white),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.account_circle_outlined),
          title: ("Contact"),
          activeColorPrimary: Theme.of(context).primaryColor,
          activeColorSecondary: Theme.of(context).primaryColor,
          inactiveColorPrimary: Colors.white,
          inactiveColorSecondary: Colors.white),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (global.connectionStatus != ConnectivityResult.none)
          ? Center(
              child: PersistentTabView(
                context,
                controller: _controller,
                screens: _buildScreens(),
                items: _navBarsItems(context),
                confineInSafeArea: true,
                backgroundColor: Colors.black,
                // Default is Colors.white.
                handleAndroidBackButtonPress: true,
                // Default is true.
                resizeToAvoidBottomInset: true,
                // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                stateManagement: true,
                // Default is true.
                hideNavigationBarWhenKeyboardShows: true,
                // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                decoration: NavBarDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  colorBehindNavBar: Colors.white,
                ),
                popAllScreensOnTapOfSelectedTab: true,
                popActionScreens: PopActionScreensType.all,
                itemAnimationProperties: ItemAnimationProperties(
                  // Navigation Bar's items animation properties.
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: ScreenTransitionAnimation(
                  // Screen transition animation on change of selected tab.
                  animateTabTransition: true,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle
                    .style1, // Choose the nav bar style with this property.
              ),
            )
          : NoInternetConnection(),
    );
  }
}
