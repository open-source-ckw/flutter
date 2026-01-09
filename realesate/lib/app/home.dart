import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'layout/listing/listing-results.dart';
import '/app/sort.dart';
import 'data_search.dart';
import 'layout/listing/filter.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'core/global.dart' as global;
import 'package:intl/intl.dart' as intl;
import 'loader.dart';

class Homepage extends StatefulWidget {
  Map<String, dynamic> filter;
  bool isLoading;
  List<dynamic> listResult = [];
  ValueSetter<Map<String, dynamic>> refreshData;
  int totalResult = 0;
  bool isLoadingMore = false;

  Homepage({
    Key? key,
    required this.filter,
    required this.isLoading,
    required this.listResult,
    required this.totalResult,
    required this.refreshData,
    required this.isLoadingMore,
  }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState(this.filter);
}

class _HomepageState extends State<Homepage> {
  //final ScrollController _scrollController = ScrollController();
  TextEditingController textController = TextEditingController();

  final formatter = new intl.NumberFormat("#,##0");
  String? selectedCity;
  Map<String, dynamic> filter;

  _HomepageState(this.filter);

  @override
  void initState() {
    super.initState();
    if (this.filter.containsKey('keyword') == true) {
      srcController.text = selectedCity!;
    }
    /*_scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          widget.isLoading) {}
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  TextEditingController srcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var total_record =
        formatter.format(double.parse(widget.totalResult.toString()));

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      shadowColor: Colors.grey,
                      child: OutlineSearchBar(
                        textEditingController: srcController,
                        backgroundColor: Colors.white,
                        borderColor: Colors.white,
                        searchButtonPosition: SearchButtonPosition.leading,
                        searchButtonIconColor: Colors.black,
                        onClearButtonPressed: (tap) {
                          selectedCity = null;
                          this.filter.clear();

                          Map<String, dynamic> data = Map<String, dynamic>();
                          data['action'] = 'refresh';
                          refreshDataFP(data);
                        },
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        hintText: global.mapConfige['search_placeholder'] ??
                            'Enter city, neighborhood, address, zipcode, MLS#, Area or Building Name',
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AutoSuggestionSearch()));
                          final result = showSearch(
                              context: context,
                              delegate: DataSearch(filterData: this.filter),
                              query: srcController.text);

                          // After selecting option load result according
                          result.then(
                            (selval) {
                              if (selval != null &&
                                  selval != '' &&
                                  selval != 'clear') {
                                var selData = selval.split('_');
                                if (this.mounted) {
                                  setState(() {
                                    srcController.text = selData[0];

                                    /*this.filter.addAll(
                                       {
                                        'addval': selData[0],
                                        'addtype': selData[1],
                                      },
                                    );*/
                                    Map<String, dynamic> data =
                                        Map<String, dynamic>();
                                    data['filter'] = {
                                      'addval': selData[0],
                                      'addtype': selData[1],
                                    };
                                    data['action'] = 'refresh';
                                    selectedCity = srcController.text;
                                    refreshDataFP(data);
                                  });
                                }
                              } else if (selval == 'clear') {
                                if (this.mounted) {
                                  setState(() {
                                    //this.filter['addval']['addtype'] = '';
                                    Map<String, dynamic> data =
                                        Map<String, dynamic>();
                                    data['filter'] =
                                        this.filter['addval']['addtype'] = '';
                                    data['action'] = 'refresh';
                                    selectedCity = '';
                                    srcController.clear();
                                    refreshDataFP(data);
                                  });
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      this.filter['addval'] != null
                          ? 'Home For Sale'
                          : (selectedCity != null && selectedCity == '')
                              ? 'Home For Sale'
                              : (selectedCity == null || selectedCity == '')
                                  ? 'Home For Sale'
                                  : srcController.text,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${total_record} Properties found",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              /*Container(
              margin: EdgeInsets.only(bottom: 3.0),
              child: Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          right: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        )),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        height: 35,
                        child: InkWell(
                          onTap: () {
                            //Navigator.of(context).push(_createRoute());
                            var result = showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 400,
                                    child: Sorting(
                                      filter: this.filter,
                                    ),
                                  );
                                });
                            result.then((value) {
                              setState(() {
                                this.filter = value;
                                refreshDataFP('refresh');
                              });
                            });
                          },
                          child: Center(
                            child: Wrap(
                              children: [
                                Text(
                                  'SORT',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                ),
                                Icon(
                                  Icons.import_export,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.black54,
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: Colors.black54,
                            width: 1,
                          ),
                        )),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        height: 35,
                        child: InkWell(
                          onTap: () {
                            final result = pushNewScreen(context,
                                withNavBar: false,
                                screen: Filter(filter: this.filter));
                            result.then((value) {
                              setState(() {
                                this.filter = value;
                                refreshDataFP('refresh');
                              });
                            });
                          },
                          child: Wrap(
                            children: [
                              Text(
                                'FILTER',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
              Container(
                margin: EdgeInsets.only(bottom: 3.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton.icon(
                          icon: Icon(
                            Icons.import_export,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            //Navigator.of(context).push(_createRoute());
                            var result = showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  child: Sorting(
                                    filter: this.filter,
                                  ),
                                );
                              },
                            );
                            result.then((value) {
                              if (value != null) {
                                setState(() {
                                  //this.filter = value;
                                  Map<String, dynamic> data =
                                      Map<String, dynamic>();
                                  data['filter'] = value;
                                  data['action'] = 'refresh';
                                  refreshDataFP(data);
                                });
                              }
                            });
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                          label: Text(
                            'SORT',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton.icon(
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            final result = PersistentNavBarNavigator.pushNewScreen(context,
                                withNavBar: false,
                                screen: FilterScreen(filter: this.filter));
                            result.then((value) {
                              setState(() {
                                this.filter = value;
                                Map<String, dynamic> data =
                                    Map<String, dynamic>();
                                data['filter'] = value;
                                data['action'] = 'refresh';
                                refreshDataFP(data);
                              });
                            });
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                          label: Text(
                            'FILTER',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              (widget.isLoading == true)
                  ? Expanded(
                      child: loader(),
                    )
                  : (widget.listResult.length == 0)
                      ? Expanded(
                          child: Center(
                            child: Text(
                              global.mapConfige['savesearch_no_data'],
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListingResults(
                            listAllData: widget.listResult,
                            isLoading: widget.isLoading,
                            isLoadingMore: widget.isLoadingMore,
                            total_result: widget.totalResult,
                            filterData: this.filter,
                            refreshData: (callBackData) {
                              this.refreshDataFP(callBackData);
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  refreshDataFP(Map<String, dynamic> callBackData) {
    //var data = {'action': action, 'filter': data['filter']};
    widget.refreshData(callBackData);
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
}
