import 'package:flutter/material.dart';

class Sorting extends StatefulWidget {
  Map<String, dynamic>? filter;

  Sorting({Key? key, this.filter}) : super(key: key);

  @override
  _SortingState createState() => _SortingState(this.filter);
}

class _SortingState extends State<Sorting> {
  Map<String, dynamic>? filter;

  _SortingState(this.filter);

  List listASCSortingProperty = [];
  List listDSCSortingProperty = [];
  Map mapSortOpt = {
    'price|desc': 'Price (High to Low)',
    'price|asc': 'Price (Low to High)',
    'sqft|desc': 'Sqft (High to Low)',
    'sqft|asc': 'Sqft (Low to High)',
    'beds|desc': 'Beds (High to Low)',
    'beds|asc': 'Beds (Low to High)',
    'baths|desc': 'Bath (High to Low)',
    'baths|asc': 'Bath (Low to High)',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Divider(thickness: 3.0, indent: 150.0, endIndent: 150.0,),
        Container(
          child: Text(
            'SORT BY',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: SortingData(mapSortOpt),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> SortingData(Map data) {
    List<Widget> sortData = [];
    data.forEach((key, val) {
      sortData.add(
        RadioListTile(
            value: key.toString(),
            groupValue: this.filter!['so'] + '|' + this.filter!['sd'],
            title: Text(val, style: TextStyle(color: Colors.black),),
            onChanged: (value){
              var exclude = value.toString().split('|');
              setState(() {
                this.filter!['so'] = exclude[0];
                this.filter!['sd'] = exclude[1];
                Navigator.of(context).pop(this.filter);
                //_site = value;
              });
            }),
      );
    });
    return sortData;
  }
}
