import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/app_globals.dart' as global;
import '../../core/app_constant.dart';
import '../photo_gallery_module/photo_gallery_view.dart';
import '../product_bag_module/product_bag_view.dart';
import '../product_box_module/product_box_view.dart';
import '../static_module/favorite_view.dart';
import '../static_module/rating_view.dart';
import '../static_module/shimmer_view.dart';
import 'controller/product_details_controller.dart';

class ProductDetailsView extends StatefulWidget {
  Map<String, dynamic> productData;

  ProductDetailsView({Key? key, required this.productData}) : super(key: key);
  static const route = '/details_view';

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final productDetailsController = Get.put(ProductDetailsController());

  @override
  void initState() {
    initialDataGet();
    super.initState();
  }

  initialDataGet() {
    Future.delayed(Duration.zero, () {
      productDetailsController.createOptions(passData: widget.productData);
      productDetailsController.getSimilarProduct(passData: widget.productData);

      /// Get variation product in the variable.
      productDetailsController.getProductVariation(widget.productData['id']);
      if (widget.productData.isNotEmpty) {
        for (var i = 0; i < widget.productData['images'].length; i++) {
          productDetailsController.imgList
              .add(widget.productData['images'][i]['src']);
        }
      }
      if (widget.productData['default_attributes'].length > 0) {
        for (var i = 0;
        i < widget.productData['default_attributes'].length;
        i++) {
          if (widget.productData['default_attributes'][i]['name'] ==
              'ClothingSize') {
            productDetailsController.selProSize.value = widget
                .productData['default_attributes'][i]['option']
                .toUpperCase();
          } else if (widget.productData['default_attributes'][i]['name'] ==
              'Colors') {
            productDetailsController.selProColor.value = widget
                .productData['default_attributes'][i]['option']
                .replaceAll("-", " ")
                .toUpperCase();
          }
        }
      } else if (widget.productData['attributes'].length > 1) {
        for (var j = 0; j < widget.productData['attributes'].length; j++) {
          /// Set selected value of variation products attributes......
          if (widget.productData['attributes'][j]['name'] == 'Colors') {
            productDetailsController.selProColor.value = widget
                .productData['attributes'][j]['options'].first
                .replaceAll("-", " ")
                .toUpperCase();
          } else if (widget.productData['attributes'][j]['name'] ==
              'ClothingSize') {
            productDetailsController.selProSize.value = widget
                .productData['attributes'][j]['options'].first
                .toUpperCase();
          }
        }
      }
      if (widget.productData['description'] != null) {
        productDetailsController.productDescription = productDetailsController
            .parseHtmlString(widget.productData['description']);
      }
    });
  }

  @override
  void dispose() {
    productDetailsController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() =>
      (productDetailsController.loadingMore.isFalse &&
          productDetailsController.loading.isFalse)
          ? bottomButton()
          : const SizedBox()
      ),
      //body: ShimmerProductDetails(),
      body: SafeArea(
        child: Obx(
              () =>
          (productDetailsController.loading.isTrue)
              ? const ShimmerProductDetails()
              : _body(),
        ),
      ),
    );
  }

  _body() {
    return CustomScrollView(
      physics:
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      controller: productDetailsController.scrollController,
      slivers: <Widget>[
        silverAppBarCarousel(),
        silverListView(),
      ],
    );
  }

  Widget silverAppBarCarousel() {
    return SliverAppBar(
      stretch: true,
      floating: false,
      pinned: true,
      centerTitle: true,
      backgroundColor: Colors.white,
      onStretchTrigger: () {
        // Function callback for stretch
        return Future<void>.value();
      },
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          shadows: <Shadow>[
            Shadow(color: Colors.grey, blurRadius: 10.0, offset: Offset(3, 3))
          ],
        ),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      expandedHeight: 400.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        background: Stack(
          children: <Widget>[

            /// Main Image carousel....
            mainImgCarousel(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.5),
                  end: Alignment(0.0, 0.0),
                  colors: <Color>[
                    Color(0x60000000),
                    Color(0x00000000),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        (productDetailsController.attrList.isEmpty)
            ? FavoriteIconView(productData: widget.productData)
            : const SizedBox(),
        IconButton(
          icon: const Icon(
            Icons.share,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(color: Colors.grey, blurRadius: 10.0, offset: Offset(3, 3))
            ],
          ),
          onPressed: () {
            Share.share(widget.productData['permalink'],
                subject: "Fashionia product");
          },
        ),
      ],
    );
  }

  Widget mainImgCarousel() {
    /// With variation of product.....
    if (productDetailsController.mapProVariation.isNotEmpty) {
      return GestureDetector(
        onTap: (productDetailsController.mapProVariation[
        '${productDetailsController.selProSize.value}|${productDetailsController
            .selProColor.value}'] !=
            null)
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PhotoGalleryView(
                    imgList: [
                      productDetailsController.mapProVariation[
                      '${productDetailsController.selProSize
                          .value}|${productDetailsController.selProColor
                          .value}']
                      ['image']['src']
                    ],
                    initialIndex: 0,
                  ),
            ),
          );
        }
            : null,
        child: imgSection(
          (productDetailsController.mapProVariation[
          '${productDetailsController.selProSize
              .value}|${productDetailsController.selProColor.value}'] !=
              null)
              ? productDetailsController.mapProVariation[
          '${productDetailsController.selProSize
              .value}|${productDetailsController.selProColor.value}']['image']
          ['src']
              : noImg, //imgList[index]
        ),
      );
    }

    /// Without variation of product.....
    return Scrollbar(
      child: ListView.builder(
          itemCount: productDetailsController.imgList.length, //imgList
          scrollDirection: Axis.horizontal,
          controller: productDetailsController.scrollControllerSlider,
          itemBuilder: (BuildContext context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PhotoGalleryView(
                          imgList: productDetailsController.imgList,
                          initialIndex: index,
                        ),
                  ),
                );
              },
              child: imgSection(
                productDetailsController.imgList[index], //imgList[index]
              ),
            );
          }),
    );
  }

  Widget imgSection(image) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width, // / 1.5,
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: image,
            imageBuilder: (context, imageProvider) =>
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
            placeholder: (context, url) =>
            const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) =>
                CachedNetworkImage(
                  imageUrl: noImg,
                ),
          ),
        ],
      ),
    );
  }

  /// {userID : {Simple : {ProductId: qty}, Variable : {ProductId: qty}}}
  Widget bottomButton() {
    if (productDetailsController.mapProVariation.isNotEmpty &&
        productDetailsController.loading.isFalse) {
      /// With variation products......
      if (global.addToCart[global.isUserID][widget.productData['type']]
          .isNotEmpty &&
          global.addToCart[global.isUserID][widget.productData['type']]
              .containsKey(productDetailsController
              .mapProVariation['${productDetailsController.selProSize
              .value}|${productDetailsController.selProColor.value}']['id']
              .toString()) == true) {
        productDetailsController.cartBtnLabel.value = 'Go To Cart';
      } else
      if (productDetailsController.mapProVariation['${productDetailsController
          .selProSize.value}|${productDetailsController.selProColor.value}'] !=
          null &&
          (productDetailsController.mapProVariation['${productDetailsController
              .selProSize.value}|${productDetailsController.selProColor
              .value}']['stock_quantity'] !=
              null &&
              productDetailsController
                  .mapProVariation['${productDetailsController.selProSize
                  .value}|${productDetailsController.selProColor.value}']
              ['stock_quantity'] <=
                  0)) {
        productDetailsController.cartBtnLabel.value = 'Out Of Stock';
      } else {
        productDetailsController.cartBtnLabel.value = 'Add To Cart';
      }
    } else {

      /// Without variation products......
      if (global.addToCart[global.isUserID][widget.productData['type']]
          .isNotEmpty &&
          global.addToCart[global.isUserID][widget.productData['type']]
              .containsKey(widget.productData['id'].toString()) ==
              true) {
        productDetailsController.cartBtnLabel.value = 'Go To Cart';
      } else if (widget.productData['stock_quantity'] == null ||
          widget.productData['stock_quantity'] <= 0) {
        productDetailsController.cartBtnLabel.value = 'Out Of Stock';
      }
    }

    /// Variation products
    if (widget.productData['type'] == 'variable') {
      return (productDetailsController.loading.isFalse)
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: ((productDetailsController
              .mapProVariation['${productDetailsController.selProSize
              .value}|${productDetailsController.selProColor.value}']
          ['stock_quantity'] !=
              null &&
              productDetailsController
                  .mapProVariation['${productDetailsController
                  .selProSize.value}|${productDetailsController.selProColor
                  .value}']
              ['stock_quantity'] >
                  0) ||
              ((productDetailsController
                  .mapProVariation['${productDetailsController.selProSize
                  .value}|${productDetailsController.selProColor.value}']
              ['stock_status'] ==
                  'instock' &&
                  productDetailsController
                      .mapProVariation['${productDetailsController.selProSize
                      .value}|${productDetailsController.selProColor.value}']
                  ['stock_quantity'] !=
                      null) ||
                  global.addToCart[global.isUserID]
                  [widget.productData['type']]
                      .containsKey(
                      productDetailsController
                          .mapProVariation['${productDetailsController
                          .selProSize
                          .value}|${productDetailsController.selProColor
                          .value}']['id']
                          .toString()) ==
                      true))
              ? () {
            if (productDetailsController
                .mapProVariation['${productDetailsController.selProSize
                .value}|${productDetailsController.selProColor.value}'] ==
                null) {
              return;
            }
            if (global.addToCart[global.isUserID]
            [widget.productData['type']]
                .containsKey(productDetailsController.mapProVariation[
            '${productDetailsController.selProSize
                .value}|${productDetailsController.selProColor.value}']['id']
                .toString()) ==
                true) {
              Get.toNamed(ProductBagView.route);
              /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Bag(
                                  //isPage: 'Cart',
                                  ),
                            ),
                          );*/
            } else {
              Map<String, dynamic> mapAddToCartData = {};
              mapAddToCartData = {
                productDetailsController.mapProVariation[
                '${productDetailsController.selProSize
                    .value}|${productDetailsController.selProColor
                    .value}']['id']
                    .toString(): {
                  'name': widget.productData['name'],
                  'qty': 1,
                  'size': productDetailsController.selProSize.toString(),
                  'color': productDetailsController.selProColor.toString(),
                  'p_id': widget.productData['id'].toString(),
                  'price': productDetailsController
                      .mapProVariation['${productDetailsController.selProSize
                      .value}|${productDetailsController.selProColor
                      .value}']['price'],
                  'stock_qty': productDetailsController
                      .mapProVariation['${productDetailsController.selProSize
                      .value}|${productDetailsController.selProColor
                      .value}']['stock_quantity'],
                  'img': productDetailsController
                      .mapProVariation['${productDetailsController.selProSize
                      .value}|${productDetailsController.selProColor
                      .value}']['image']['src']
                }
              };
              productDetailsController.addToCartProduct(
                  item: mapAddToCartData, productData: widget.productData);
              const text = 'Your product successfully added your bag';
              const snackBar = SnackBar(
                content: Text(text),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(100, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: Text(
            productDetailsController.cartBtnLabel.value,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      )
          : const SizedBox();
    }

    /// Without variation products
    return (productDetailsController.loading.isFalse)
        ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: ((widget.productData['stock_status'] == 'instock' &&
              widget.productData['stock_quantity'] != null) ||
              (global.addToCart[global.isUserID]
              [widget.productData['type']]
                  .containsKey(
                  widget.productData['id'].toString()) ==
                  true))
              ? () {
            /// Without Variation add to cart process
            if (global.addToCart[global.isUserID]
            [widget.productData['type']]
                .containsKey(
                widget.productData['id'].toString()) ==
                true) {
              Get.toNamed(ProductBagView.route);
              /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Bag(
                                        //isPage: 'Cart',
                                        ),
                                  ),
                                );*/
            } else {
              Map<String, dynamic> mapAddToCartData = {};
              mapAddToCartData = {
                widget.productData['id'].toString(): {
                  'name': widget.productData['name'],
                  'qty': 1,
                  'size': productDetailsController.selProSize.toString(),
                  'color': productDetailsController.selProColor.toString(),
                  'price': widget.productData['price'],
                  'stock_qty':
                  widget.productData['stock_quantity'],
                  'img': (widget
                      .productData['images'].isNotEmpty)
                      ? widget.productData['images'][0]['src']
                      : ''
                }
              };
              productDetailsController.addToCartProduct(
                  item: mapAddToCartData, productData: widget.productData);
              const text = 'Your product successfully added your bag';
              const snackBar = SnackBar(
                content: Text(text),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(100, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: Text(productDetailsController.cartBtnLabel.value,
              style: const TextStyle(color: Colors.white, fontSize: 20))),
    )
        : const SizedBox();
  }

  Widget silverListView() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (productDetailsController.attrList.isNotEmpty &&
                      productDetailsController.attrList
                          .containsKey('ClothingSize') ==
                          true)
                      ? Expanded(
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: const Text('Size'),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(8.0)),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8.0)),
                          ),
                          filled: true,
                          fillColor: Colors.white),
                      validator: (value) =>
                      value == null ? "Please select size" : null,
                      dropdownColor: Colors.white,
                      onChanged: (newValue) {
                        productDetailsController.selProSize.value =
                            newValue.toString().toUpperCase();
                      },
                      value: productDetailsController.selProSize.value,
                      items: productDetailsController
                          .attrList['ClothingSize']
                          .map<DropdownMenuItem<String>>((values) {
                        return DropdownMenuItem<String>(
                          value: values.toUpperCase(),
                          child: Text(
                            values,
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  (productDetailsController.attrList.isNotEmpty &&
                      productDetailsController.attrList
                          .containsKey('Colors') ==
                          true)
                      ? Expanded(
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: const Text('Color'),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(8.0)),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8.0)),
                          ),
                          filled: true,
                          fillColor: Colors.white),
                      validator: (value) =>
                      value == null ? "Please select color" : null,
                      dropdownColor: Colors.white,
                      onChanged: (newValue) {
                        // Old code will used ".toUpperCase()",
                        productDetailsController.selProColor.value =
                            newValue
                                .toString()
                                .replaceAll("-", " ")
                                .toUpperCase();
                      },
                      value: productDetailsController.selProColor.value
                          .toUpperCase(),
                      items: productDetailsController.attrList['Colors']
                          .map<DropdownMenuItem<String>>((values) {
                        return DropdownMenuItem<String>(
                          // Old code will used "values.toUpperCase()",
                          value: values.toUpperCase(),
                          child: Text(
                            values,
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  (productDetailsController.attrList.isNotEmpty)
                      ? FavoriteIconView(productData: widget.productData)
                      : const SizedBox(),
                ],
              ),
              (productDetailsController.attrList.isNotEmpty)
                  ? const SizedBox(
                height: 20,
              )
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.productData['name']
                          .toString()
                          .capitalize!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  productPrice(),
                ],
              ),
              const SizedBox(
                height: 5,
              ),

              ///
              RatingView(
                productData: widget.productData,
              ),
              const SizedBox(
                height: 20,
              ),
              (widget.productData['description'] != '' ||
                  widget.productData['description'] != null)
                  ? Text(
                productDetailsController.productDescription
                    .toString()
                    .capitalize!,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, height: 1.5),
                textAlign: TextAlign.justify,
              )
                  : const SizedBox(),
              (productDetailsController.similarProduct.isNotEmpty)
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'You can also like this',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${productDetailsController.similarProduct.length} items',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                  : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              (productDetailsController.similarProduct.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery
                    .of(context)
                    .size
                    .height / 3,
                    child: similarProductListView(),
                  ) : const SizedBox()
            ],
          ),
        ),
      ],
      ),
    );
  }

  /// Product price..........
  Widget productPrice() {
    if (widget.productData['type'] == 'variable') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (productDetailsController.mapProVariation[
          '${productDetailsController.selProSize
              .value}|${productDetailsController.selProColor.value}']
          ['sale_price'] !=
              '' &&
              productDetailsController.mapProVariation[
              '${productDetailsController.selProSize
                  .value}|${productDetailsController.selProColor.value}']
              ['sale_price'] !=
                  null)
            Text(
              '$currency${productDetailsController
                  .mapProVariation['${productDetailsController.selProSize
                  .value}|${productDetailsController.selProColor
                  .value}']['price']}',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 27,
                  fontWeight: FontWeight.w500),
            ),
          const SizedBox(
            width: 2,
          ),
          (productDetailsController.mapProVariation[
          '${productDetailsController.selProSize
              .value}|${productDetailsController.selProColor.value}']
          ['sale_price'] !=
              '' &&
              productDetailsController.mapProVariation[
              '${productDetailsController.selProSize
                  .value}|${productDetailsController.selProColor.value}']
              ['sale_price'] !=
                  null)
              ? Text(
            '$currency${productDetailsController
                .mapProVariation['${productDetailsController.selProSize
                .value}|${productDetailsController.selProColor
                .value}']['regular_price']}',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.lineThrough,
            ),
          )
              : Text(
            '$currency${productDetailsController
                .mapProVariation['${productDetailsController.selProSize
                .value}|${productDetailsController.selProColor
                .value}']['regular_price']}',
            style: const TextStyle(
                color: Colors.black,
                fontSize: 27,
                fontWeight: FontWeight.w500),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.productData['sale_price'] != null &&
            widget.productData['sale_price'] != '')
          Text(
            '$currency${widget.productData['price']}',
            style: const TextStyle(
                color: Colors.black, fontSize: 27, fontWeight: FontWeight.w500),
          ),
        const SizedBox(
          width: 2,
        ),
        (widget.productData['sale_price'] != null &&
            widget.productData['sale_price'] != '')
            ? Text(
          '$currency${widget.productData['regular_price']}',
          style: const TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.lineThrough,
          ),
        )
            : Text(
          '$currency${widget.productData['regular_price']}',
          style: const TextStyle(
              color: Colors.black,
              fontSize: 27,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget similarProductListView() {
    return Obx(
          () =>
      (productDetailsController.similarProduct.isNotEmpty)
          ? ListView.builder(
          itemCount: productDetailsController.similarProduct.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            return SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 2.5,
              child: ProductBoxView(
                productData: productDetailsController.similarProduct[index],
                isPage: 'Grid',
                onProductItemTap: (onPressed) {
                  productDetailsController.loading.value = true;

                  Get.to(() =>
                      ProductDetailsView(
                        productData: onPressed,
                      ),
                    transition: Transition.rightToLeftWithFade,
                    //popGesture: true,
                    //preventDuplicates: true,
                  )?.then((value) {
                    if (value == true) {
                      //productDetailsController.loading.value = true;
                      //initialDataGet();
                    }
                  });

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsView(
                            productData: onPressed,
                          ),
                    ),
                  ).then((value){
                    if(value == true){
                      //productDetailsController.loading.value = true;
                      //initialDataGet();
                    }
                  });*/
                },
              ),
            );
          })
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
