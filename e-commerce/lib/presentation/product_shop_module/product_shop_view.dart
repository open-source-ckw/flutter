import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_constant.dart';
import '../internet_connectivity_module/internet_connectivity_view.dart';
import '../product_list_module/product_list_view.dart';
import '../search_module/search_view.dart';
import '../static_module/shimmer_view.dart';
import 'controller/product_shop_controller.dart';

class ProductShopView extends StatefulWidget {
  const ProductShopView({Key? key}) : super(key: key);

  @override
  State<ProductShopView> createState() => _ProductShopViewState();
}

class _ProductShopViewState extends State<ProductShopView>
    with TickerProviderStateMixin {
  final productShopController = Get.put(ProductShopController());
  // create an instance
  final GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();

  @override
  void initState() {
    productShopController.getCategoryListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const Text(
            'Categories',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            controller: productShopController.tabController,
            tabs: productShopController.myTabs,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    // delegate to customize the search bar
                    delegate: SearchView());
              },
            )
          ],
        ),
      bottomSheet: GetBuilder<GetXNetworkManager>(builder: (builder)=> Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        child: (_networkManager.connectionType == 0) ? const Text('No Internet connection', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,) : const SizedBox(),),),
        body: Obx(
          () => (productShopController.loading.isFalse)
              ? TabBarView(
                  controller: productShopController.tabController,
                  children: productShopController.myTabs.map((Tab tab) {
                    List<dynamic> data = [];
                    if(productShopController.mapListSubCategoryData.containsKey(tab.text) == true){
                     data = productShopController.mapListSubCategoryData[tab.text];
                    }
                    return ListView(
                      padding: const EdgeInsets.all(18.0),
                      children: listSubCategoryItems(data),
                    );
                  }).toList(),
                )
              : const ShimmerList()
        ),
    );
  }

  listSubCategoryItems(data) {
    List<Widget> listSubCat = <Widget>[];
    if(productShopController.mapListSubCategoryData.isNotEmpty && data.length > 0){
      for (int i = 0;
      i < data.length;
      i++) {
        listSubCat.add(
          Card(
            elevation: 0.5,
            child: ListTile(
              minVerticalPadding: 0.0,
              contentPadding: const EdgeInsets.only(left: 20),
              onTap: () {
                Get.toNamed(ProductListView.route, arguments: {'catProductList' : data[i],'isPage' : 'category'},);
              },
              title: SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data[i]['name']
                            .toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: (data[i]
                        ['image'] !=
                            null)
                            ? data[i]
                        ['image']['src']
                            : noImg,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                                imageUrl: noImg,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } else {
      listSubCat.add(Container());
    }
    return listSubCat;
  }
}
