import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stacks/controller/home_controller.dart';
import 'package:stacks/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/buttons/star_ratings.dart';

class FullView extends StatefulWidget {
  final String id;

  const FullView({Key? key, required this.id}) : super(key: key);

  @override
  _FullViewState createState() => _FullViewState();
}

class _FullViewState extends State<FullView> {
  HomeController fullViewController = Get.put(HomeController());

  @override
  void initState() {
    fullViewController.getSharedText();
    fullViewController.receiveShareIntent();

    Future.delayed(
        Duration.zero,
            () => fullViewController.getLinkDetails(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Obx(() {
          return (fullViewController.loading) ?  _noData() : _pageBody();
        }),
      ),
    );
  }

  Widget _pageBody() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          pinned: true,
          floating: false,
          collapsedHeight: 70.0,
          expandedHeight: 80.0,
          flexibleSpace: Container(
            width: double.infinity,
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x59a1b3cc),
                  blurRadius: 15,
                  offset: Offset(0, 0),
                ),
              ],
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () async {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(0xffB1BECC),
                    )),

                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      fullViewController.linkDetails['title'] != null && fullViewController.linkDetails['title'] != "" ? fullViewController.linkDetails['title'] : '',
                      style: TextStyle(
                        color: Color(0xff002347),
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await fullViewController.deleteLinks(id: widget.id);
                      //print(fullViewController.deleteLink);
                      //Get.back();
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      color: Color(0xffB1BECC),
                    )),
              ],
            ),
          ),
        ),
        _fullImage(),
        _description()
      ],
    );
  }

  Widget _fullImage() {
    return (fullViewController.linkDetails['image_url'] != null)
        ? SliverToBoxAdapter(
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: fullViewController.linkDetails['image_url'],
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          )
        : SliverToBoxAdapter(child: Container(height: 300, alignment: Alignment.center, child: Text('No image!'),));
  }

  Widget _description() {
    return fullViewController.loading
        ? Container()
        : SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        fullViewController
                            .linkDetails['favicon_url'] != null ?
                        Container(
                          width: 18,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          //child: FlutterLogo(size: 12),
                          child: CachedNetworkImage(
                            imageUrl: fullViewController
                                .linkDetails['favicon_url'],
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => SizedBox(),
                            fit: BoxFit.contain,
                          ),
                        ) : SizedBox(),
                        SizedBox(width: 5),
                        fullViewController
                            .linkDetails['target_url'] != null ?
                        Expanded(
                          child: Text(
                            Uri.parse(fullViewController
                                    .linkDetails['target_url'])
                                .host,
                            style: TextStyle(
                              color: Color(0xffb0becc),
                              fontSize: 12,
                            ),
                          ),
                        ) : SizedBox(),
                        fullViewController.linkDetails['updated_at'] != null ?
                        Expanded(
                          child: Text(
                            'Added on ' +
                                DateFormat('dd MMM yyyy').format(DateTime.parse(fullViewController.linkDetails['updated_at'])),
                            style: TextStyle(
                                color: Color(0xffb0becc), fontSize: 12),
                            textAlign: TextAlign.end,
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                  fullViewController.linkDetails['title'] != null ?
                  Container(
                    child: Text(
                      fullViewController.linkDetails['title'],
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ) : SizedBox(),
                  fullViewController.linkDetails['rating'] != null ?
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: StarRating(
                      onRatingChanged: () {},
                      rating: fullViewController.linkDetails['rating']['average_rating'],
                    ),
                  ) : SizedBox(),
                 /* Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 18,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 25,
                            color: Color(0xffb0becc),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            '3900 E Hwy 66, Gallup, NM 87301, USA',
                            //Uri.parse(this.link).host,
                            style: TextStyle(
                              color: Color(0xffb0becc),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),*/
                  Container(
                    height: 120,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(right: 20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3fb0becc),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      /*borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),*/
                                      color: Color(0xffffe3e3),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 81,
                                    height: 118,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                      ),
                                    ),
                                    child: FlutterLogo(size: 81),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  fullViewController.linkDetails['description'] != null ?
                  Container(
                    child: Text(
                      fullViewController.linkDetails['description'],
                      textAlign: TextAlign.justify,
                    ),
                  ) : SizedBox(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: TextButton(
                        child: Text("visit website".toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(15)),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff56d3d2)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: Color(0xff56d3d2))))),
                        onPressed: () async {
                          await canLaunch(
                                  fullViewController.linkDetails['target_url'])
                              ? await launch(
                                  fullViewController.linkDetails['target_url'])
                              : throw 'Could not launch ${fullViewController.linkDetails['target_url']}';
                        }),
                  )
                ],
              ),
            ),
          );
  }

  Widget _noData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("images/stacks-gray-logo.png", height: 200, width: 100),
          Text(
            fullViewController.loading == false ? "No Stacks added yet!" : "Loading Stacks",
            style: TextStyle(
              color: headingColor,
              fontSize: 14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
