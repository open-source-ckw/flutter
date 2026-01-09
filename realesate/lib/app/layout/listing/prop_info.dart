import 'package:flutter/material.dart';

class PropertyInfo extends StatelessWidget {
  Map<String, dynamic> mapData = {};

  PropertyInfo(this.mapData, {Key? key}) : super(key: key);

  Widget emptyBox() {
    return new SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    String mls = this.mapData['MLS_NUM'];
    String address = this.mapData['Address'];
    String city = this.mapData['CityName'];
    String zipcode = this.mapData['ZipCode'];
    String country = this.mapData['County'];
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              'Property Information',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              (mapData['MLS_NUM'].isNotEmpty)
                  ? getRow('MLS# : ', mls)
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              (mapData['Subdivision'].isNotEmpty)
                  ? getRow('Community: ', mapData['Subdivision'])
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              (mapData['TotalAcreage'].isNotEmpty)
                  ? getRow('Total Acreage: ', mapData['TotalAcreage'])
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              (mapData['Address'].isNotEmpty)
                  ? getRow('Address: ', address)
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              (mapData['CityName'].isNotEmpty)
                  ? getRow('City: ', city)
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              (mapData['ListPrice'].isNotEmpty)
                  ? getRow('Price: ', mapData['ListPrice'])
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              (mapData['PropertyType'].isNotEmpty)
                  ? getRow('Property Type: ', mapData['PropertyType'])
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              (mapData['YearBuilt'].isNotEmpty)
                  ? getRow('Built In: ', mapData['YearBuilt'])
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              (mapData['ZipCode'].isNotEmpty)
                  ? getRow('Postal Code: ', zipcode)
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              (mapData['County'].isNotEmpty)
                  ? getRow('County: ', country)
                  : SizedBox(
                      height: 0,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getRow(String title, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
