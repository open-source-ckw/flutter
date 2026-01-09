import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacks/controller/home_controller.dart';
import 'package:stacks/controller/profile_controller.dart';
import 'package:stacks/theme/app_colors.dart';
import 'package:stacks/view/search.dart';
import 'package:stacks/view/widgets/buttons/button_grid.dart';
import 'package:stacks/view/widgets/buttons/button_list.dart';
import 'package:stacks/view/widgets/buttons/button_refresh.dart';
import 'package:stacks/view/widgets/collection_card.dart';
import 'package:stacks/view/widgets/menu/top_menu.dart';
import 'package:stacks/view/widgets/records.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController controller = Get.put(HomeController());
  ProfileController profileController = Get.put(ProfileController())!;

  @override
  void initState() {
    controller.getSharedText();
    controller.receiveShareIntent();
    //controller.getLinks();
    //controller.getCollectionsLinks();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.isClosed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          /// Go to search page
          Get.to(SearchPage());
        },
        child: Icon(CupertinoIcons.search),
      ),
      bottomNavigationBar: BottomMenu(),
      body: _notificationListener(_pageBody()),
    );
  }

  Widget _pageBody() {
    return CustomScrollView(slivers: [
      /// Top Menu
      TopMenu(),

      /// Page title
      SliverToBoxAdapter(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My list",
                    style: TextStyle(
                      color: headingColor,
                      fontSize: 20,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

      /// List view horizontal scroll
      Obx(() {
        return controller.loading
            ? SliverToBoxAdapter(
                child: Container(
                  height: 182,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CollectionCard(
                        stacksId: "",
                        text: "",
                        image: "",
                        imageSecond: "",
                        imageThird: "",
                      ),
                      CollectionCard(
                        stacksId: "",
                        text: "",
                        image: "",
                        imageSecond: "",
                        imageThird: "",
                      ),
                      CollectionCard(
                        stacksId: "",
                        text: "",
                        image: "",
                        imageSecond: "",
                        imageThird: "",
                      ),
                      CollectionCard(
                        stacksId: "",
                        text: "",
                        image: "",
                        imageSecond: "",
                        imageThird: "",
                      ),
                    ],
                  ),
                ),
              )
            : (controller.collectionsLinks.isNotEmpty == true)
                ? SliverToBoxAdapter(
                    child: Container(
                      height: 182,
                      margin: EdgeInsets.only(bottom: 20),
                      child: ListView.builder(
                        itemCount: controller.collectionsLinks.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CollectionCard(
                            stacksId: controller.collectionsLinks[index]['id'],
                            text: controller.collectionsLinks[index]['name'],
                            image: controller.collectionsLinks[index]['links'].length > 0 ? controller.collectionsLinks[index]['links'][0]['image_url'] : '',
                            imageSecond: controller.collectionsLinks[index]['links'].length > 1 ? controller.collectionsLinks[index]['links'][1]['image_url'] : '',
                            imageThird: controller.collectionsLinks[index]['links'].length > 2 ? controller.collectionsLinks[index]['links'][2]['image_url'] : '',
                          );
                        },
                      ),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Container(
                      height: 182,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Center(child: Text('No data found.')),
                  ));
      }),

      /*SliverToBoxAdapter(
        child: Container(
          height: 182,
          margin: EdgeInsets.only(bottom: 20),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CollectionCard(
                text: "Links",
              ),
              CollectionCard(
                text: "Lorem Ipsum",
              ),
              CollectionCard(
                text: "Doler Amiet",
              ),
              CollectionCard(
                text: "Besdic Bmus",
              ),
            ],
          ),
        ),
      ),*/

      /// Recently Saved section Title Grid and List Toggle
      SliverToBoxAdapter(
        child: Column(
          children: [
            SizedBox(height: 20),
            LayoutChangeHeader(controller: controller),
            SizedBox(height: 20),
          ],
        ),
      ),

      Obx(() {
        return controller.loading
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

      /*Obx((){
        print('--------- 1 ----------------');
        //print(controller.links);
        controller.printWrapped(controller.links.toString());
        print('--------- END ----------------');
        return SliverToBoxAdapter(child: _noData());
      }),*/

      Obx(() {
        return controller.links.isNotEmpty && controller.links.length > 0
            ? controller.isList
                ? CardsListViewSliver(links: controller.links)
                : CardsGridViewSliver(links: controller.links)
            : SliverToBoxAdapter(child: _noData());
      }),
    ]);
  }

  Widget _noData() {
    return Center(
      child: Column(
        children: [
          Image.asset("images/stacks-gray-logo.png", height: 200, width: 100),
          Text(
            controller.loading == false
                ? "No Stacks added yet!"
                : "Loading Stacks",
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

  _notificationListener(Widget child) {
      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical &&
            notification.metrics.pixels ==
                notification.metrics.maxScrollExtent &&
            notification.metrics.atEdge) {
          // if current page == 0 then that means there is no data on the server to load.
          if (!controller.loading && controller.currentPage != 0) {
            controller.currentPage = controller.currentPage + 1;
            controller.getLinks();
            controller.getCollectionsLinks();
          }
        }
        return true;
      },
        child: child,
    );
  }
}

class LayoutChangeHeader extends StatefulWidget {
  const LayoutChangeHeader({
    Key? key,
    required this.controller,
    this.title = "Recently saved",
  }) : super(key: key);

  final HomeController controller;
  final String title;

  @override
  _LayoutChangeHeaderState createState() => _LayoutChangeHeaderState();
}

class _LayoutChangeHeaderState extends State<LayoutChangeHeader> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: headingColor,
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(child: Container()),
          ButtonRefresh(onTap: () async {
            //widget.controller.links = [];
            await widget.controller.getLinks(true);
            //widget.controller.obs.refresh();
            //widget.controller.update();
          }),
          SizedBox(width: 30),
          ButtonList(onTap: () {
            if (this.mounted) {
              setState(() {
                widget.controller.changeView(0);
              });
            }
          }),
          SizedBox(width: 10),
          ButtonGrid(onTap: () {
            if (this.mounted) {
              setState(() {
                widget.controller.changeView(1);
              });
            }
          }),
        ],
      ),
    );
  }
}

/*class LayoutChangeHeader extends StatelessWidget {
  const LayoutChangeHeader({
    Key? key,
    required this.controller,
    this.title = "Recently saved",
  }) : super(key: key);

  final HomeController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            this.title,
            style: TextStyle(
              color: headingColor,
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(child: Container()),
          ButtonRefresh(onTap: () async {
            await controller.getLinks();
          }),
          SizedBox(width: 30),
          ButtonList(onTap: () {
            controller.changeView(0);
          }),
          SizedBox(width: 10),
          ButtonGrid(onTap: () {
            controller.changeView(1);
          }),
        ],
      ),
    );
  }
}*/
