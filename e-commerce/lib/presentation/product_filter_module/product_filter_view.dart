import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_constant.dart';
import '../product_list_module/controller/product_list_controller.dart';
import 'controller/product_filter_controller.dart';

class ProductFilterView extends StatefulWidget {
  const ProductFilterView({Key? key}) : super(key: key);

  @override
  State<ProductFilterView> createState() => _ProductFilterViewState();
}

class _ProductFilterViewState extends State<ProductFilterView> {
  final productFilterController = Get.put(ProductFilterController());
  final productListController = Get.put(ProductListController());

  @override
  void initState() {
    if (productFilterController.filterList.isEmpty) {
      productFilterController.getFilterList();
    }

    if (productListController.filter.containsKey('min_price')) {
      productFilterController.startValue = productListController.filter['min_price'];
    }

    if (productListController.filter.containsKey('max_price')) {
      productFilterController.endValue = productListController.filter['max_price'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                  onPressed: () {
                    productFilterController.checkedFilters.clear();
                    productListController.filter.value = {};
                    productFilterController.startValue = 0.00;
                    productFilterController.endValue = 5000.00;
                    productListController.filter.refresh();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                    ),
                  ),
                  child: const Text('Discard',
                      style: TextStyle(color: Colors.black, fontSize: 16))),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    setFromValueInFilter();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Apply',
                      style: TextStyle(color: Colors.white, fontSize: 16))),
            )
          ],
        ),
      ),
      body: Obx(() => (productFilterController.loading.isFalse)
          ? productFilterController.loadingBody
          ? bodyProgress()
          : _bodyWidget()
          : const Center(
        child: CircularProgressIndicator(),
      ),)
    );
  }

  _bodyWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price range',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                RangeSlider(
                  min: 0.0,
                  max: 5000.0,
                  divisions: 20,
                  activeColor: Theme.of(context).primaryColor,
                  labels: RangeLabels(
                      currency+productFilterController.startValue.round().toString(),
                      currency+productFilterController.endValue.round().toString(),
                  ),
                  values: RangeValues(productFilterController.startValue, productFilterController.endValue),
                  onChanged: (values) {
                    productFilterController.startValue = values.start;
                    productFilterController.endValue = values.end;

                    productListController.filter.addAll({
                      'min_price': productFilterController.startValue,
                    });
                    if (productFilterController.startValue <= 0.0) {
                      productListController.filter.remove('min_price');
                    }
                    productListController.filter.addAll({
                      'max_price': productFilterController.endValue,
                    });
                    if (productFilterController.endValue == 5000.0) {
                      productListController.filter.remove('max_price');
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text('Minimum price', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text((productFilterController.startValue == 0.00) ? currency+'0' : currency+productFilterController.startValue.round().toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Maximum price', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text((productFilterController.startValue == 5000.00) ? currency+'5000' : currency+productFilterController.endValue.round().toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                      //Text('5000', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 3,
            color: Colors.grey[200],
          ),
          if(productFilterController.colorsList.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Colors',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: productFilterController.colorsList['Colors'].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Obx(() => FloatingActionButton(
                              mini: true,
                              heroTag: null,
                              shape: StadiumBorder(
                                side: (productListController.filter.containsKey('Colors') == true &&
                                    productListController.filter['Colors'].contains(productFilterController.colorsList['Colors'][index]['id']))
                                    ? BorderSide(
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Theme.of(context).primaryColor,
                                    width: 6)
                                    : BorderSide.none,
                              ),
                              onPressed: () {
                                if (productListController.filter.containsKey('Colors') == false) {
                                  productListController.filter.addAll({
                                    'Colors': [productFilterController.colorsList['Colors'][index]['id']]
                                  });
                                } else {
                                  if (productListController.filter['Colors'].contains(productFilterController.colorsList['Colors'][index]['id'])) {
                                    /// Remove value
                                    productListController.filter['Colors'].remove(productFilterController.colorsList['Colors'][index]['id']);

                                    /// Remove Key
                                    if (productListController.filter['Colors'].isEmpty) {
                                      productListController.filter.remove('Colors');
                                    }
                                  } else {
                                    productListController.filter['Colors'].add(productFilterController.colorsList['Colors'][index]['id']);
                                  }
                                }
                                productListController.filter.refresh();
                              },
                              backgroundColor: productFilterController.listColor[productFilterController.colorsList['Colors'][index]['name']],
                              /*backgroundColor: listColor[
                                      variationList['Colors'][index]['name']],*/
                              focusColor: Colors.red,
                            ),),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          Divider(
            thickness: 3,
            color: Colors.grey[200],
          ),
          if(productFilterController.clothingSizeList.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sizes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    children: variationData(),
                  ),
                ],
              ),
            ),
          Divider(
            thickness: 3,
            color: Colors.grey[200],
          ),
          category(),
        ],
      ),
    );
  }

  Widget bodyProgress() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _bodyWidget(),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  /// Size filters ..........
  variationData() {
    List<Widget> item = [];
    productFilterController.clothingSizeList.forEach((key, mapVal) {
      for (var i = 0; i < mapVal.length; i++) {
        item.add(
          TextButton(
            style: ButtonStyle(
              backgroundColor: (productListController.filter.containsKey('ClothingSize') == true &&
                  productListController.filter['ClothingSize'].contains(mapVal[i]['id']))
                  ? MaterialStatePropertyAll<Color>(
                  Theme.of(context).primaryColor)
                  : const MaterialStatePropertyAll<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(
                      color: Colors.black, width: 0.0),),),),
            onPressed: () {
              if (productListController.filter.containsKey('ClothingSize') == false) {
                productListController.filter.addAll({
                  'ClothingSize': [mapVal[i]['id']]
                });
              } else {
                if (productListController.filter['ClothingSize'].contains(mapVal[i]['id'])) {
                  /// Remove value
                  productListController.filter['ClothingSize'].remove(mapVal[i]['id']);

                  /// Remove Key
                  if (productListController.filter['ClothingSize'].isEmpty) {
                    productListController.filter.remove('ClothingSize');
                  }
                } else {
                  productListController.filter['ClothingSize'].add(mapVal[i]['id']);
                }
              }
              productListController.filter.refresh();
            },
            child: Text(
              mapVal[i]['name'],
              style: TextStyle(
                  color: (productListController.filter.containsKey('ClothingSize') == true &&
                      productListController.filter['ClothingSize'].contains(mapVal[i]['id']))
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ),
        );
        item.add(const SizedBox(
          width: 10,
        ));
      }
    });
    return item;
  }

  category() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            children: buildMainCatList(catList: productFilterController.categoryTree),
          )
        ],
      ),
    );
  }

  /// Category filters ..........
  List<Widget> buildMainCatList({required List<dynamic> catList}) {
    List<Widget> listItems = [];
    if (catList.isNotEmpty) {
      // Default All option
      listItems.add(
        TextButton(
          style: ButtonStyle(
              backgroundColor: (productListController.filter.containsKey('Category') == false)
                  ? MaterialStatePropertyAll<Color>(
                  Theme.of(context).primaryColor)
                  : const MaterialStatePropertyAll<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side:
                      const BorderSide(color: Colors.black, width: 0.0)))),
          onPressed: () {
            if (productListController.filter.containsKey('Category') == true) {
              productListController.filter.remove('Category');
            }
          },
          child: Text(
            'All',
            style: TextStyle(
                color: (productListController.filter.containsKey('Category') == false)
                    ? Colors.white
                    : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal),
          ),
        ),
      );
      listItems.add(const SizedBox(
        width: 10,
      ));
      for (var i = 0; i < catList.length; i++) {
        var bgColor = Colors.white;
        var textColor = Colors.black;
        if (productListController.filter.containsKey('Category') == true &&
            productListController.filter['Category'].contains(catList[i]['id'])) {
          bgColor = Theme.of(context).primaryColor;
          textColor = Colors.white;
        }
        listItems.add(
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(bgColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.black, width: 0.0),
                    ),
                ),
            ),
            onPressed: () {
              if (productListController.filter.containsKey('Category') == false) {
                productListController.filter.addAll({
                  'Category': [catList[i]['id']]
                });

              } else {
                if (productListController.filter['Category'].contains(catList[i]['id'])) {
                  /// Remove value
                  productListController.filter['Category'].remove(catList[i]['id']);

                  /// Remove Key
                  if (productListController.filter['Category'].isEmpty) {
                    productListController.filter.remove('Category');
                  }
                } else {
                  productListController.filter['Category'].add(catList[i]['id']);
                }
              }
              productListController.filter.refresh();
            },
            child: Text(
              catList[i]['name'],
              style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ),
        );
        listItems.add(const SizedBox(
          width: 10,
        ));
      }
    }
    return listItems;
  }

  setFromValueInFilter() {
    print('productFilterController.checkedFilters');
    print(productListController.filter);
    productListController.filter.addAll(productFilterController.checkedFilters);
    Navigator.pop(context, productListController.filter);
  }
}
