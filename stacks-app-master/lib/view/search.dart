import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacks/controller/home_controller.dart';
import 'package:stacks/theme/app_colors.dart';

import 'widgets/records.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  HomeController searchController = Get.put(HomeController());
  int activeIcon = 0;

  @override
  void initState() {
    //searchController.getSharedText();
    //searchController.receiveShareIntent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //searchController.searchLinks.map((e) => print(e));
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: CustomScrollView(slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            pinned: true,
            floating: false,
            collapsedHeight: 80.0,
            expandedHeight: 100.0,
            flexibleSpace: Container(
              width: double.infinity,
              height: 120,
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
              child: Container(
                height: 100,
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
                    Positioned(
                      left: Get.width * 0.42,
                      top: 40,
                      child: Text(
                        "Search",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff002347),
                          fontSize: 20,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 25),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: CupertinoTextField(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  //border: Border.all(color: Color(0xffffb34b), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                prefix: Container( padding :  EdgeInsets.only(left: 20), child: Icon(Icons.search, color: activeIcon > 0 ? Color(0xff5ed6d5) : Colors.black,),),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                placeholder: "Search...",
                style: TextStyle(color: Colors.black),
                padding: EdgeInsets.all(15),
                clearButtonMode: OverlayVisibilityMode.editing,
                // onChanged: (val) {
                //   if (val == "") {
                //     controller.clear();
                //   }
                //   print(controller.text);
                // },
                onChanged: (val) async {
                  if(this.mounted){
                    setState(() {
                      activeIcon = val.length;
                    });
                  }
                  if(val.length >= 4){
                    await searchController.getSearchLinks(passQueryString: val);
                  }

                  if(val == ""){
                    searchController.searchLinks.clear();
                  }
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 25),
          ),
          Obx(() {
            return searchController.searchLinks.isNotEmpty && searchController.searchLinks.length > 0
                ? searchController.isList
                ? SliverToBoxAdapter(child: _noData())
                : CardsGridViewSliver(links: searchController.searchLinks, onPage: false)
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
            searchController.loading == false ? "No Stacks added yet!" : "Loading Stacks",
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
