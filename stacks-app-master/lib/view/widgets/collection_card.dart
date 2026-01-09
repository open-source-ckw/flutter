import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacks/view/collection.dart';

class CollectionCard extends StatelessWidget {
  final String stacksId;
  final String text;
  final String image;
  final String imageSecond;
  final String imageThird;

  const CollectionCard({Key? key,required this.stacksId, required this.text, required this.image, required this.imageSecond, required this.imageThird,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      margin: EdgeInsets.only(left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              /// Go to collection page
              Get.to(CollectionPage(collectionText: text, stacksId: stacksId));
            },
            child: Container(
              width: 162,
              height: 162,
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
                  Positioned(
                    left: 15,
                    top: 131,
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                        color: Color(0xffb0becc),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 162,
                        height: 118,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                          color: Color(0xffffe3e3),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 81,
                        height: 59,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                          color: Color(0xfffff2f2),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 81,
                        height: 59,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        child: imageSecond != '' ? CachedNetworkImage(
                          imageUrl: this.imageSecond,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.fill,
                        )
                            : FlutterLogo(size: 59),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 81,
                    top: 59,
                    child: Container(
                      width: 81,
                      height: 59,
                      child: imageThird != '' ? CachedNetworkImage(
                        imageUrl: this.imageThird,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.fill,
                      )
                          : FlutterLogo(size: 59),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
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
                        //child: FlutterLogo(size: 81),
                        child: image != '' ? CachedNetworkImage(
                          imageUrl: this.image,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.fill,
                        )
                        : FlutterLogo(size: 81),
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
