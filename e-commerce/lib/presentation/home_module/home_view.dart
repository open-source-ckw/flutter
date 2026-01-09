import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_constant.dart';
import '../internet_connectivity_module/internet_connectivity_view.dart';
import '../product_box_module/product_box_view.dart';
import '../product_details_module/new_product_details_view.dart';
import '../product_list_module/product_list_view.dart';
import '../search_module/search_view.dart';
import '../static_module/shimmer_view.dart';
import 'controller/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = Get.put(HomeController());

  // create an instance
  final GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();

  @override
  void initState() {
    homeController.getCartList();
    homeController.getCategoryImages();
    homeController.getNewProduct();
    homeController.getAllProducts();
    homeController.getTrendProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomSheet: GetBuilder<GetXNetworkManager>(
        builder: (builder) => Container(
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          child: (_networkManager.connectionType == 0)
              ? const Text(
                  'No Internet connection',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )
              : const SizedBox(),
        ),
      ),
      body: _body(),
    );
  }

  _body(){
    return CustomScrollView(
      slivers: [
        // Add the app bar to the CustomScrollView.
        SliverAppBar(
          //pinned: true,
          // Provide a standard title.
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10.0),
                  /*image: const DecorationImage(
                    image: NetworkImage('https://cloud.thatsend.work/storage/logos/app/logo.png?v=1680701109',)
                  )*/
                ),
                padding: const EdgeInsets.all(10.0),
                //child: Image.network('https://www.eidparry.com/wp-content/uploads/2022/11/flipkart-logo.png', width: 50, height: 30,),
                child: Image.asset('assets/logo.png',
                    height: 30,
                    width: 30,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  splashRadius: 1.0,
                  icon: const Icon(Icons.search,),
                  onPressed: () {
                    showSearch(
                        context: context,
                        // delegate to customize the search bar
                        delegate: SearchView());
                  },
                )
              ),
              /*Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    //Image.network('https://www.thatsend.com/wp-content/uploads/2021/03/thatsend-logo-50-new.svg', width: 30, height: 20,),
                    Image.asset('assets/logo.png',
                        height: 30,
                        width: 30),
                    SizedBox(width: MediaQuery.of(context).size.width / 3),
                    IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 30,
                      splashRadius: 1.0,
                      icon: const Icon(Icons.search,),
                      onPressed: () {
                        showSearch(
                            context: context,
                            // delegate to customize the search bar
                            delegate: SearchView());
                      },
                    )
                  ],
                ),
              ),*/
            ],
          ),
          // Allows the user to reveal the app bar if they begin scrolling
          // back up the list of items.
          floating: false,
          // Display a placeholder widget to visualize the shrinking size.
          flexibleSpace: FlexibleSpaceBar(
            //title: Text('Available seats', style: TextStyle(color: Colors.black26),),
            background: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.height * 0.80,
              child: Stack(children: [
                Obx(
                      () => CarouselSlider(
                    items: homeController.listCategoryImages
                        .map(
                          (item) => Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: item['image']['src'],
                            imageBuilder: (context, imageProvider) => Container(
                              /*foregroundDecoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      end: const Alignment(0.0, -1),
                                      begin: const Alignment(0.0, 1.5),
                                      colors: <Color>[
                                        const Color(0x8A000000),
                                        Colors.black12.withOpacity(0.0)
                                      ],
                                    ),
                                  ),*/
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                CachedNetworkImage(
                                  imageUrl: noImg,
                                ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30.0, horizontal: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'].toUpperCase(),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey.shade200, fontWeight: FontWeight.w900, ),
                                    /*style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        //fontFamily: 'Schuyler',
                                    ),*/
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Text(
                                    item['description'],
                                    //style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade400,),
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).toList(),
                    carouselController: homeController.controller,
                    options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 1.0,
                        height: MediaQuery.of(context).size.height,
                        onPageChanged: (index, reason) {
                          homeController.currentPosition.value = index;
                        }),
                  ),
                ),
                Obx(() => Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: homeController.listCategoryImages
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return GestureDetector(
                                  onTap: () => homeController.controller
                                      .animateToPage(entry.key),
                                  child: Container(
                                    width: homeController
                                        .currentPosition.value ==
                                        entry.key
                                        ? 16.0
                                        : 6,
                                    height: 6.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      //shape: BoxShape.circle,
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        color: (Theme.of(context)
                                            .brightness ==
                                            Brightness.light
                                            ? Colors.white
                                            : Colors.black)
                                            .withOpacity(homeController
                                            .currentPosition
                                            .value ==
                                            entry.key
                                            ? 0.9
                                            : 0.4)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ]),
                  ),
                )
              ]),
            ),
          ),
          // Make the initial height of the SliverAppBar larger than normal.
          expandedHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        // Next, create a SliverList
        SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildBuilderDelegate(
            // The builder function returns a ListTile with a title that
            // displays the index of the current item.
                (context, index) => productListing(),
            // Builds 1000 ListTiles
            childCount: 1,
          ),
        ),
      ],
    );
  }

  _bodyOld() {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: homeController.pullRefresh,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        //physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.height * 0.80,
              child: Stack(children: [
                Obx(
                  () => CarouselSlider(
                    items: homeController.listCategoryImages
                        .map(
                          (item) => Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: item['image']['src'],
                                imageBuilder: (context, imageProvider) => Container(
                                  /*foregroundDecoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      end: const Alignment(0.0, -1),
                                      begin: const Alignment(0.0, 1.5),
                                      colors: <Color>[
                                        const Color(0x8A000000),
                                        Colors.black12.withOpacity(0.0)
                                      ],
                                    ),
                                  ),*/
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    CachedNetworkImage(
                                  imageUrl: noImg,
                                ),
                              ),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30.0, horizontal: 20.0),
                                  child: Text(
                                    item['name'],
                                    style: TextStyle(
                                    color: Colors.grey.shade200,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                    carouselController: homeController.controller,
                    options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 1.0,
                        height: MediaQuery.of(context).size.height,
                        onPageChanged: (index, reason) {
                          homeController.currentPosition.value = index;
                        },
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: homeController.listCategoryImages
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return GestureDetector(
                                  onTap: () => homeController.controller
                                      .animateToPage(entry.key),
                                  child: Container(
                                    width: homeController
                                                .currentPosition.value ==
                                            entry.key
                                        ? 16.0
                                        : 6,
                                    height: 6.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        //shape: BoxShape.circle,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: (Theme.of(context)
                                                        .brightness ==
                                                    Brightness.light
                                                ? Colors.white
                                                : Colors.black)
                                            .withOpacity(homeController
                                                        .currentPosition
                                                        .value ==
                                                    entry.key
                                                ? 0.9
                                                : 0.4)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ]),
                  ),
                )
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            productListing(),
          ],
        ),
      ),
    );
  }

  Widget productListing(){
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              'New',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black)
            ),
            const Spacer(),
            TextButton(
              child: Text(
                "View all",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black)
              ),
              onPressed: () {
                Get.toNamed(
                  ProductListView.route,
                  arguments: {'isPage': 'New'},
                );
                /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListings(
                                isPage: 'New'
                            ),
                          ),
                        ).then((value) {
                          if(mounted) {
                            setState(() {});
                          }
                        });*/
              },
            ),
          ]),
          const SizedBox(
            height: 4,
          ),
          Text(
            "You've never seen it before!",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Obx(() {
              if (homeController.listNewProductData.isNotEmpty) {
                return ListView.builder(
                    itemCount: homeController.listNewProductData
                        .getRange(0, 5)
                        .length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: ProductBoxView(
                          productData:
                          homeController.listNewProductData[index],
                          isPage: 'Grid',
                          onProductItemTap: (onPressed) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewProductDetailsScreen(
                                      productData: onPressed,
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    });
              } else {
                return const ShimmerHomeGrid();
              }
            }),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(children: [
            Text(
              'Trendy',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black)
              /*style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 30),*/
            ),
            const Spacer(),
            TextButton(
              child: Text(
                "View all",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black)
              ),
              onPressed: () {
                Get.toNamed(
                  ProductListView.route,
                  arguments: {'isPage': 'Trendy'},
                );
              },
            ),
          ]),
          const SizedBox(
            height: 5,
          ),
          Text(
            "You've never seen it before! ",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Obx(() {
              if (homeController.listTrendProductData.isNotEmpty) {

                return ListView.builder(
                    itemCount: homeController.listTrendProductData
                        .getRange(0, 5)
                        .length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: ProductBoxView(
                          productData: homeController
                              .listTrendProductData[index],
                          isPage: 'Grid',
                          onProductItemTap: (onPressed) {
                            print('---- object ---');

                            /*Get.to(() =>
                                ProductDetailsView(
                                  productData: onPressed,
                                ),
                              //popGesture: true,
                              preventDuplicates: false,
                            );*/

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewProductDetailsScreen(
                                      productData: onPressed,
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    });
              } else {
                return const ShimmerHomeGrid();
              }
            }),
          ),
        ],
      ),
    );
  }
}
