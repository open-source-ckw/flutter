import 'package:fashionia/presentation/product_details_module/new_product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../core/app_constant.dart';
import '../product_box_module/product_box_view.dart';
import '../product_filter_module/product_filter_view.dart';
import '../search_module/search_view.dart';
import '../static_module/shimmer_view.dart';
import 'controller/product_list_controller.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({Key? key}) : super(key: key);
  static const route = '/product_list_view';

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>
    with TickerProviderStateMixin {
  final productListController = Get.put(ProductListController());
  final passParameter = Get.arguments;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      checkedFilters();
    });
    super.initState();
  }

  checkedFilters() {
    print('------------ checkedFilters ------------ ');
    productListController.loading.value = true;
    var listKey =
        productListController.sortListMap['sort_by'][cOPTIONS].keys.toList();
    if (passParameter['isPage'] == 'New') {
      productListController.filter.addAll({
        'sort_by': listKey[productListController.selectedSortBy.value],
      });
      productListController.getProductList();
    } else if (passParameter['isPage'] == 'Trendy') {
      productListController.selectedSortBy.value = 1;
      productListController.filter.addAll({
        'sort_by': listKey[productListController.selectedSortBy.value],
      });
      productListController.getProductList();
    } else {
      productListController.filter ??= {}.obs;
      productListController.filter.addAll({
        'Category': [passParameter['catProductList']['id']]
      });
      productListController.getProductList();
      productListController.productSubCat(
          catId: passParameter['catProductList']['id']);
    }
    productListController.createOptions();
    productListController.setFormSelectedValue();
    productListController.scrollController
        .addListener(productListController.scrollListener);

    productListController.tabController = TabController(vsync: this, length: 1);
    productListController.tabController!.addListener(() {
      productListController.selectedIndex =
          productListController.tabController!.index;
    });
  }

  @override
  void dispose() {
    productListController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        actions: [
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
      body: _body(),
      /*body: Obx(
          () => (productListController.loading.isFalse)
              ? _body()
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        )*/
    );
  }

  _body() {
    var listKey =
        productListController.sortListMap['sort_by'][cOPTIONS].keys.toList();
    var listValues =
        productListController.sortListMap['sort_by'][cOPTIONS].values.toList();
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // construct the profile details widget here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              (passParameter['catProductList'] != null)
                  ? passParameter['catProductList']['name']
                  : passParameter['isPage'],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w700),
            ),
          ),

          // the tab bar with two items
          (productListController.filter.isNotEmpty)
              ? const SizedBox()
              : SizedBox(
                  height:
                      (productListController.listSubCatData.isEmpty) ? 0 : 30,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(10.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.fromSwatch()
                                  .copyWith(secondary: Colors.grey)),
                          child: productListController.listSubCatData.isEmpty
                              ? Container(
                                  height: 0.0,
                                )
                              : Container(
                                  height: 30.0,
                                  alignment: Alignment.center,
                                  child: TabBar(
                                    indicatorWeight: 0.0,
                                    controller:
                                        productListController.tabController,
                                    isScrollable: true,
                                    indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            50), // Creates border
                                        color: Colors.black),
                                    unselectedLabelColor: Colors.black,
                                    tabs: [
                                      for (var i = 0;
                                          i <
                                              productListController
                                                  .listSubCatData.length;
                                          i++)
                                        Tab(
                                          child: Text(
                                            productListController
                                                .listSubCatData[i]['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        )),
                  ),
                ),

          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.0,

            /// Filters.....
            title: Container(
              color: Colors.grey[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.filter,
                      size: 18,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Filters",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      productListController.filter.addAll({
                        'sort_by': listKey[productListController.selectedSortBy.value]
                      });
                      final result = Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductFilterView(),
                        ),
                      );
                      result.then((value) {
                        if (value != null) {
                          productListController.loading.value = true;
                          productListController.noDataFound = false;
                          productListController.filter = value;
                          productListController.listCatData.value = [];
                          productListController.page = 1;
                          productListController.getProductList();
                          productListController.tabController =
                              TabController(vsync: this, length: 1);
                          productListController.tabController!.addListener(() {
                            productListController.selectedIndex =
                                productListController.tabController!.index;
                          });
                        }
                      });
                    },
                  ),
                  TextButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.arrowRightArrowLeft,
                      size: 18,
                      color: Colors.black,
                    ),
                    label: Obx(() => Text(
                      "${listValues[productListController.selectedSortBy.value]}",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),),
                    onPressed: () {
                      productListController.settingModalBottomSheet(context);
                    },
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 30,
                    height: 30,
                    child: Obx(
                      () => IconButton(
                        icon: FaIcon(
                          (productListController.isPage.isTrue)
                              ? FontAwesomeIcons.grip
                              : FontAwesomeIcons.list,
                          size: 18,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (productListController.isPage.isTrue) {
                            productListController.isPage.value = false;
                          } else {
                            productListController.isPage.value = true;
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Obx(()=> Expanded(
            child: TabBarView(
              controller: productListController.tabController,
              children: [
                // first tab bar view widget
                Container(
                    child: (productListController.isPage.isTrue)
                        ? _bodyList()
                        : _bodyGrid())
              ],
            ),
          ),)
        ],
      ),
    );
  }

  _bodyList() {
    if (productListController.loading.isFalse) {
      if (productListController.listCatData.isNotEmpty) {
        return Container(
          color: Colors.grey[100],
          child: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: productListController.pullRefresh,
            child: ListView.builder(
              controller: productListController.scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: productListController.isLoadingMore.isTrue
                  ? productListController.listCatData.length + 10
                  : productListController.listCatData.length,
              itemBuilder: (BuildContext ctx, index) {
                // print('Current Index: $index');
                // print('List Length: ${productListController.listCatData.length}');
                // if (kDebugMode) {
                //   print("Check Product for index 23: ${productListController.listCatData[23]}");
                // }
                if (index < productListController.listCatData.length) {
                  return ProductBoxView(
                    productData: productListController.listCatData[index],
                    isPage: 'List',
                    onProductItemTap: (onPressed) {
                      print(productListController.listCatData[index]);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewProductDetailsScreen(
                            productData: onPressed,
                          ),
                        ),
                      );
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                    productData: onPressed,
                                  )),
                        ).then((value) {
                          if (this.mounted) {
                            setState(() {});
                          }
                        });*/
                    },
                  );
                } else {
                  return (productListController.isLoadingMore.isTrue)
                      ? const ShimmerSingleList()
                      : const SizedBox();
                }
              },
            ),
          ),
        );
      } else {
        return Container(
          color: Colors.grey[100],
          child: const Center(
            child: Text('No product found.'),
          ),
        );
      }
    }
    return const ShimmerList();
  }

  _bodyGrid() {
    if (productListController.loading.isFalse) {
      if (productListController.listCatData.isNotEmpty) {
        return Container(
          color: Colors.grey[100],
          child: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: productListController.pullRefresh,
            child: GridView.builder(
                controller: productListController.scrollController,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: productListController.isLoadingMore.isTrue
                    ? productListController.listCatData.length + 10
                    : productListController.listCatData.length,
                itemBuilder: (BuildContext ctx, index) {
                  if (index < productListController.listCatData.length) {
                    return ProductBoxView(
                      productData: productListController.listCatData[index],
                      isPage: 'Grid',
                      onProductItemTap: (onPressed) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewProductDetailsScreen(
                              productData: onPressed,
                            ),
                          ),
                        );
                        /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetail(
                            productData: onPressed,
                          )),
                    ).then((value) {
                      if (this.mounted) {
                        setState(() {});
                      }
                    });*/
                      },
                    );
                  } else {
                    return (productListController.isLoadingMore.isTrue)
                        ? const ShimmerSingleGrid()
                        : const SizedBox();
                  }
                }),
          ),
        );
      } else {
        return Container(
          color: Colors.grey[100],
          child: const Center(child: Text('No product found.')),
        );
      }
    }
    return const ShimmerGrid();
  }
}

// _bodyListOld() {
//   return Container(
//     color: Colors.grey[100],
//     child: (productListController.listCatData.isNotEmpty &&
//         productListController.loading.isFalse)
//         ? RefreshIndicator(
//       color: Theme.of(context).primaryColor,
//       onRefresh: productListController.pullRefresh,
//       child: ListView.builder(
//         controller: productListController.scrollController,
//         padding: const EdgeInsets.all(8.0),
//         itemCount: productListController.isLoadingMore.isTrue
//             ? productListController.listCatData.length + 1
//             : productListController.listCatData.length,
//         itemBuilder: (BuildContext ctx, index) {
//           if (index < productListController.listCatData.length) {
//             return ProductBoxView(
//               productData: productListController.listCatData[index],
//               isPage: 'List',
//               onProductItemTap: (onPressed) {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => NewProductDetailsScreen(productData: onPressed),));
//                 /*Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ProductDetailsView(
//                               productData: onPressed,
//                             ),
//                           ),
//                         );*/
//                 /*Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ProductDetail(
//                                     productData: onPressed,
//                                   )),
//                         ).then((value) {
//                           if (this.mounted) {
//                             setState(() {});
//                           }
//                         });*/
//               },
//             );
//           } else {
//             return (productListController.isLoadingMore.isTrue)
//                 ? const ShimmerList()
//                 : const SizedBox();
//           }
//         },
//       ),
//     )
//         : const Center(
//       child: Text('No product found.'),
//     ),
//   );
// }
//
// _bodyGridOld() {
//   return Container(
//     color: Colors.grey[100],
//     child: (productListController.listCatData.isNotEmpty &&
//         productListController.loading.isFalse)
//         ? RefreshIndicator(
//       color: Theme.of(context).primaryColor,
//       onRefresh: productListController.pullRefresh,
//       child: GridView.builder(
//           controller: productListController.scrollController,
//           padding: const EdgeInsets.all(10),
//           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 200,
//               childAspectRatio: 2 / 3,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10),
//           itemCount: productListController.isLoadingMore.isTrue
//               ? productListController.listCatData.length + 1
//               : productListController.listCatData.length,
//           itemBuilder: (BuildContext ctx, index) {
//             if (index < productListController.listCatData.length) {
//               return ProductBoxView(
//                 productData: productListController.listCatData[index],
//                 isPage: 'Grid',
//                 onProductItemTap: (onPressed) {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => NewProductDetailsScreen(productData: onPressed),));
//                   /*Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProductDetailsView(
//                                 productData: onPressed,
//                               ),
//                             ),
//                           );*/
//                   /*Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ProductDetail(
//                             productData: onPressed,
//                           )),
//                     ).then((value) {
//                       if (this.mounted) {
//                         setState(() {});
//                       }
//                     });*/
//                 },
//               );
//             } else {
//               return (productListController.isLoadingMore.isTrue)
//                   ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//                   : const SizedBox();
//             }
//           }),
//     )
//         : const Center(child: Text('No product found.')),
//   );
// }