import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionia/core/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_globals.dart' as global;
import '../checkout_module/checkout_view.dart';
import '../internet_connectivity_module/internet_connectivity_view.dart';
import '../login_module/login_view.dart';
import '../search_module/search_view.dart';
import 'controller/product_bag_controller.dart';

class ProductBagView extends StatefulWidget {
  const ProductBagView({Key? key}) : super(key: key);
  static const route = '/productBag_view';

  @override
  State<ProductBagView> createState() => _ProductBagViewState();
}

class _ProductBagViewState extends State<ProductBagView> {
  final productBagController = Get.put(ProductBagController());
  // create an instance
  final GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();

  @override
  void initState() {
    if ((global.addToCart[global.isUserID].containsKey('simple') == true &&
            global.addToCart[global.isUserID]['simple'] != null) ||
        global.addToCart[global.isUserID]['variable'] != null) {
      productBagController.getProductAddToCartItem();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: const Text(
            'My Bag',
            style: TextStyle(color: Colors.black),
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
          () => (productBagController.loading.isFalse)
              ? _body()
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
    );
  }

  _body() {
    return (productBagController.loading.isFalse &&
        global.addToCart[global.isUserID]['simple'].values.isEmpty &&
        global.addToCart[global.isUserID]['variable'].isEmpty)
        ? Center(
      child: Wrap(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Your cart is empty!',
                  style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                const Text(
                  "Look like you haven't added any clothes to your cart yet.",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    )
        : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: getDynamicMenu(),
              ),
              const SizedBox(
                height: 10,
              ),
              /// Need to enable after development
              //promoCodeWidget(),
              Row(
                children: [
                  const Text(
                    'Total amount:',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    currency+'${global.subTotal}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      if (global.isLoggedIn.isFalse) {
                        Get.toNamed(LoginView.route)?.then((value){
                          if(value == true) {}
                        });
                      } else {
                        if (productBagController.outOfStock.isTrue) {
                          const text =
                              'Please remove out of stock product.';
                          const snackBar = SnackBar(
                            content: Text(text),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        } else {
                          Get.toNamed(CheckoutView.route);
                          /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CheckOut()),
                              ).then((value) {
                                setState(() {});
                              });*/
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(400, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('CHECK OUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ))),
              ),
            ],
          ),
        ));
  }

  List<Widget> getDynamicMenu() {
    List<Widget> listItems = [];

    if (global.addToCart[global.isUserID]['simple'].isNotEmpty) {
      global.addToCart[global.isUserID]['simple'].forEach((key, val) {
        if (val['stock_qty'] <= 0) {
          productBagController.outOfStock.value = true;
        }
        listItems.add(bagData(key, val));
        listItems.add(
          const SizedBox(
            height: 10,
          ),
        );
      });
    }
    if (global.addToCart[global.isUserID]['variable'].isNotEmpty) {
      global.addToCart[global.isUserID]['variable'].forEach((key, val) {
        if (val['stock_qty'] <= 0) {
          productBagController.outOfStock.value = true;
        }
        listItems.add(bagData(key, val));
        listItems.add(
          const SizedBox(
            height: 10,
          ),
        );
      });
    }

    return listItems;
  }

  bagData(pvIDKey, cartProductVal) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              color: Colors.grey[100],
              child: CachedNetworkImage(
                imageUrl: (cartProductVal['img'] != '') ? cartProductVal['img'] : noImg,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    CachedNetworkImage(
                      imageUrl: noImg,
                    ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartProductVal['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  //overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: [
                                  (cartProductVal['color'] != '')
                                      ? Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                'Color : ',
                                                style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 12),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  cartProductVal['color'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  (cartProductVal['size'] != '')
                                      ? Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                'Size : ',
                                                style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 12),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  cartProductVal['size'],
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            productBagController.showDeleteProductSnackBar(pvIDKey, 'Are you sure you want to delete this product?', 'error');
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (cartProductVal['stock_qty'] <= 0)
                                ? const Text(
                                    'Out of stock',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Row(
                                    children: [
                                      SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: FloatingActionButton(
                                          heroTag: null,
                                          backgroundColor: Colors.white,
                                          onPressed: (cartProductVal['qty'] !=
                                                  1)
                                              ? () {
                                                  productBagController
                                                      .incrementDecrementCounter(
                                                          pvIDKey, false);
                                                }
                                              : null,
                                          tooltip: 'Decrement',
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.grey,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        cartProductVal['qty'].toString(),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: FloatingActionButton(
                                          heroTag: null,
                                          backgroundColor: Colors.white,
                                          onPressed: (cartProductVal[
                                                      'stock_qty'] >
                                                  cartProductVal['qty'])
                                              ? () {
                                                  productBagController
                                                      .incrementDecrementCounter(
                                                          pvIDKey, true);
                                                }
                                              : () {
                                                  const text =
                                                      'You reached maximum limit of quantity on this product.';
                                                  const snackBar = SnackBar(
                                                    content: Text(text),
                                                    backgroundColor: Colors.red,
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                    ..removeCurrentSnackBar()
                                                    ..showSnackBar(snackBar);
                                                },
                                          tooltip: 'Increment',
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.grey,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            (cartProductVal['stock_qty'] <= 0)
                                ? Text(
                              currency + cartProductVal['price'],
                                    style: const TextStyle(
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  )
                                : Text(currency + cartProductVal['price']),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  promoCodeWidget(){
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TextFormField(
            decoration: InputDecoration(
              suffixIcon: const FloatingActionButton(
                heroTag: null,
                mini: true,
                backgroundColor: Colors.black,
                onPressed: null,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
              fillColor: Colors.grey.shade200,
              hintText: 'Enter your promo code',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1.0,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1.0,
                ),
              ),
            ),
            enabled: false,
            onTap: null,
            readOnly: true,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
