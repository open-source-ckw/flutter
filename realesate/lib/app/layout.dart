import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'contact.dart';
import 'core/get_data.dart';
import 'loader.dart';
import 'core/global.dart' as global;
import 'no_connection.dart';
import 'home_map_fil.dart';

class LayoutScreen extends StatefulWidget {
  Map<String, dynamic> filter;

  LayoutScreen({Key? key, this.filter = const {}}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  bool _isLoading = true;
  List<dynamic> listResult = [];
  int start_record = 0,
      page = 1,
      page_size = 15,
      selectedIndex = 0,
      total_record = 0;
  bool _isLoadingMore = false;

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  initState() {
    // Set default sort option
    if (widget.filter.containsKey('so') == false) {
      widget.filter = {};
      widget.filter.addAll({
        'so': 'price',
        'sd': 'desc',
        'start_record': 0,
        'page_size': page_size.toString()
      });
    }
    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      TabFilter(
        filter: widget.filter,
        isLoading: this._isLoading,
        listResult: this.listResult,
        totalResult: this.total_record,
        isLoadingMore: this._isLoadingMore,
        refreshData: (data) {
          manageData(data);
        },
        onPage: 'Home',
      ),
      TabFilter(
        filter: widget.filter,
        isLoading: this._isLoading,
        listResult: this.listResult,
        totalResult: this.total_record,
        isLoadingMore: this._isLoadingMore,
        refreshData: (data) {
          manageData(data);
        },
        onPage: 'Map',
      ),
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
            '/': (context) => TabFilter(
                filter: widget.filter,
                isLoading: this._isLoading,
                listResult: this.listResult,
                totalResult: this.total_record,
                isLoadingMore: this._isLoadingMore,
                refreshData: (data) {}),
            '/layout': (context) => LayoutScreen(),
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
    // When apply filters and pull to reload data OR when load more data with pagination.
    if (listResult.length <= 0 && _isLoading == true ||
        (_isLoadingMore == true && listResult.length <= total_record)) {
      if (global.connectionStatus != 'ConnectivityResult.none') {
        print('------------ Test --------');
        dataProcess();
      }
    }

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

  manageData(Map<String, dynamic> data) {
    pageref(data);
  }

  pageref(data) {
    if (data.containsKey('action') == true) {
      if (data['action'] == 'scroll') {
        if (this.mounted) {
          setState(() {
            _isLoadingMore = true;
            page++;
            start_record = (page - 1) * page_size;
            widget.filter = data['filter'];
            widget.filter['start_record'] = start_record.toString();
          });
        }
      } else if (data['action'] == 'refresh') {
        loader();
        if (this.mounted) {
          setState(() {
            widget.filter = data['filter'];
            _isLoading = true;
            listResult = [];
          });
        }
      }
    }
  }

  getQueryParam() {
    if (widget.filter.containsKey('keyword') == true &&
        widget.filter['keyword'].containsKey('title') == true) {
      if (widget.filter['keyword']['type'] == 'cs') {
        var city_state = widget.filter['keyword']['title'].split(', ');
        widget.filter['city'] = city_state[0];
        widget.filter['state'] = city_state[1];
      } else {
        widget.filter.remove('city');
        widget.filter.remove('state');
      }

      if (widget.filter['keyword']['type'] == 'sub') {
        widget.filter['subdivision'] = widget.filter['keyword']['title'];
      } else {
        widget.filter.remove('subdivision');
      }

      if (widget.filter['keyword']['type'] == 'add') {
        widget.filter['address'] = widget.filter['keyword']['title'];
      } else {
        widget.filter.remove('address');
      }

      if (widget.filter['keyword']['type'] == 'zip') {
        widget.filter['zipcode'] = widget.filter['keyword']['title'];
      } else {
        widget.filter.remove('zipcode');
      }

      if (widget.filter['keyword']['type'] == 'mls') {
        widget.filter['mls_no'] = widget.filter['keyword']['title'];
      } else {
        widget.filter.remove('mls_no');
      }
    }
  }

  dataProcess() async {
    getQueryParam();
    await SearchResult().getListData(widget.filter).then((data) {
      setState(() {
        if (_isLoadingMore == true) {
          loader1();
          listResult.addAll(data['rs']);
        } else {
          listResult = data['rs'];
        }
        total_record = int.parse(data['total_record']);
        _isLoading = false;
        _isLoadingMore = false;
      });
    });
  }

  loader() {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        color: Colors.white60,
      ),
      alignment: AlignmentDirectional.center,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Loader(),
          Text(
            "Loading...",
          ),
        ],
      ),
    );
  }

  loader1() {
    return Container(
      padding: EdgeInsets.only(bottom: 1800),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        color: Colors.white60,
      ),
      alignment: AlignmentDirectional.center,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Loader(),
          Text(
            "Loading...",
          ),
        ],
      ),
    );
  }
}
