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

class RecordCardText extends StatelessWidget {
  final String id;
  final double rating;
  final String title;
  final String content;
  final String date;
  final String link;
  final String faviconUrl;
  final bool onPage;

  RecordCardText({Key? key, required this.id, this.rating = 0, required this.title, required this.content, required this.date, required this.link, required this.faviconUrl, this.onPage = true})
      : super(key: key);

  HomeController deleteLinkController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.to(FullView(id: id,));
      },
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///
            /// Image
            Container(
              width: 162,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xffffb34b),
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: ShaderMask(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    this.content,
                    style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                  ),
                ),
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.transparent, Colors.white],
                  ).createShader(
                    Rect.fromLTRB(0, 0, rect.width, rect.height),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

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

            SizedBox(height: 10),

            ///
            /// Card Title
            Text(
              this.title,
              style: TextStyle(
                color: Color(0xff002347),
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
              ),
            ),

            /// Rating
            SizedBox(height: 10),
            StarRating(onRatingChanged: () {  }, rating: rating,),
            SizedBox(height: 10),

            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  this.faviconUrl != '' ?
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
                  ) : SizedBox(),
                  SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await canLaunch(this.link) ? await launch(this.link) : throw 'Could not launch ${this.link}';
                      },
                      child: Text(
                        Uri.parse(this.link).host,
                        style: TextStyle(
                          color: Color(0xffb0becc),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            ///
            /// More info button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async{
                            Share.share('check out my website ${this.link}', subject: 'Look what I made!');
                          },
                          child: Image.asset('images/share.png', color: primaryColor,),
                        ),
                        SizedBox(width: 20.0,),
                        (onPage == true) ?
                        InkWell(
                            onTap: () async {
                              await deleteLinkController.deleteLinks(id: this.id);
                            },
                            child: Image.asset('images/delete-icon.png', color: greyColor, height: 25.0,)
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () async{
                        await canLaunch(this.link) ? await launch(this.link) : throw 'Could not launch ${this.link}';
                      },
                      child: Image.asset('images/info-icon.png', color: greyColor, height: 25.0,)
                  ),
                ],
              ),
            ),
            /*Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xff56d3d2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.only(
                left: 16,
                right: 17,
                top: 5,
                bottom: 4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.info, size: 14, color: primaryColor),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "More info",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff5ed6d5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),*/

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
