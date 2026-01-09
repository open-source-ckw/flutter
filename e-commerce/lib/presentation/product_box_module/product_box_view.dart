import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_constant.dart';
import '../static_module/favorite_view.dart';
import '../static_module/rating_view.dart';
import 'controller/product_box_controller.dart';

class ProductBoxView extends StatefulWidget {
  dynamic isPage;
  Map<String, dynamic> productData;
  ValueSetter<Map<String, dynamic>> onProductItemTap;
  ProductBoxView(
      {Key? key,
        required this.productData,
        this.isPage,
        required this.onProductItemTap})
      : super(key: key);

  @override
  State<ProductBoxView> createState() => _ProductBoxViewState();
}

class _ProductBoxViewState extends State<ProductBoxView> {
  final productBoxController = Get.put(ProductBoxController());

  @override
  Widget build(BuildContext context) {
    return (widget.isPage == 'List') ? productListBox() : productGridBox();
  }

  productListBox() {
    return GestureDetector(
      onTap: () => widget.onProductItemTap(widget.productData),
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              height: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    color: Colors.grey[100],
                    child: CachedNetworkImage(
                      imageUrl: (widget.productData['images'].isEmpty && widget.productData['images'].contains('src') == false)
                          ? noImg
                          : widget.productData['images'][0]['src'],
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
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              widget.productData['name'].toString(),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            RatingView(productData: widget.productData),
                            productPrice(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 5,
            child: FavoriteIconView(productData: widget.productData),
          )
        ],
      ),
    );
  }

  productGridBox() {
    var height = MediaQuery.of(context).size.height / 3;
    return GestureDetector(
      onTap: () => widget.onProductItemTap(widget.productData),
      child: GridTile(
        key: ValueKey(widget.productData['id']),
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: height - 110,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: (widget.productData['images'].isEmpty && widget.productData['images'].contains('src') == false)
                          ? noImg
                          : widget.productData['images'][0]['src'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitHeight,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(15),),
                        ),
                      ),
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator(),),
                      errorWidget: (context, url, error) =>
                          CachedNetworkImage(
                            imageUrl: noImg,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            RatingView(productData: widget.productData,),
                            Text(
                              widget.productData['name'].toString(),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                              /*style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600
                                //overflow: TextOverflow.ellipsis,
                              ),*/
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            productPrice(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 70,
              child: FavoriteIconView(productData: widget.productData),
            )
          ],
        ),
      ),
    );
  }

  /// Product price..........
  Widget productPrice(){
    if (widget.productData['type'] == 'variable') {
      return Text(
        '$currency${widget.productData['price']}',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(widget.productData['sale_price'] != null && widget.productData['sale_price'] != '')
          Text(
            '$currency${widget.productData['price']}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
          ),
        const SizedBox(width: 2,),
        (widget.productData['sale_price'] != null && widget.productData['sale_price'] != '')?
        Text(
          '$currency${widget.productData['regular_price']}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black).copyWith(color: Colors.red, decoration: TextDecoration.lineThrough,),
        ) : Text(
          '$currency${widget.productData['regular_price']}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
        ),
      ],
    );
  }
}