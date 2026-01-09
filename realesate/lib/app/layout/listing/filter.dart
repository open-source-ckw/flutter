import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:outline_search_bar/outline_search_bar.dart';
import '/app/core/api_master.dart';
import '/app/core/get_data.dart';
import '/app/loader.dart';
import '../../data_search.dart';
import '../../core/global.dart' as globals;

class FilterScreen extends StatefulWidget {
  final Map<String, dynamic>? filter;
  late ValueSetter<Map<String, dynamic>>? refreshData;
  String? onPage;

  FilterScreen({Key? key, this.filter, this.refreshData, this.onPage})
      : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  APIMaster objApiH = APIMaster();
  List<String> listSelPType = [];
  Map<String, List<String>> mapSelPType = {};
  List<String> listSelStyle = [];
  bool _isSelectedWF = false; //checkbox value
  bool _isSelectedOH = false; //checkbox value
  bool _isSelectedClosure = false; //checkbox value
  bool _isSelectedSale = false; //checkbox value
  Map<String, dynamic> filterData = {};
  Map<String, dynamic> adFilterData = {};
  Map<String, dynamic> mapPropType = {};
  String selectedPropertyType = '';
  String selectedPropertyStyle = '';

  var selectedValueHOA = null;

  bool _isLoading = true;

  String selectedCity = '';

  bool value = false;

  PersistentBottomSheetController? _controller; // <------ Instance variable
  PersistentBottomSheetController?
      _controllerStyle; // <------ Instance variable
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var max_price = null;
  var min_price = null;

  var beds = null;
  var baths = null;

  int min_acre = 0;
  int max_acre = 0;

  int min_baths = 0;

  var min_sqft = null;
  var max_sqft = null;

  int selMinYear = 0;
  int selMaxYear = 0;

  int min_Hoa = 0;

  String selKeyword = '';
  var DOM = null;
  var Listing_status = null;
  var is_hoa = null;
  var petsAllowed = null;

  Map<String, List<int>> forSale = {};
  Map<String, List<int>> forRent = {};
  TextEditingController srcController = TextEditingController();
  final formatter = new intl.NumberFormat("#,##0");
  final ffINFO = 'Field_Info';
  final cOPTIONS = 'OPTION';

  List hoaFreq = [
    'Any',
    'Annually',
    'Monthly',
    'Quarterly',
    'Semi',
  ];
  Map<String, dynamic> Data = {};

  TextEditingController pTypeCnt = TextEditingController();
  TextEditingController pStyleCnt = TextEditingController();
  TextEditingController minYController = TextEditingController();
  TextEditingController maxYController = TextEditingController();
  TextEditingController minPriceCnt = TextEditingController();
  TextEditingController maxPriceCnt = TextEditingController();
  TextEditingController minSqftCnt = TextEditingController();
  TextEditingController maxSqftCnt = TextEditingController();
  TextEditingController keywords = TextEditingController();
  TextEditingController maxAcre = TextEditingController();
  TextEditingController minAcre = TextEditingController();
  TextEditingController minHoa = TextEditingController();
  TextEditingController minHoa1 = TextEditingController();

  List<DropdownMenuItem<String>> dropdownItemsLs(data, key) {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            'Any',
            style: TextStyle(color: Colors.black),
          ),
          value: 'Any')
    ];
    if (data.length > 0) {
      if (data.containsKey(key) == true &&
          data[key].containsKey('OPTION') == true &&
          data[key]['OPTION'] != '') {
        data[key]['OPTION'].forEach((key, val) {
          menuItems.add(DropdownMenuItem(
              child: Text(
                val,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),
              value: key));
        });
      }
    }
    return menuItems;
  }

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context, widget.filter);
          },
        ),
        title: Text(
          'Filters',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                min_price = 'Any';
                max_price = 'Any';
                min_sqft = 'Any';
                max_sqft = 'Any';
                selectedValueHOA = 'Any';
                is_hoa = 'Any';
                DOM = 'Any';
                Listing_status = 'Any';
                petsAllowed = 'Any';
                beds = 'Studio';
                baths = 'Any';
                pTypeCnt.clear();
                pStyleCnt.clear();
                listSelPType = [];
                mapSelPType = {};
                listSelStyle = [];
                minYController.clear();
                maxYController.clear();
              });
            },
            child: Text(
              'CLEAR',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      bottomNavigationBar: (_isLoading == false && filterData.length >= 0)
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(50, 50)),
              onPressed: () {
                if (this.mounted) {
                  setState(() {
                    FromValueInFilter();
                    CameraPosition(
                      target: LatLng(
                          double.parse(globals.mapConfige['default_lat']),
                          double.parse(globals.mapConfige['default_lang'])),
                      zoom: 20.00,
                    );
                  });
                }
                Navigator.pop(context, widget.filter);
              },
              child: Text('APPLY'),
            )
          : SizedBox(),
      body: (_isLoading == true && filterData.length <= 0)
          ? Center(child: Loader())
          : bodyWidget(),
    );
  }

  bodyWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: filterFields(),
      ),
    );
  }

  Widget filterFields() {
    var mOrientation = MediaQuery.of(context).orientation;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.onPage == 'Map'
            ? Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.grey,
                child: OutlineSearchBar(
                  textEditingController: srcController,
                  backgroundColor: Colors.white,
                  borderColor: Colors.white,
                  searchButtonPosition: SearchButtonPosition.leading,
                  searchButtonIconColor: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  hintText: globals.mapConfige['search_placeholder'] ??
                      'Enter city, neighborhood, address, zipcode, MLS#, Area or Building Name',
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    final result = showSearch(
                        context: context,
                        delegate: DataSearch(filterData: widget.filter),
                        query: widget.filter!['addval'] != ''
                            ? widget.filter!['addval']
                            : srcController.text);

                    // After selecting option load result according
                    result.then((selval) {
                      if (selval != null && selval != '' && selval != 'clear') {
                        var selData = selval.split('_');
                        if (this.mounted) {
                          setState(() {
                            srcController.text = selData[0];
                            widget.filter?.addAll({
                              'addval': selData[0],
                              'addtype': selData[1],
                            });
                            selectedCity = srcController.text;
                          });
                        }
                      } else if (selval == 'clear') {
                        if (this.mounted) {
                          setState(() {
                            widget.filter!['addval']['addtype'] = '';
                            selectedCity = '';
                            srcController.clear();
                          });
                        }
                      }
                    });
                  },
                ),
              )
            : emptyBox(),
        SizedBox(height: 15),
        Text(
          'Property Type',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 17),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black12, minimumSize: Size(MediaQuery.of(context).size.width, 50),),
            onPressed: (){
              FocusScope.of(context).requestFocus(FocusNode());
              _controller = _scaffoldKey.currentState?.showBottomSheet(
                    (context) => Container(
                  height: (mOrientation == Orientation.portrait)
                      ? MediaQuery.of(context).size.height / 1.5
                      : MediaQuery.of(context).size.height / 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                      Expanded(
                        child: propertyType(),
                      )
                    ],
                  ),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                backgroundColor: Colors.grey[200],
                elevation: 5.0,
              );
            },
            child: Text('Property type', style: TextStyle(color: Colors.black,
              fontSize: 13, fontWeight: FontWeight.w400), ),
        ),
        SizedBox(
          height: 10,
        ),
        //propertyStyle(),
        Text(
          '0+Beds',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 17),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: filterBeds(filterData['beds']['OPTION']),
        ),
        SizedBox(
          height: 15,
        ),
        Text('0+Baths',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 10,
        ),
        Row(
          children: filterBath(filterData['baths']['OPTION']),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 15,
        ),
        Text('Price',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            width: (MediaQuery.of(context).size.width / 2) - 16,
            padding: EdgeInsets.only(right: 8.0),
            child: DropdownButtonFormField(
                hint: Text('Min Price'),
                icon: Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: InputBorder.none,
                ),
                validator: (value) => value == null ? "Max" : null,
                dropdownColor: Colors.white,
                value: min_price,
                onChanged: (newValue) {
                  setState(() {
                    min_price = newValue;
                  });
                },
                items: dropdownItemsLs(filterData, 'min_price'),
            ),
          ),
          Spacer(),
          Container(
            width: (MediaQuery.of(context).size.width / 2) - 16,
            padding: EdgeInsets.only(right: 8.0),
            child: DropdownButtonFormField(
                hint: Text('Max Price'),
                icon: Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: InputBorder.none,
                ),
                validator: (value) => value == null ? "Max" : null,
                dropdownColor: Colors.white,
                value: max_price,
                onChanged: (newValue) {
                  max_price = newValue;
                },
                items: dropdownItemsLs(filterData, 'max_price')),
          ),
        ]),
        SizedBox(
          height: 15,
        ),
        Text('Square Feet',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            width: (MediaQuery.of(context).size.width / 2) - 16,
            padding: EdgeInsets.only(right: 8.0),
            child: DropdownButtonFormField(
                hint: Text('Min Sqrt'),
                icon: Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: InputBorder.none,
                ),
                validator: (value) => value == null ? "Max" : null,
                dropdownColor: Colors.white,
                value: min_sqft,
                onChanged: (newValue) {
                  min_sqft = newValue;
                },
                items: dropdownItemsLs(filterData, 'min_sqft')),
          ),
          Spacer(),
          Container(
            width: (MediaQuery.of(context).size.width / 2) - 16,
            padding: EdgeInsets.only(right: 8.0),
            child: DropdownButtonFormField(
                hint: Text('Max Sqrt'),
                icon: Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: InputBorder.none,
                ),
                validator: (value) => value == null ? "Max" : null,
                dropdownColor: Colors.white,
                value: max_sqft,
                onChanged: (newValue) {
                  setState(() {
                    max_sqft = newValue;
                  });
                },
                items: dropdownItemsLs(filterData, 'max_sqft')),
          ),
        ]),
        SizedBox(
          height: 15,
        ),
        Text('Acre(S)',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 17)),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 32,
            height: 48,
            child: Theme(
              data: new ThemeData(
                  inputDecorationTheme: new InputDecorationTheme(
                labelStyle: new TextStyle(color: Colors.grey),
              )),
              child: TextFormField(
                controller: minAcre,
                decoration: InputDecoration(
                  labelText: 'Min',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Theme.of(context).primaryColor)),
                ),
                onChanged: (val) {
                  setState(() {
                    if (this.mounted) {
                      min_acre = int.parse(val);
                    }
                  });
                },
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width / 2 - 32,
            height: 48,
            child: Theme(
              data: new ThemeData(
                  inputDecorationTheme: new InputDecorationTheme(
                labelStyle: new TextStyle(color: Colors.grey),
              )),
              child: TextFormField(
                controller: maxAcre,
                decoration: InputDecoration(
                  labelText: 'Max',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Theme.of(context).primaryColor)),
                ),
                onChanged: (val) {
                  setState(() {
                    if (this.mounted) {
                      max_acre = int.parse(val);
                    }
                  });
                },
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ]),
        SizedBox(
          height: 15,
        ),
        Text(
          'Year Build',
          style: TextStyle(
              color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 - 32,
              height: 48,
              child: Theme(
                data: new ThemeData(
                  inputDecorationTheme: new InputDecorationTheme(
                    labelStyle: new TextStyle(color: Colors.grey),
                  ),
                ),
                child: TextFormField(
                  controller: minYController,
                  decoration: InputDecoration(
                    labelText: 'Min',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      if (this.mounted) {
                        selMinYear = int.parse(val);
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width / 2 - 32,
              height: 48,
              child: Theme(
                data: new ThemeData(
                  inputDecorationTheme: new InputDecorationTheme(
                    labelStyle: new TextStyle(color: Colors.grey),
                  ),
                ),
                child: TextFormField(
                  controller: maxYController,
                  decoration: InputDecoration(
                    labelText: 'Max',
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          new BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      if (this.mounted) {
                        selMaxYear = int.parse(val);
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Text('HOA Free/Frequency',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 17)),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 - 32,
              height: 48,
              child: Theme(
                data: new ThemeData(
                  inputDecorationTheme: new InputDecorationTheme(
                    labelStyle: new TextStyle(color: Colors.grey),
                  ),
                ),
                child: TextFormField(
                  controller: minHoa,
                  decoration: InputDecoration(
                    labelText: 'Min',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Theme.of(context).primaryColor)),
                  ),
                  onChanged: (val) {
                    setState(() {
                      if (this.mounted) {
                        min_Hoa = int.parse(val);
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width / 2) - 16,
              padding: EdgeInsets.only(right: 8.0),
              child: DropdownButtonFormField(
                hint: Text('Any'),
                icon: Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: InputBorder.none,
                ),
                validator: (value) => value == null ? "Max" : null,
                dropdownColor: Colors.white,
                value: selectedValueHOA,
                onChanged: (newValue) {
                  setState(() {
                    selectedValueHOA = newValue;
                  });
                },
                items: hoaFreq.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'keywords',
          style: TextStyle(
              color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 70,
          child: Theme(
            data: new ThemeData(
                inputDecorationTheme: new InputDecorationTheme(
              labelStyle: new TextStyle(color: Colors.grey),
            )),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Garage, pool, waterfront, etc.',
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: Theme.of(context).primaryColor)),
              ),
              onChanged: (newval) {
                setState(() {
                  selKeyword = newval;
                  keywords.clear();
                });
              },
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text('Show Only',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 17)),
        SizedBox(
          height: 10,
        ),
        Container(
          child: CheckboxListTile(
            title: Text(
              'Is Waterfront',
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            value: _isSelectedWF,
            onChanged: (bool? value) {
              setState(() {
                _isSelectedWF = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Container(
          child: CheckboxListTile(
            title: Text(
              'Is OpenHouse',
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            value: _isSelectedOH,
            onChanged: (bool? value) {
              setState(() {
                _isSelectedOH = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Container(
            child: CheckboxListTile(
          title: Text(
            'Is Shortsale',
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          value: _isSelectedSale,
          onChanged: (bool? value) {
            setState(() {
              _isSelectedSale = value!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        )),
        Container(
          child: CheckboxListTile(
            title: Text(
              'Is Foreclosure',
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            value: _isSelectedClosure,
            onChanged: (bool? value) {
              setState(() {
                _isSelectedClosure = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Listing Status',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 16,
                  padding: EdgeInsets.only(right: 8.0),
                  child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text('Any'),
                      icon: Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: InputBorder.none,
                      ),
                      validator: (value) => value == value ? "Min" : null,
                      dropdownColor: Colors.white,
                      value: Listing_status,
                      onChanged: (newValue) {
                        setState(() {
                          Listing_status = newValue;
                        });
                      },
                      items: dropdownItemsLs(adFilterData, 'status')),
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Day On Market',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2 - 16),
                  padding: EdgeInsets.only(right: 8.0),
                  child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text('Any'),
                      icon: Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: InputBorder.none,
                      ),
                      validator: (value) => value == null ? "Max" : null,
                      dropdownColor: Colors.white,
                      value: DOM,
                      onChanged: (newValue) {
                        setState(() {
                          DOM = newValue;
                        });
                      },
                      items: dropdownItemsLs(adFilterData, 'dom')),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pets Allowed',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 16,
                      padding: EdgeInsets.only(right: 8.0),
                      child: DropdownButtonFormField(
                          hint: Text('Any'),
                          icon: Icon(Icons.keyboard_arrow_down),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: InputBorder.none,
                          ),
                          validator: (value) => value == null ? "Max" : null,
                          dropdownColor: Colors.white,
                          value: petsAllowed,
                          onChanged: (newValue) {
                            setState(() {
                              petsAllowed = newValue;
                            });
                          },
                          items: dropdownItemsLs(adFilterData, 'petsAllowed')),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Is HOA',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 16,
                      padding: EdgeInsets.only(right: 8.0),
                      child: DropdownButtonFormField(
                          hint: Text('Any'),
                          icon: Icon(Icons.keyboard_arrow_down),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: InputBorder.none,
                          ),
                          validator: (value) => value == null ? "Max" : null,
                          dropdownColor: Colors.white,
                          value: is_hoa,
                          onChanged: (newValue) {
                            setState(() {
                              is_hoa = newValue;
                            });
                          },
                          items: dropdownItemsLs(adFilterData, 'ishoa')),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  propertyStyle(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property style',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 17),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: new BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(const Radius.circular(5.0)),
          ),
          child: TextField(
              enableInteractiveSelection: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Property style',
              ),
              controller: pStyleCnt,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _controllerStyle = _scaffoldKey.currentState?.showBottomSheet(
                      (context) => Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Apply',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Expanded(
                            child: proStyle(),
                          ),
                        ]),
                  ),
                );
              }),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  propertyType() {
    List<Widget> wPType = [];
    mapPropType.forEach((key, value) {
      wPType.add(
        CheckboxListTile(
          title: Text(
            key,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          value: (mapSelPType.containsKey(key) == true) ? true : false,
          onChanged: (val) {
            print('-------- val --------');
            print(val);
            print(key);
            print(value.keys.toList());
            List<dynamic> allKeys = value.keys.toList();
            _controller!.setState!(() {
              if (val == true) {
                for (var i = 0; i < allKeys.length; i++) {
                  if (allKeys[i].contains('-stype') == true ||
                      key == 'ForIncome') {
                    /// SType
                    listSelStyle.add(allKeys[i]);
                  } else {
                    //print(allKeys[i]);
                    /// PType
                    listSelPType.add(allKeys[i]);
                  }
                }
                print('listSelStyle');
                print(listSelStyle);
                print('listSelPType');
                print(listSelPType);
                print(mapSelPType);

                mapSelPType.addAll({key: value.keys.toList()});
                //listSelPType.addAll(value.keys.toList());
              } else {
                print('---- Else-----');
                print(key);
                print(mapSelPType);
                print(listSelPType);
                print(listSelStyle);
                ///List<String> allKeys = mapSelPType[key]!.toList();
                mapSelPType.remove(key);
                //listSelPType.remove(key);
                //listSelStyle.remove(key);
                ///List<String> allKeys = value.keys.toList();

                print('allKeys');
                print(allKeys);

                if (listSelPType.length > 0) {
                  print('-------------- listSelPType ----------');
                  List<String> newData = [];
                  // When remove all forSale/forRent data and list have both selected data forSale and rent that time we have to delete all data of specific key, and here is list so here we have checked if list of value is not exist in specific key value list then add data in new data variable
                  // If we directly remove data from listSelPType variable then it occurred error because we used this variable in foreach loop
                  // So in this case we can not directly remove value from listSelPType variable.
                  listSelPType.forEach((element) {
                    if (!allKeys.contains(element)) {
                      newData.add(element);
                    }
                  });
                  listSelPType = newData;

                  print(listSelPType);
                  // When all options is removed from list that time we have to clear the list
                  if (listSelPType.length <= 0) {
                    print('------------- If Else-------');
                    listSelPType = [];
                  }

                  print(mapSelPType);
                  print('mapSelPType');
                }

                if (listSelStyle.length > 0) {
                  print('---------- listSelStyle ---------');
                  List<String> newData = [];
                  // When remove all forSale/forRent data and list have both selected data forSale and rent that time we have to delete all data of specific key, and here is list so here we have checked if list of value is not exist in specific key value list then add data in new data variable
                  // If we directly remove data from  listSelPType variable then it occurred error because we used this variable in foreach loop
                  // So in this case we can not directly remove value from listSelPType variable.
                  listSelStyle.forEach((element) {
                    if (!allKeys.contains(element)) {
                      newData.add(element);
                    }
                  });
                  listSelStyle = newData;

                  print(listSelStyle);
                  // When all options is removed from list that time we have to clear the list
                  if (listSelStyle.length <= 0) {
                    listSelStyle = [];
                  }

                  print(mapSelPType);
                  print('listSelStyle');
                }
              }
            });
          },
        ),
      );
      Widget wChildType = cPropType(value, key);
      wPType.add(wChildType);
    });
    return ListView(
      children: wPType,
    );
  }

  cPropType(mapType, key) {
    List<Widget> wcPType = [];
    mapType.forEach((k, v) {
      wcPType.add(CheckboxListTile(
        title: Text(
          v,
          style: TextStyle(color: Colors.black),
        ),
        value: (mapSelPType.containsKey(key) == true &&
                mapSelPType[key]?.contains(k) == true)
            ? true
            : false,
        onChanged: (val) {
          print('val');
          print(key);

          _controller!.setState!(() {
            if (val == true) {
              if (mapSelPType.containsKey(key) == true) {
                mapSelPType[key]?.add(k);
              } else {
                mapSelPType.addAll({
                  key: [k]
                });
              }
              if (k.contains('-stype') == true || key == 'ForIncome') {
                /// SType
                listSelStyle.add(k);
              } else {
                /// PType
                listSelPType.add(k);
              }
              //listSelPType.add(k);
            } else {
              mapSelPType[key]?.remove(k);
              listSelPType.remove(k);
              listSelStyle.remove(k);
              if (mapSelPType[key]?.length == 0) {
                mapSelPType.remove(key);
              }
              // Blank list when uncheck all pType
              if (mapSelPType.length == 0) {
                listSelPType = [];
                listSelStyle = [];
              }
            }
          });
        },
      ));
    });
    return Container(
      padding: EdgeInsets.only(left: 16.0),
      child: Column(
        children: wcPType,
      ),
    );
  }

  proStyle() {
    if (adFilterData['style']['TITLE'] == 'Style') {
      return ListView.builder(
        itemCount: adFilterData['style']['OPTION'].length,
        itemBuilder: (context, minDex) {
          var lKeys = adFilterData['style']['OPTION'].values.toList();
          var lSelKeys = adFilterData['style']['OPTION'].keys.toList();
          return Column(
            children: [
              CheckboxListTile(
                title: Text(
                  lKeys[minDex],
                  style: TextStyle(color: Colors.black),
                ),
                value: listSelStyle.contains(lSelKeys[minDex]) ? true : false,
                onChanged: (val) {
                  _controllerStyle!.setState!(() {
                    //var data = {mindex: lselkeys[mindex].toString()};
                    if (listSelStyle.contains(lSelKeys[minDex])) {
                      listSelStyle.remove(lSelKeys[minDex]);
                    } else {
                      listSelStyle.add(lSelKeys[minDex]);
                    }
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  filterBeds(data) {
    List<Widget> filter = <Widget>[];
    double size = 70;
    double sizeBX =
        (MediaQuery.of(context).size.width - size - 32) / (data.length - 1);
    if (filterData['beds'].containsKey('OPTION') == true) {
      for (var i = 0; i < data.length; i++) {
        filter.add(
          GestureDetector(
            onTap: () {
              beds = data[i];
              setState(() {
                beds == data[i]
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200];
              });

              this.widget.filter?['minbed'] =
                  data[i].toString().replaceAll('+', '');
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              width: (i == 0) ? size : sizeBX,
              decoration: BoxDecoration(
                color: beds == data[i]
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                border: Border(
                  left: BorderSide(
                    width: 1.0,
                    color: Colors.grey.shade50,
                  ),
                  right: BorderSide(width: 1.0, color: Colors.grey.shade50),
                  top: BorderSide(width: 1.0, color: Colors.grey.shade50),
                  bottom: BorderSide(width: 1.0, color: Colors.grey.shade50),
                ),
              ),
              child: Center(
                child: Text(
                  data[i],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      }
      ;
    }
    return filter;
  }

  filterBath(data) {
    List<Widget> filter = <Widget>[];
    double size = 51;
    double sizeBX =
        (MediaQuery.of(context).size.width - size - 32) / (data.length);
    filter.add(
      GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: baths == 'Any'
                ? Theme.of(context).primaryColor
                : Colors.grey[200],
            border: Border(
              left: BorderSide(
                width: 1.0,
                color: Colors.grey.shade50,
              ),
              right: BorderSide(width: 1.0, color: Colors.grey.shade50),
              top: BorderSide(width: 1.0, color: Colors.grey.shade50),
              bottom: BorderSide(width: 1.0, color: Colors.grey.shade50),
            ),
          ),
          child: Center(
            child: Text(
              'Any',
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
          ),
        ),
      ),
    );
    data.forEach((key, val) {
      filter.add(
        GestureDetector(
          onTap: () {
            baths = key;
            setState(() {
              baths == key ? Theme.of(context).primaryColor : Colors.grey[200];
            });

            this.widget.filter?['minbath'] = val.toString().replaceAll('+', '');
          },
          child: Container(
            padding: EdgeInsets.all(12.0),
            width: (key == 0) ? size : sizeBX,
            // height: 48,
            decoration: BoxDecoration(
              color: baths == key
                  ? Theme.of(context).primaryColor
                  : Colors.grey[200],
              border: Border(
                left: BorderSide(
                  width: 1.0,
                  color: Colors.grey.shade50,
                ),
                right: BorderSide(width: 1.0, color: Colors.grey.shade50),
                top: BorderSide(width: 1.0, color: Colors.grey.shade50),
                bottom: BorderSide(width: 1.0, color: Colors.grey.shade50),
              ),
            ),
            child: Center(
              child: Text(
                val,
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
          ),
        ),
      );
    });
    return filter;
  }

  getAllData() {
    setSelectedFilters();
    getData();
  }

  setSelectedFilters() {
    if (widget.filter?.containsKey('addval') == true) {
      selectedCity = widget.filter?['addval'];
      srcController.text = selectedCity;
    }
    if (this.widget.filter?.containsKey('ptype') == true) {
      mapSelPType = this.widget.filter?['refptype'];
      listSelPType = this.widget.filter?['ptype'];
    }
    if (this.widget.filter?.containsKey('stype') == true) {
      listSelStyle = this.widget.filter?['stype'];
    }
    if (this.widget.filter?.containsKey('minbed') == true) {
      beds = this.widget.filter?['minbed'];
    }
    if (this.widget.filter?.containsKey('minbath') == true) {
      baths = this.widget.filter?['minbath'];
    }
    if (this.widget.filter?.containsKey('maxprice') == true) {
      max_price = this.widget.filter?['maxprice'];
    }
    if (this.widget.filter?.containsKey('minprice') == true) {
      min_price = this.widget.filter?['minprice'];
    }
    if (this.widget.filter?.containsKey('maxsqft') == true) {
      max_sqft = this.widget.filter?['maxsqft'];
    }
    if (this.widget.filter?.containsKey('minsqft') == true) {
      min_sqft = this.widget.filter?['minsqft'];
    }
    if (this.widget.filter?.containsKey('minyear') == true) {
      minYController.text = "${this.widget.filter?['minyear']}";
    }
    if (this.widget.filter?.containsKey('maxyear') == true) {
      maxYController.text = "${this.widget.filter?['maxyear']}";
    }
    if (this.widget.filter?.containsKey('kword') == true) {
      keywords.text = "${this.widget.filter?['kword']}";
    }
    if (this.widget.filter?.containsKey('maxacreage') == true) {
      maxAcre.text = "${this.widget.filter?['maxacreage']}";
    }
    if (this.widget.filter?.containsKey('minacreage') == true) {
      minAcre.text = "${this.widget.filter?['minacreage']}";
    }
    if (this.widget.filter?.containsKey('iswaterfront') == true) {
      _isSelectedWF = true;
    }
    if (this.widget.filter?.containsKey('closure') == true) {
      _isSelectedClosure = true;
    }
    if (this.widget.filter?.containsKey('oh') == true) {
      _isSelectedOH = true;
    }
    if (this.widget.filter?.containsKey('shortsale') == true) {
      _isSelectedSale = true;
    }
    if (this.widget.filter?.containsKey('status') == true) {
      Listing_status = this.widget.filter?['status'];
    }
    if (this.widget.filter?.containsKey('dom') == true) {
      DOM = this.widget.filter?['dom'];
    }
    if (this.widget.filter?.containsKey('petsAllowed') == true) {
      petsAllowed = this.widget.filter?['petsAllowed'];
    }
    if (this.widget.filter?.containsKey('ishoa') == true) {
      is_hoa = this.widget.filter?['ishoa'];
    }
    if (this.widget.filter?.containsKey('hoafee') == true) {
      minHoa.text = "${this.widget.filter?['hoafee']}";
    }
    if (this.widget.filter?.containsKey('hoafqncy') == true) {
      selectedValueHOA = this.widget.filter?['hoafqncy'];
    }
  }

  getData() async {
    await SearchResult().getFilterData().then((l_data) {
      filterData = l_data;
    });
    await getAddFilterData();
    await getPropTypeData();
  }

  getAddFilterData() async {
    await SearchResult().getAdvanceFilterData().then((fl_data) {
      if (mounted) {
        setState(() {
          adFilterData = fl_data;
          _isLoading = false;
        });
      }
    });
  }

  getPropTypeData() async {
    await SearchResult().getPropType().then((returnPropertyTypeData) {
      if (mounted) {
        setState(() {
          mapPropType.addAll(returnPropertyTypeData);
          _isLoading = false;
        });
      }
    });
  }

  FromValueInFilter() {
    if (this.widget.filter != null && this.widget.filter is Map) {
      //if (mapSelPType.length > 0 && mapSelPType != null) {
      if (listSelPType.length > 0) {
        this.widget.filter?.addAll({
          'ptype': listSelPType,
        });
        this.widget.filter?.addAll({
          'refptype': mapSelPType,
        });
      } else {
        this.widget.filter?.remove('ptype');
        this.widget.filter?.remove('refptype');
      }
      if (listSelStyle.length > 0) {
        this.widget.filter?.addAll({
          'stype': listSelStyle,
        });
        this.widget.filter?.addAll({
          'refptype': mapSelPType,
        });
      } else {
        this.widget.filter?.remove('stype');
        this.widget.filter?.remove('refptype');
      }

      if (max_price != null && max_price != 0) {
        this.widget.filter?.addAll({
          'maxprice': max_price,
        });
      } else {
        this.widget.filter!.remove('maxprice');
      }

      if (min_price != null && min_price != 0) {
        this.widget.filter?.addAll({
          'minprice': min_price,
        });
      } else {
        this.widget.filter!.remove('minprice');
      }

      if (beds != null && beds != 0) {
        widget.filter?.addAll({
          'minbed': beds,
        });
      } else {
        widget.filter!.remove('minbed');
      }

      if (baths != null && baths != 0) {
        widget.filter?.addAll({
          'minbath': baths,
        });
      } else {
        widget.filter!.remove('minbath');
      }

      if (min_sqft != null && min_sqft != 0) {
        this.widget.filter?.addAll({
          'minsqft': min_sqft,
        });
      } else {
        this.widget.filter!.remove('minsqft');
      }

      if (max_sqft != null && max_sqft != 0) {
        this.widget.filter?.addAll({
          'maxsqft': max_sqft,
        });
      } else {
        this.widget.filter!.remove('maxsqft');
      }

      if (max_acre != 0) {
        this.widget.filter?.addAll({
          'maxacreage': max_acre,
        });
      } else {
        this.widget.filter!.remove('maxacreage');
      }

      if (min_acre != 0) {
        this.widget.filter?.addAll({
          'minacreage': min_acre,
        });
      } else {
        this.widget.filter!.remove('minacreage');
      }

      if (selMaxYear != 0) {
        this.widget.filter?.addAll({
          'maxyear': selMaxYear,
        });
      } else {
        this.widget.filter!.remove('maxyear');
      }

      if (selMinYear != 0) {
        this.widget.filter?.addAll({
          'minyear': selMinYear,
        });
      } else {
        this.widget.filter!.remove('minyear');
      }

      if (min_Hoa != 0) {
        this.widget.filter?.addAll({
          'hoafee': min_Hoa,
        });
      } else {
        this.widget.filter!.remove('hoafee');
      }

      if (selectedValueHOA != null) {
        this.widget.filter?.addAll({
          'hoafqncy': selectedValueHOA,
        });
      } else {
        this.widget.filter!.remove('hoafqncy');
      }

      if (selKeyword != '') {
        this.widget.filter?.addAll({
          'kword': selKeyword,
        });
      } else {
        this.widget.filter!.remove('kword');
      }

      if (Listing_status != null && Listing_status != 0) {
        this.widget.filter?.addAll({
          'status': Listing_status,
        });
      } else {
        this.widget.filter!.remove('status');
      }

      if (DOM != null && DOM != 0) {
        this.widget.filter?.addAll({
          'dom': DOM,
        });
      } else {
        this.widget.filter!.remove('dom');
      }

      if (is_hoa != false && is_hoa == true) {
        this.widget.filter?.addAll({
          'ishoa': is_hoa,
        });
      } else {
        this.widget.filter?.remove('ishoa');
      }

      if (petsAllowed != false && petsAllowed == true) {
        this.widget.filter?.addAll({
          'petsAllowed': petsAllowed,
        });
      } else {
        this.widget.filter?.remove('petsAllowed');
      }
      if (_isSelectedClosure == true) {
        this.widget.filter?.addAll({
          'closure': 'Yes',
        });
      } else {
        this.widget.filter?.remove('closure');
      }
      if (_isSelectedWF == true) {
        this.widget.filter?.addAll({
          'iswaterfront': 'Yes',
        });
      } else {
        this.widget.filter?.remove('iswaterfront');
      }
      if (_isSelectedOH == true) {
        this.widget.filter?.addAll({
          'oh': 'Yes',
        });
      } else {
        this.widget.filter?.remove('oh');
      }
      if (_isSelectedSale == true) {
        this.widget.filter?.addAll({'shortsale': 'Yes'});
      } else {
        this.widget.filter?.remove('shortsale');
      }
    }
  }

  refreshDataFP(String s) {
    var data = {'action': 'refresh', 'filter': widget.filter};
    widget.refreshData!(data);
  }

  Widget emptyBox() {
    return new SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }
}
