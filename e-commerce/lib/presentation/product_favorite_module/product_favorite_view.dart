import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/app_globals.dart' as global;
import '../internet_connectivity_module/internet_connectivity_view.dart';
import '../login_module/login_view.dart';
import '../product_box_module/controller/product_box_controller.dart';
import '../product_box_module/product_box_view.dart';
import '../product_details_module/new_product_details_view.dart';
import '../product_details_module/product_details_view.dart';
import '../search_module/search_view.dart';
import '../static_module/shimmer_view.dart';
import 'controller/product_favorite_controller.dart';

class ProductFavoriteView extends StatefulWidget {
  const ProductFavoriteView({Key? key}) : super(key: key);

  @override
  State<ProductFavoriteView> createState() => _ProductFavoriteViewState();
}

class _ProductFavoriteViewState extends State<ProductFavoriteView> {
  final productFavoriteController = Get.put(ProductFavoriteController());
  final productBoxController = Get.put(ProductBoxController());
  // create an instance
  final GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();

  @override
  void initState() {
    /*if (global.isUserData.isNotEmpty &&
        productFavoriteController.productWishList.isEmpty) {
      productBoxController.getProductWishList(global.isUserData['ID']);
    } else {
      productFavoriteController.loading.value = false;
    }*/
    super.initState();
  }

  @override
  void dispose() {
    productFavoriteController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          if (global.isLoggedIn.isTrue)
            IconButton(
              icon: FaIcon(
                (productFavoriteController.isPage.isTrue)
                    ? FontAwesomeIcons.grip
                    : FontAwesomeIcons.list,
                size: 18,
                color: Colors.black,
              ),
              onPressed: () {
                if (productFavoriteController.isPage.isTrue) {
                  productFavoriteController.isPage.value = false;
                } else {
                  productFavoriteController.isPage.value = true;
                }
              },
            ),
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  // delegate to customize the search bar
                  delegate: SearchView());
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      bottomSheet: GetBuilder<GetXNetworkManager>(builder: (builder)=> Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        child: (_networkManager.connectionType == 0) ? const Text('No Internet connection', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,) : const SizedBox(),),),
      body: Obx(() => (global.isLoggedIn.isTrue)
          ? _body()
          : _bodyLogin(),
      )
    );
  }

  _body() {
    return Obx(() => Container(
        child: (productFavoriteController.isPage.isTrue)
            ? _bodyList()
            : _bodyGrid(),
      ),
    );
  }

  _bodyGrid() {
    if(productFavoriteController.loading.isFalse){
      if(global.isWishListProduct.isNotEmpty){
        return Container(
          color: Colors.grey[100],
          child: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: pullRefresh,
            child: GridView(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                children: global.isWishListProduct.values
                    .map((key) => ProductBoxView(
                  productData: key,
                  isPage: 'Grid',
                  onProductItemTap: (onPressed) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewProductDetailsScreen(productData: onPressed),));
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsView(
                          productData: onPressed,
                        ),
                      ),
                    );*/
                  },
                )).toList()),
          ),
        );
      } else {
        return Container(
          color: Colors.grey[100],
          child: const Center(child: Text('No product found.')),
        );
      }
    }
    return const Center(child: CircularProgressIndicator(),);
  }

  _bodyList() {
    if(productFavoriteController.loading.isFalse){
      if(global.isWishListProduct.isNotEmpty){
        return Container(
          color: Colors.grey[100],
          child: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: pullRefresh,
              child: ListView(children: global.isWishListProduct.values
              .map((key) => ProductBoxView(
                productData: key,
                isPage: 'List',
                onProductItemTap: (onPressed) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewProductDetailsScreen(productData: onPressed),));
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsView(
                        productData: onPressed,
                      ),
                    ),
                  );*/
                },
              ),)
            .toList()),
          ),
        );
      } else {
        return Container(
          color: Colors.grey[100],
          child: const Center(child: Text('Your favorites list is empty.')),
        );
      }
    }
    return const Center(child: CircularProgressIndicator(),);
  }

  _bodyLogin() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enjoy your favorite list'),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(LoginView.route)?.then((value) {
                  if (value == true) {
                    if (global.isUserData.isNotEmpty) {
                      productFavoriteController.loading.value = true;
                      productBoxController.getProductWishList(global.isUserData['ID']);
                    }
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'SIGN IN',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pullRefresh() async {
    await productBoxController.getProductWishList(global.isUserData['ID']);
    await Future.delayed(const Duration(seconds: 1));
  }
}
