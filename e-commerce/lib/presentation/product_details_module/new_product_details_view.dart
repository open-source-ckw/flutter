import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_api_handler.dart';
import '../photo_gallery_module/photo_gallery_view.dart';
import '../product_bag_module/product_bag_view.dart';
import '../product_box_module/product_box_view.dart';
import '../static_module/favorite_view.dart';
import '../static_module/rating_view.dart';
import '../../../core/app_globals.dart' as global;

class NewProductDetailsScreen extends StatefulWidget {
  Map<String, dynamic> productData;

  NewProductDetailsScreen({Key? key, required this.productData})
      : super(key: key);

  @override
  _NewProductDetailsScreenState createState() =>
      _NewProductDetailsScreenState();
}

class _NewProductDetailsScreenState extends State<NewProductDetailsScreen> {
  bool loading = true;
  String? productDescription;
  String selProSize = '';
  String selProColor = '';
  List<dynamic> imgList = [];
  List<dynamic> listProVariation = [];
  List<dynamic> similarProduct = [];
  Map<dynamic, dynamic> mapProVariation = {};
  Map<String, dynamic> attrList = {};

  ScrollController? scrollController;
  ScrollController? scrollControllerSlider;
  String cartBtnLabel = '';

  @override
  void initState() {
    super.initState();
    initialDataGet();
    setButtonValue();
    // attrList.isNotEmpty ? setButtonValue() : null;
  }

  /// Function to initialize data
  void initialDataGet() {
    Future.delayed(Duration.zero, () {
      getSimilarProduct(widget.productData);
      createOptions(widget.productData);

      /// Load images
      if (widget.productData.isNotEmpty) {
        for (var img in widget.productData['images']) {
          imgList.add(img['src']);
        }
      }

      /// Check if user-selected attributes exist
      bool hasSelectedAttributes =
          widget.productData.containsKey('selectedColor') &&
              widget.productData.containsKey('selectedSize');

      if (hasSelectedAttributes) {
        /// Preserve the user-selected attributes when opening the product page
        selProColor = widget.productData['selectedColor'].toUpperCase();
        selProSize = widget.productData['selectedSize'].toUpperCase();
      } else if (widget.productData['default_attributes'].isNotEmpty) {
        /// Otherwise, use default attributes
        for (var attr in widget.productData['default_attributes']) {
          if (attr['name'] == 'ClothingSize') {
            selProSize = attr['option'].toUpperCase();
          } else if (attr['name'] == 'Colors') {
            selProColor = attr['option'].replaceAll("-", " ").toUpperCase();
          }
        }
      } else if (widget.productData['attributes'].length > 1) {
        /// If no default attributes, use the first available option
        for (var attr in widget.productData['attributes']) {
          if (attr['name'] == 'Colors') {
            selProColor =
                attr['options'].first.replaceAll("-", " ").toUpperCase();
          } else if (attr['name'] == 'ClothingSize') {
            selProSize = attr['options'].first.toUpperCase();
          }
        }
      }

      /// Now fetch variations after setting selected attributes
      getProductVariation(widget.productData['id']);

      /// Parse product description
      if (widget.productData['description'] != null) {
        setState(() {
          productDescription =
              parseHtmlString(widget.productData['description']);
        });
      }
    });
  }

  /// Fetch Product Variations
  void getProductVariation(productID) async {
    List<dynamic> variations =
        await ApiHandlerService().getProductVariation(productID);
    if (variations.isNotEmpty) {
      Map<dynamic, dynamic> tempVariations = {};
      String defaultSize = '';
      String defaultColor = '';

      for (var variation in variations) {
        if (variation['attributes'].isNotEmpty) {
          String attrColor = '';
          String attrClothSize = '';

          for (var attr in variation['attributes']) {
            if (attr['name'] == 'Colors') {
              attrColor = attr['option'].toUpperCase();
            } else if (attr['name'] == 'ClothingSize') {
              attrClothSize = attr['option'].toUpperCase();
            }
          }

          // Store variation in map
          tempVariations['$attrClothSize|$attrColor'] = variation;

          // Capture the first available variant as the default
          if (defaultSize.isEmpty && defaultColor.isEmpty) {
            defaultSize = attrClothSize;
            defaultColor = attrColor;
          }
        }
      }

      setState(() {
        listProVariation = variations;
        mapProVariation = tempVariations;
        loading = false;

        // Ensure correct default selection
        if (selProSize.isEmpty || selProColor.isEmpty) {
          selProSize = defaultSize;
          selProColor = defaultColor;
        }

        // Update button label based on the correct variant
        setButtonValue();
      });
    }
  }

  /// Create Options from Product Attributes
  void createOptions(Map<String, dynamic> passData) {
    setState(() {
      attrList.clear();

      if (passData.containsKey('attributes') &&
          passData['attributes'] is List &&
          passData['attributes'].isNotEmpty) {
        for (var attr in passData['attributes']) {
          attrList[attr['name']] = attr['options'];
        }

        // Update selected values
        if (attrList.containsKey('Colors')) {
          selProColor = attrList['Colors'][0].toUpperCase();
        }
        if (attrList.containsKey('ClothingSize')) {
          selProSize = attrList['ClothingSize'][0].toUpperCase();
        }
      }
    });
  }

  /// Fetch Similar Products
  void getSimilarProduct(Map<String, dynamic> passData) async {
    String sPid = passData['related_ids']
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(" ", "");
    String filters = '$sPid&per_page=4';
    List<dynamic> similarProducts =
        await ApiHandlerService().getProductDetailsAPI(filters);

    setState(() {
      similarProduct = similarProducts;
    });
  }

  /// Remove HTML Tags from String
  String? parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return parse(document.body?.text).documentElement?.text;
  }

  addToCartProduct({item, productData}) async {
    /// This logic show
    /// Ex : {UserID : {Simple : {productId : {name, price, price, quantity}},
    ///                 Variable : {productId : {variationId : {name, price, price, quantity}}}}}
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (global.addToCart.containsKey(addToCartCnt) == true &&
        global.mapConfig[addToCartCnt].containsKey(item) == true) {
    } else {
      if (global.addToCart[global.isUserID][productData['type']].isNotEmpty) {
        /// All ready added product id in the variation
        if (global.addToCart[global.isUserID][productData['type']]
                .containsKey(productData['id'].toString()) ==
            true) {
          global.addToCart[global.isUserID][productData['type']]
                  [productData['id'].toString()]
              .addAll(item[productData['id'].toString()]);
        } else {
          global.addToCart[global.isUserID][productData['type']].addAll(item);
        }
        String encodedMap = json.encode(global.addToCart);
        prefs.setString(addToCartCnt, encodedMap);
      } else {
        global.addToCart[global.isUserID][productData['type']].addAll(item);
        String encodedMap = jsonEncode(global.addToCart);
        prefs.setString(addToCartCnt, encodedMap);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomNavigationBar: neBottomButton(),
    );
  }

  _body() {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      controller: scrollController,
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
        (attrList.isEmpty)
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
    if (mapProVariation.isNotEmpty) {
      return GestureDetector(
        onTap: (mapProVariation['${selProSize}|${selProColor}'] != null)
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoGalleryView(
                      imgList: [
                        mapProVariation['${selProSize}|${selProColor}']['image']
                            ['src']
                      ],
                      initialIndex: 0,
                    ),
                  ),
                );
              }
            : null,
        child: imgSection(
          (mapProVariation['${selProSize}|${selProColor}'] != null)
              ? mapProVariation['${selProSize}|${selProColor}']['image']['src']
              : noImg, //imgList[index]
        ),
      );
    }

    /// Without variation of product.....
    return Scrollbar(
      child: ListView.builder(
          itemCount: imgList.length, //imgList
          scrollDirection: Axis.horizontal,
          controller: scrollControllerSlider,
          itemBuilder: (BuildContext context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoGalleryView(
                      imgList: imgList,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: imgSection(
                imgList[index], //imgList[index]
              ),
            );
          }),
    );
  }

  Widget imgSection(image) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width, // / 1.5,
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: image,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => CachedNetworkImage(
              imageUrl: noImg,
            ),
          ),
        ],
      ),
    );
  }

  Widget silverListView() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (attrList.isNotEmpty &&
                            attrList.containsKey('ClothingSize') == true)
                        ? Expanded(
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: const Text('Size'),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
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
                                setState(() {
                                  selProSize =
                                      newValue.toString().toUpperCase();
                                  setButtonValue();
                                });
                              },
                              value: selProSize,
                              items: attrList['ClothingSize']
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
                    (attrList.isNotEmpty &&
                            attrList.containsKey('Colors') == true)
                        ? Expanded(
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: const Text('Color'),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
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
                                setState(() {
                                  selProColor = newValue
                                      .toString()
                                      .replaceAll("-", " ")
                                      .toUpperCase();
                                  setButtonValue();
                                });
                              },
                              value: selProColor.toUpperCase(),
                              items: attrList['Colors']
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
                    (attrList.isNotEmpty)
                        ? FavoriteIconView(productData: widget.productData)
                        : const SizedBox(),
                  ],
                ),
                (attrList.isNotEmpty)
                    ? const SizedBox(
                        height: 20,
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.productData['name'].toString().toUpperCase(),
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
                        productDescription.toString().toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, height: 1.5),
                        textAlign: TextAlign.justify,
                      )
                    : const SizedBox(),
                (similarProduct.isNotEmpty)
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
                            '${similarProduct.length} items',
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
                (similarProduct.isNotEmpty)
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: similarProductListView(),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productPrice() {
    if (widget.productData['type'] == 'variable') {
      String variationKey = '${selProSize}|${selProColor}';

      var variation = mapProVariation[variationKey];

      if (variation != null) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (variation["sale_price"] != null &&
                variation['sale_price'] != '')
              Text(
                '$currency${mapProVariation['${selProSize}|${selProColor}']['price']}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 27,
                    fontWeight: FontWeight.w500),
              ),
            const SizedBox(
              width: 2,
            ),
            (variation['sale_price'] != null && variation['sale_price'] != '')
                ? Text(
                    '$currency${mapProVariation['${selProSize}|${selProColor}']['regular_price']}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  )
                : Text(
                    '$currency${mapProVariation['${selProSize}|${selProColor}']['regular_price']}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 27,
                        fontWeight: FontWeight.w500),
                  ),
          ],
        );
      }
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
    return (similarProduct.isNotEmpty)
        ? ListView.builder(
            itemCount: similarProduct.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ProductBoxView(
                  productData: similarProduct[index],
                  isPage: 'Grid',
                  onProductItemTap: (Map<String, dynamic> value) {
                    loading == false;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewProductDetailsScreen(
                            productData: similarProduct[index],
                          ),
                        )).then(
                      (value) {
                        setButtonValue();
                      },
                    );
                  },
                ),
              );
            })
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget neBottomButton() {
    /// Variation products
    if (widget.productData['type'] == 'variable') {
      return (loading == false)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: (((mapProVariation['${selProSize}|${selProColor}'] !=
                                null &&
                            mapProVariation['${selProSize}|${selProColor}']
                                    ['stock_status'] ==
                                'instock' &&
                            mapProVariation['${selProSize}|${selProColor}']
                                    ['stock_quantity'] !=
                                null) ||
                        mapProVariation['${selProSize}|${selProColor}'] !=
                                null &&
                            global.addToCart[global.isUserID]
                                        [widget.productData['type']]
                                    .containsKey(mapProVariation[
                                                '${selProSize}|${selProColor}']
                                            ?['id']
                                        .toString()) ==
                                true))
                    ? () {
                        if (global.addToCart[global.isUserID]
                                    [widget.productData['type']]
                                .containsKey(mapProVariation[
                                        '${selProSize}|${selProColor}']['id']
                                    .toString()) ==
                            true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductBagView(),
                              )).then(
                            (value) {
                              setButtonValue();
                            },
                          );
                        } else {
                          Map<String, dynamic> mapAddToCartData = {};
                          mapAddToCartData = {
                            mapProVariation['${selProSize}|${selProColor}']
                                    ['id']
                                .toString(): {
                              'name': widget.productData['name'],
                              'qty': 1,
                              'size': selProSize.toString(),
                              'color': selProColor.toString(),
                              'p_id': widget.productData['id'].toString(),
                              'price': mapProVariation[
                                  '${selProSize}|${selProColor}']['price'],
                              'stock_qty': mapProVariation[
                                      '${selProSize}|${selProColor}']
                                  ['stock_quantity'],
                              'img': mapProVariation[
                                      '${selProSize}|${selProColor}']['image']
                                  ['src']
                            }
                          };
                          setState(() {
                            addToCartProduct(
                                item: mapAddToCartData,
                                productData: widget.productData);
                            cartBtnLabel = "Go To Cart";
                          });
                          const text =
                              'Your product successfully added your bag';
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
                  cartBtnLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          : const SizedBox();
    }

    /// Without variation products
    else {
      return (loading)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: ((widget.productData['stock_status'] ==
                                  'instock' &&
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductBagView(),
                                )).then(
                              (value) {
                                setButtonValue();
                              },
                            );
                          } else {
                            Map<String, dynamic> mapAddToCartData = {};
                            mapAddToCartData = {
                              widget.productData['id'].toString(): {
                                'name': widget.productData['name'],
                                'qty': 1,
                                'size': selProSize.toString(),
                                'color': selProColor.toString(),
                                'price': widget.productData['price'],
                                'stock_qty':
                                    widget.productData['stock_quantity'],
                                'img': (widget.productData['images'].isNotEmpty)
                                    ? widget.productData['images'][0]['src']
                                    : ''
                              }
                            };
                            setState(() {
                              addToCartProduct(
                                  item: mapAddToCartData,
                                  productData: widget.productData);
                              cartBtnLabel = 'Go To Cart';
                            });

                            const text =
                                'Your product successfully added your bag';
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
                  child: Text(cartBtnLabel,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20))),
            )
          : const SizedBox();
    }
  }

  setButtonValue() {
    if (mapProVariation.isNotEmpty) {
      /// With variation products......
      if (global.addToCart[global.isUserID][widget.productData['type']]
              .isNotEmpty &&
          global.addToCart[global.isUserID][widget.productData['type']]
                  .containsKey(mapProVariation['${selProSize}|${selProColor}']
                          ['id']
                      .toString()) ==
              true) {
        setState(() {
          cartBtnLabel = 'Go To Cart';
        });
      } else if (mapProVariation['${selProSize}|${selProColor}'] != null &&
          (mapProVariation['${selProSize}|${selProColor}']['stock_quantity'] !=
                  null &&
              mapProVariation['${selProSize}|${selProColor}']
                      ['stock_quantity'] <=
                  0)) {
        setState(() {
          cartBtnLabel = 'Out Of Stock';
        });
      } else {
        setState(() {
          cartBtnLabel = 'Add To Cart';
        });
      }
    } else {
      /// Without variation products......
      if (global.addToCart[global.isUserID][widget.productData['type']]
              .isNotEmpty &&
          global.addToCart[global.isUserID][widget.productData['type']]
                  .containsKey(widget.productData['id'].toString()) ==
              true) {
        setState(() {
          cartBtnLabel = 'Go To Cart';
        });
      } else if (widget.productData['stock_quantity'] == null ||
          widget.productData['stock_quantity'] <= 0) {
        setState(() {
          cartBtnLabel = 'Out Of Stock';
        });
      } else {
        setState(() {
          cartBtnLabel = 'Add To Cart';
        });
      }
    }
  }
}
