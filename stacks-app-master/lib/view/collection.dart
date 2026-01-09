import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacks/controller/home_controller.dart';
import 'package:stacks/theme/app_colors.dart';
import 'package:stacks/view/home.dart';
import 'package:stacks/view/search.dart';
import 'package:stacks/view/widgets/records.dart';

class CollectionPage extends StatefulWidget {
  final String stacksId;
  final String collectionText;

  CollectionPage({Key? key, required this.collectionText, required this.stacksId}) : super(key: key);
  //const CollectionPage({Key? key}) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  ScrollController _scrollController = new ScrollController();
  HomeController collectionController = Get.put(HomeController());

  @override
  void initState() {
    collectionController.getSharedText();
    collectionController.receiveShareIntent();
    Future.delayed(
        Duration.zero,
            () =>collectionController.getCollectionsLinksId(id: widget.stacksId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            /// Go to search page
            Get.to(SearchPage());
          },
          child: Icon(CupertinoIcons.search),
        ),
        body: CustomScrollView(slivers: [
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
              height: 100,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () async => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xffB1BECC),
                      )),
                  Expanded(
                    child: Text(
                      widget.collectionText.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff002347),
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async => null,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                ],
              ),
             /* child: Container(
                height: 80,
                child: Stack(
                  children: [
                    Positioned(
                      left: 15,
                      top: 30,
                      child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color(0xffB1BECC),
                          )),
                    ),
                    *//*Positioned(
                      left: Get.width * 0.42,
                      top: 40,
                      child: Text(
                        collectionText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff002347),
                          fontSize: 20,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),*//*
                    Center(
                      child: Text(
                        widget.collectionText.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff002347),
                          fontSize: 20,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ),*/
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 25),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                LayoutChangeHeader(
                  controller: collectionController,
                  title: "Filter by",
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 25),
          ),
          /*SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 18,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: EdgeInsets.only(right: 2.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0,right: 10.0),
                                child: Center(
                                  child: Text('text ${index+1}', style: TextStyle(fontWeight: FontWeight.w400),),
                                ),
                              )
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 25),
          ),*/
          Obx(() {
            return collectionController.loading
                ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: LinearProgressIndicator(
                      semanticsLabel: 'Linear progress indicator',
                    ),
              ),
            )
                : SliverToBoxAdapter(
                  child: Container(),
            );
          }),
          Obx(() {
            return collectionController.collectionsLinksId.isNotEmpty && collectionController.collectionsLinksId['links'].length > 0
                ? collectionController.isList
                ? CardsListViewSliver(links: collectionController.collectionsLinksId['links'])
                : CardsGridViewSliver(links: collectionController.collectionsLinksId['links'])
                : SliverToBoxAdapter(child: _noData());
          })
        ]),
      ),
    );
  }

  Widget _noData() {
    return Center(
      child: Column(
        children: [
          Image.asset("images/stacks-gray-logo.png", height: 200, width: 100),
          Text(
            collectionController.loading == false ? "No Stacks added yet!" : "Loading Stacks",
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

  Widget buildListViewShop() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            //title: Placeholder(fallbackHeight: 100,),
            subtitle: Text("Hello"),
          ),
        );
      },
    );
  }
}
