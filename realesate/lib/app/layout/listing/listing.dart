import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../loader.dart';
import 'listing_box.dart';
import 'package:intl/intl.dart' as intl;

class Listing extends StatefulWidget {
  Map<String, dynamic>? filter;
  bool refresh = false;

  Listing(
    this.filter,
    this.refresh, {
    Key? key,
  }) : super(key: key);

  @override
  _ListingState createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  RefreshController refreshController = RefreshController();
  List<Map<String, String>> listData = [];
  late ValueSetter<Map<String, dynamic>> refreshData;
  List listAllData = [];
  bool _isLoading = false;
  String selectedPropertyType = '';
  String selectedCity = '';
  bool value = false;

  int max_price = 0;
  int min_price = 0;
  int min_beds = 0;
  int min_baths = 0;
  int min_sqft = 0;
  int max_sqft = 0;

  final formatter = new intl.NumberFormat("#,##0");

  TextEditingController srcController = TextEditingController();
  TextEditingController ptypeCnt = TextEditingController();
  TextEditingController bedroomsCnt = TextEditingController();
  TextEditingController bathroomsCnt = TextEditingController();
  TextEditingController minYController = TextEditingController();
  TextEditingController maxYController = TextEditingController();
  TextEditingController minPriceCnt = TextEditingController();
  TextEditingController maxPriceCnt = TextEditingController();
  TextEditingController minSqftCnt = TextEditingController();
  TextEditingController maxSqftCnt = TextEditingController();
  TextEditingController maxAcre = TextEditingController();
  TextEditingController minAcre = TextEditingController();
  TextEditingController maxHoa = TextEditingController();
  TextEditingController minHoa = TextEditingController();

  @override
  void initState() {
    _isLoading = true;
    super.initState();
  }

  getQueryParam() {
    if (widget.filter?.containsKey('keyword') == true &&
        widget.filter?['keyword'].containsKey('title') == true) {
      if (widget.filter?['keyword']['type'] == 'cs') {
        var city_state = widget.filter?['keyword']['title'].split(', ');

        widget.filter?['city'] = city_state[0];
        widget.filter?['state'] = city_state[1];
      } else {
        widget.filter?.remove('city');
        widget.filter?.remove('state');
      }

      if (widget.filter?['keyword']['type'] == 'sub') {
        widget.filter?['subdivision'] = widget.filter?['keyword']['title'];
      } else {
        widget.filter?.remove('subdivision');
      }

      if (widget.filter?['keyword']['type'] == 'add') {
        widget.filter?['address'] = widget.filter?['keyword']['title'];
      } else {
        widget.filter?.remove('address');
      }

      if (widget.filter?['keyword']['type'] == 'zip') {
        widget.filter?['zipcode'] = widget.filter?['keyword']['title'];
      } else {
        widget.filter?.remove('zipcode');
      }

      if (widget.filter?['keyword']['type'] == 'mls') {
        widget.filter?['mls_no'] = widget.filter?['keyword']['title'];
      } else {
        widget.filter?.remove('mls_no');
      }
    }

    if (widget.filter != null) {
      if (widget.filter?.containsKey('keyword') == true) {
        srcController.text = widget.filter!['keyword']['title'];
        selectedCity = widget.filter!['keyword']['title'];
      }

      if (widget.filter?.containsKey('ptype') == true) {
        ptypeCnt.text =
            '${widget.filter!['ptype'][0].toUpperCase()}${widget.filter!['ptype'].substring(1)}';
        selectedPropertyType = widget.filter!['ptype'];
      }

      if (widget.filter?.containsKey('minbed') == true) {
        bedroomsCnt.text = formatter
                .format(double.parse(widget.filter!['minbed'].toString())) +
            '+';
        min_beds = widget.filter!['minbed'];
      }

      if (widget.filter?.containsKey('minbath') == true) {
        bedroomsCnt.text = formatter
                .format(double.parse(widget.filter!['minbath'].toString())) +
            '+';
        min_baths = widget.filter!['minbath'];
      }

      if (widget.filter?.containsKey('minprice') == true) {
        if (widget.filter!['minprice'] == 0) {
          minPriceCnt.text = 'Min Price';
        } else {
          minPriceCnt.text = '\$' +
              formatter
                  .format(double.parse(widget.filter!['minprice'].toString())) +
              '+';
        }
        min_price = widget.filter!['minprice'];
      }

      if (widget.filter?.containsKey('maxprice') == true) {
        if (widget.filter!['maxprice'] == 0) {
          maxPriceCnt.text = 'Max Price';
        } else {
          maxPriceCnt.text = '\$' +
              formatter
                  .format(double.parse(widget.filter!['maxprice'].toString())) +
              '+';
        }
        max_price = widget.filter!['maxprice'];
      }

      if (widget.filter?.containsKey('minsqft') == true) {
        if (widget.filter!['minsqft'] == 0) {
          minSqftCnt.text = 'Min Sqft';
        } else {
          minSqftCnt.text = formatter
                  .format(double.parse(widget.filter!['minsqft'].toString())) +
              '+';
        }
        min_sqft = widget.filter!['minsqft'];
      }

      if (widget.filter?.containsKey('maxsqft') == true) {
        if (widget.filter!['maxsqft'] == 0) {
          maxSqftCnt.text = 'Max Sqft';
        } else {
          maxSqftCnt.text = formatter
                  .format(double.parse(widget.filter!['maxsqft'].toString())) +
              '+';
        }
        max_sqft = widget.filter!['maxsqft'];
      }
    }
  }

  dataProcess(bool bool, {bool reload = true}) async {
    if (reload = false) {
      setState(() {
        _isLoading = true;
        listAllData = [];
      });
    }
    getQueryParam();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.refresh == true) dataProcess(true);
    return Stack(children: [
      (_isLoading == true && listAllData.length == 0)
          ? Center(child: Loader())
          : CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return SmartRefresher(
                          controller: refreshController,
                          enablePullUp: true,
                          onRefresh: () async {
                            final result = await dataProcess(false);
                            if (result) {
                              refreshController.refreshCompleted();
                            } else {
                              refreshController.refreshFailed();
                            }
                          },
                          onLoading: () async {
                            final result = await dataProcess(false);
                            if (result) {
                              refreshController.refreshCompleted();
                            } else {
                              refreshController.refreshFailed();
                            }
                          },
                          child: ListingBox(data: listData[index]));
                    },
                    childCount: listAllData.length,
                  ),
                ),
              ],
            ),
    ]);
  }
}
