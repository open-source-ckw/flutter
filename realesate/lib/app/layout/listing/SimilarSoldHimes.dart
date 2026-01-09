import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'listing_box.dart';

class SimilarSoldHome extends StatelessWidget {
  List<dynamic> listSoldProperty = [];

  SimilarSoldHome(this.listSoldProperty, {Key? key}) : super(key: key);

  SimilarHomeSold(soldData) {
    List<Widget> slmSold = <Widget>[];
    soldData.forEach((slmSoldList) {
      slmSold.add(
        ListingBox(data: slmSoldList),
      );
    });
    return slmSold;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //width: 300,
      child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 1.75,
            enlargeCenterPage: true,
            viewportFraction: 0.70,
          ),
          items: SimilarHomeSold(listSoldProperty),

          ),
    );
  }
}
