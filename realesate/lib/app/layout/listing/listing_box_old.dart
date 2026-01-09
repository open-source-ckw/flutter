import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'listing_details.dart';
import '../../core/global.dart' as global;
import 'package:intl/intl.dart' as intl;

class ListingBox extends StatefulWidget {
  final data;
  double? Fontsize;

  ListingBox({Key? key, required this.data, this.Fontsize}) : super(key: key);

  @override
  _ListingBoxState createState() => _ListingBoxState();
}

class _ListingBoxState extends State<ListingBox> {
  final formatter = new intl.NumberFormat("#,##0");
  List<String> listRandomAdd = [
    '936 Kiehn Route, West Ned',
    '4059 Carling Avenue, Ottawa',
    '60 Caradon Hill, Ugglebarnby',
    '289 Mohr Heights, Aprilville',
    '15 Sellamuttu Avenue, 03, Colombo',
    'Avenida Mireia, 5, Los Verdugo de San Pedro',
    'Boulevard Ceulemans 832, Hannut',
    '3064 Schinner Village Suite 621, South Raymond',
    'Thorsten-Busse-Platz 4, Friedrichsdorf'
  ];

  String randomPropAdd = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomPropAdd = listRandomAdd[Random().nextInt(listRandomAdd.length)];
  }

  @override
  Widget build(BuildContext context) {
    var List_price = formatter.format(
      double.parse(
        widget.data['ListPrice'].toString(),
      ),
    );
    var p_img = (widget.data['Main_Photo_Url'] != null)
        ? widget.data['Main_Photo_Url']
        : global.mapConfige['img_na_property'];

    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: DetailScreen(
            listingKey: widget.data['ListingID_MLS'],
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(p_img), // AssetImage('assets/img-3.jpg'),
            fit: BoxFit.cover,
            onError: (Object, StackTrace){
              print('--- Object ---');
              print(Object);
              print(StackTrace);
            }
          ),
        ),*/
        height: MediaQuery.of(context).size.height / 3.0,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.black,
                  ],
                  stops: [
                    0.3, //0.0
                    1.0
                  ],),),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: p_img,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      CachedNetworkImage(
                        imageUrl: p_img,
                      ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(children: [
                    widget.data['Sold_Price'] != ''
                        ? Container(
                            color: (widget.data['status'] == 'closed')
                                ? Colors.red
                                : Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 3.0),
                            child: Text(
                              (widget.data['Sold_Price'] != '')
                                  ? 'Sold'
                                  : 'FOR SALE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(
                            color: (widget.data['Sold_Price'] != '')
                                ? Colors.red
                                : Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 3.0),
                            child: Text(
                              (widget.data['Sold_Price'] != '')
                                  ? 'For Rent'
                                  : 'FOR SALE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                  ]),
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              "\$\ ${List_price}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 3.0),
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              widget.data['PropertyType'] ?? '',
                              style: Theme.of(context).textTheme.titleMedium,
                              //style: TextStyle(color: Color(0xFF2a5537)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              widget.data['Address'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 0.0, bottom: 5.0),
                            child: Text(
                              "${widget.data["CityName"]} - ${widget.data['ZipCode']}",
                              style: TextStyle(color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_hotel,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "${widget.data['Beds']}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.bathtub,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '${widget.data['Baths']}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ]),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '${widget.data['SQFT']}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ]),
                              )
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
