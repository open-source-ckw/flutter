import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:stacks/consts.dart';
import 'package:stacks/controller/home_controller.dart';
import 'package:stacks/theme/app_colors.dart';
import 'package:stacks/view/fullview.dart';
import 'package:stacks/view/widgets/buttons/star_ratings.dart';
import 'package:url_launcher/url_launcher.dart';

class RecordCardMap extends StatelessWidget {
  final String id;
  final double rating;
  final String title;
  final String link;
  final String date;
  final String imageUrl;
  final String faviconUrl;

   RecordCardMap({
    Key? key,
    required this.id,
    this.rating = 0,
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
      onTap: ()  {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FullView(id: id,)),
        );
      },
      child: Container(
        padding: EdgeInsets.only(right: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Image
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: this.imageUrl,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fitWidth
                ),
              ),
            ),

            SizedBox(height: 5),

            /// Date
            Text(
              //dateFormat.format(this.date),
              DateFormat('dd MMM yyyy').format(DateTime.parse(this.date)),
              style: TextStyle(
                color: Color(0xffb0becc),
                fontSize: 11,
              ),
            ),

            SizedBox(height: 5),

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
            (rating != 0.0) ? SizedBox(height: 5) : SizedBox(),
            StarRating(onRatingChanged: () {  }, rating: rating),
            (rating != 0.0) ? SizedBox(height: 5) : SizedBox(),

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

            SizedBox(height: 5),

            /// More info button
            Container(
              width: MediaQuery.of(context).size.width,
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
                        /*SizedBox(width: 20.0,),
                        InkWell(
                            onTap: () async {
                              await deleteLinkController.deleteLinks(id: this.id);
                            },
                            child: Image.asset('images/delete-icon.png', color: greyColor, height: 25.0,)
                        ),*/
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
          ],
        ),
      ),
    );
  }
}
