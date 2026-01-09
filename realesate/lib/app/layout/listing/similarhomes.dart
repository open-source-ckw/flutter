import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'listing_box.dart';

class SimilarHomes extends StatelessWidget {
  List<dynamic> listSimilarProperty = [];

  SimilarHomes(this.listSimilarProperty, {Key? key}) : super(key: key);

  SimilarHome(data) {
    List<Widget> dls = <Widget>[];
    data.forEach((similarList) {
      dls.add(
        ListingBox(
          data: similarList,
          fontSize: 10,
        ),
      );
    });
    return dls;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: true,
          aspectRatio: 1.75,
          viewportFraction: 0.70,
        ),
        items: SimilarHome(listSimilarProperty), //imgSlider(),
      ),
    );
  }
}
