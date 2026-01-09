import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:stacks/consts.dart';
import 'package:stacks/controller/home_controller.dart';
import 'package:stacks/theme/app_colors.dart';
import 'package:stacks/view/widgets/buttons/star_ratings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fullview.dart';

class RecordList extends StatelessWidget {
  final String id;
  final double rating;
  final String title;
  final String link;
  final String date;
  final String imageUrl;
  final String faviconUrl;

  RecordList({
    Key? key,
    this.rating = 0,
    required this.id,
    required this.title,
    required this.link,
    required this.date,
    required this.imageUrl,
    required this.faviconUrl,
  }) : super(key: key);

  HomeController deleteLinkController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.to(FullView(id: id,));
        //await canLaunch(this.link) ? await launch(this.link) : throw 'Could not launch ${this.link}';
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///
              /// Image
              Container(
                //height: 100,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: this.imageUrl,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(width: 8),

              Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///
                    /// Date
                    Text(
                      //dateFormat.format(this.date),
                      DateFormat('dd MMM yyyy').format(DateTime.parse(this.date)),
                      style: TextStyle(
                        color: Color(0xffb0becc),
                        fontSize: 11,
                      ),
                    ),

                    SizedBox(height: 2),

                    ///
                    /// Card Title
                    Container(
                      width: Get.width * 0.45,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              this.title,
                              style: TextStyle(
                                color: Color(0xff002347),
                                fontSize: 14,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 4),

                    /// Rating
                    StarRating(onRatingChanged: () {  }, rating: rating),
                    SizedBox(height: 10),

                    ///
                    /// Link
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 11,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            //child: FlutterLogo(size: 8),
                            child: CachedNetworkImage(
                              imageUrl: this.faviconUrl,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => SizedBox(),
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            Uri.parse(this.link).host,
                            style: TextStyle(
                              color: Color(0xffb0becc),
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),

              SizedBox(width: 2),

              ///
              /// More info button
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Share.share('check out my website ${this.link}', subject: 'Look what I made!');
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xffb0becc),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10,),
                        child: Image.asset('images/share.png', color: Color(0xffb0becc), height: 10.0,)
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  InkWell(
                    onTap: () async {
                      await deleteLinkController.deleteLinks(id: this.id);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xffb0becc),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10,),
                        child: Image.asset('images/delete-icon.png', color: Color(0xffb0becc), height: 10.0,)
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  InkWell(
                    onTap: () async {
                      await canLaunch(this.link) ? await launch(this.link) : throw 'Could not launch ${this.link}';
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xff56d3d2),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10,),
                        child: Image.asset('images/info-icon.png', color:  Color(0xff56d3d2), height: 10.0,)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
