import 'package:flutter/material.dart';

class PropertyFeachers extends StatelessWidget {
  Map<String, dynamic> mapData = {};

  PropertyFeachers(this.mapData, {Key? key}) : super(key: key);

  Widget emptyBox() {
    return new SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    String drivingdirections = 'ABCD Avenue to DBS Ocean house on left';
    String legal = 'ABCD Beach map 1 lt 2 OR3343P56';
    String area = 'DBS Beach 3442;5678 ';
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Text(
                'Property Features',
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
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
                height: 20,
              ),
              Column(
                children: [
                  (mapData['SQFT'].isNotEmpty)
                      ? getRow('SQFT : ', mapData['SQFT'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['SubType'].isNotEmpty)
                      ? getRow('SubType : ', mapData['SubType'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Stories'].isNotEmpty)
                      ? getRow('Stories : ', mapData['Stories'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Amenities'].isNotEmpty)
                      ? getRow('Amenities : ', mapData['Amenities'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Appliances'].isNotEmpty)
                      ? getRow('Appliances : ', mapData['Appliances'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Beds'].isNotEmpty)
                      ? getRow('Bedrooms : ', mapData['Beds'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Baths'].isNotEmpty)
                      ? getRow('Bathrooms : ', mapData['Baths'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Garage'].isNotEmpty)
                      ? getRow('Garage : ', mapData['Garage'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Cooling'].isNotEmpty)
                      ? getRow('Cooling : ', mapData['Cooling'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['DrivingDirections'].isNotEmpty)
                      ? getRow('Driving Directions : ', drivingdirections)
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['ExteriorFeatures'].isNotEmpty)
                      ? getRow('Exterior : ', mapData['ExteriorFeatures'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['InteriorFeatures'].isNotEmpty)
                      ? getRow('Interior : ', mapData['InteriorFeatures'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['ParkingFeatures'].isNotEmpty)
                      ? getRow('Parking : ', mapData['ParkingFeatures'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Heating'].isNotEmpty)
                      ? getRow('Heating : ', mapData['Heating'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Water'].isNotEmpty)
                      ? getRow('Water : ', mapData['Water'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Legal'].isNotEmpty)
                      ? getRow('Legal : ', legal)
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Roof'].isNotEmpty)
                      ? getRow('Roof : ', mapData['Roof'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Area'].isNotEmpty)
                      ? getRow('Area : ', area)
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Sewer'].isNotEmpty)
                      ? getRow('Sewer : ', mapData['Sewer'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Tax'].isNotEmpty)
                      ? getRow('Gross Taxes : ', mapData['Tax'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['View'].isNotEmpty)
                      ? getRow('View : ', mapData['View'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  (mapData['Water'].isNotEmpty)
                      ? getRow('Water : ', mapData['Water'])
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  /*(mapData['SecuritySafety'].isNotEmpty) ?
                  getRow('Security And Safety : ', mapData['SecuritySafety ']):SizedBox(height: 0,),*/
                ],
              ),
            ]));
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
