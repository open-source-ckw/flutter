import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '/app/core/get_data.dart';
import 'listing_details.dart';
import '../../core/global.dart' as global;
import 'package:intl/intl.dart' as intl;

class ListingBox extends StatefulWidget {
  final data;
  double? fontSize;
    ListingBox({Key? key, required this.data,this.fontSize}) : super(key: key);

  @override
  _ListingBoxState createState() => _ListingBoxState();
}

class _ListingBoxState extends State<ListingBox> {
  final formatter = intl.NumberFormat("#,##0");
  SearchResult objUData = SearchResult();
  Map<String, dynamic>? userFavoriteProp;
  int id = 0;

  @override
  Widget build(BuildContext context) {
    var listPrice = formatter.format(double.parse(widget.data['ListPrice'].toString()));
    var pImg = (widget.data['Main_Photo_Url'] != null) ? widget.data['Main_Photo_Url'] : global.mapConfige['img_na_property'];

    return GestureDetector(
      onTap: (){
        PersistentNavBarNavigator.pushNewScreen(context,
            withNavBar: false,
            screen: DetailScreen(listingKey: widget.data['ListingID_MLS']));
      },
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3.0,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: pImg,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)),
                    errorWidget: (context, url, error) =>
                        CachedNetworkImage(
                          imageUrl: global.mapConfige['img_na_property'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      gradient: LinearGradient(
                        begin: FractionalOffset.center,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.black,
                        ],
                        stops: const [
                          0.0,
                          1.0
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                        children:[
                          widget.data['Sold_Price'] != ''?
                          Container(
                            color: (widget.data['status'] == 'closed')?Colors.red:Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                            child: Text((widget.data['Sold_Price'] != '')?'Sold':'FOR SALE', style: const TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),),
                          ):
                          Container(
                            color: (widget.data['Sold_Price'] != '')?Colors.red:Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                            child: Text((widget.data['Sold_Price'] != '')?'For Rent':'FOR SALE', style: const TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),),
                          )
                        ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text("\$$listPrice", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: widget.fontSize),),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                            color: Theme.of(context).primaryColor,
                            child: Text(widget.data['PropertyType']??'', style: TextStyle(color: Colors.white,fontSize: widget.fontSize),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              "${widget.data['Address']}",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: widget.fontSize),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0, bottom: 5.0),
                            child: Text(
                              "${widget.data['CityName']}, ${widget.data['State']} - ${widget.data['ZipCode']}",
                              style: TextStyle(color: Colors.white,fontSize: widget.fontSize),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children:[
                              Container(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_hotel,color: Colors.white,),
                                    const SizedBox(width: 5,),
                                    Text("${widget.data['Beds']}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.fontSize,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:const EdgeInsets.only(right: 10.0),
                                child: Row(
                                    children:[
                                      const Icon(Icons.bathtub,color: Colors.white,),
                                      const SizedBox(width: 5,),
                                      Text('${widget.data['Baths']}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: widget.fontSize),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,),
                                    ]
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Row(
                                    children:[
                                      const Icon(Icons.square_foot,color: Colors.white,),
                                      const SizedBox(width: 5,),
                                      Text('${widget.data['SQFT']}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: widget.fontSize),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,),
                                    ]
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
