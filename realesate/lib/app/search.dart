import 'dart:convert';
import 'package:flutter/material.dart';
import 'core/api_master.dart';
import 'core/constant.dart';
import 'data_search.dart';

class Searching extends StatefulWidget {
  final Map<String, dynamic>? filter;

  const Searching({Key? key, this.filter}) : super(key: key);

  @override
  _SearchingState createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {
  APIMaster objApiH = APIMaster();
  late String selectedCity;
  List listAllData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Future<void> getSearch(String query) async {
    Map<String, dynamic> f_data = {"keywords": query};
    var post = {
      module: "address",
      action: "autosuggestion",
      "key": API_KEY,
      "filter": jsonEncode(f_data),
    };
  }

  TextEditingController srcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                  child: CircleAvatar(
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                ),
                backgroundColor: Colors.white,
              )),
              Spacer(),
              Text('Search',
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 23,
                      fontWeight: FontWeight.w400)),
              Spacer(),
              Text('Clear',
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
            ]),
        SizedBox(
          height: 15,
        ),
        TextField(
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {},
                highlightColor: Colors.transparent,
              ),
              border: InputBorder.none,
              hintText: 'Address, city, postal code, neighborhood',
            ),
            controller: srcController,
            cursorColor: Colors.indigo,
            autocorrect: true,
            textAlignVertical: TextAlignVertical.center,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              final result = showSearch(
                  context: context,
                  delegate: DataSearch(filterData: widget.filter),
                  query: srcController.text);
              result.then((selval) {
                if (selval != null) {
                  var selData = selval.split('_');
                  if (this.mounted) {
                    setState(() {
                      srcController.text = selData[0];
                      widget.filter?.addAll({
                        'keyword': {
                          'title': selData[0],
                          'type': selData[1],
                        },
                      });
                      selectedCity = srcController.text;
                    });
                  }
                }
              });
            },
            onChanged: (String val) {}),
      ]),
    ));
  }
}
