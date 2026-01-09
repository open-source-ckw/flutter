import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/app_constant.dart';
import '../search_module/search_view.dart';
import 'controller/order_details_controller.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({Key? key}) : super(key: key);
  static const route = '/order_details_view';

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  final orderDetailsController = Get.put(OrderDetailsController());
  var passData = Get.arguments;

  @override
  void initState() {
    Map<String, dynamic> data = {"line_items": passData['line_items']};
    orderDetailsController.getProductOrderItem(passingAPIData: data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: const Text(
            'Order Details',
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
        body: Obx(
          () => (orderDetailsController.isLoading.isFalse)
              ? _body()
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
    );
  }

  _body() {
    DateTime datetime = DateTime.parse(passData['date_created']);
    String orderDateTime = DateFormat("yyyy-MMM-dd").format(datetime);
    final status = passData['status'];
    final trackNumber = 'DEMOIW${passData['id']}';
    final shippingAdd = '${passData['shipping']['address_1']}, ' +
        '${passData['shipping']['city']}, ' +
        '${passData['shipping']['state']}, ' +
        '${passData['shipping']['postcode']}, ' +
        '${passData['shipping']['country']}, ' +
        'Mo: ${passData['shipping']['phone']}';
    final paymentMethod = passData['payment_method_title'];
    final deliveryMethod =
        '${passData['currency_symbol']}${double.parse(passData['shipping_lines'][0]['total'].toString())} ${passData['shipping_lines'][0]['method_title']}';
    final discount =
        '${passData['currency_symbol']}${passData['total_tax']}, personal promo code';
    final totalAmount =
        '${passData['currency_symbol']}${double.parse(passData['total']).toInt()}';
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Order No: ${passData['id'].toString()}',
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        orderDateTime,
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      Text(
                        status.substring(0, 1).toUpperCase() +
                            status.substring(1),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Tracking Number:',
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                ),
                Expanded(
                    child: Text(
                      trackNumber,
                      style: const TextStyle(color: Colors.black, fontSize: 17),
                    ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (orderDetailsController.orderProductItems.isNotEmpty)
              Column(
                children: getDynamicMenu(),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Order information',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Shipping address:',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        shippingAdd,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Payment method:',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        paymentMethod,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Delivery method:',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        deliveryMethod,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ],
                ),
                if (passData['discount_tax'] != '0.00')
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Discount:',
                              style: TextStyle(color: Colors.grey, fontSize: 17),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              discount,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Total Amount :',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        totalAmount,
                        style: const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //feedbackAndReOrder(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getDynamicMenu() {
    List<Widget> listItems = [];
    for (var i = 0;
        i < orderDetailsController.orderProductItems['line_items'].length;
        i++) {
      listItems.add(
          bagData(orderDetailsController.orderProductItems['line_items'][i]));
      listItems.add(
        const SizedBox(
          height: 5,
        ),
      );
    }
    return listItems;
  }

  bagData(cartProduct) {
    String clothingSize = '';
    String colors = '';
    if (cartProduct['meta_data'] != null) {
      for (var i = 0; i < cartProduct['meta_data'].length; i++) {
        if (cartProduct['meta_data'][i]['display_key'] == 'ClothingSize') {
          clothingSize = cartProduct['meta_data'][i]['display_value'];
        }
        if (cartProduct['meta_data'][i]['display_key'] == 'Colors') {
          colors = cartProduct['meta_data'][i]['display_value'];
        }
      }
    }
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
                imageUrl: (cartProduct['image'] != null)
                    ? cartProduct['image']['src']
                    : noImg, //noImg, //cartProduct['images'][0]['src'],
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartProduct['name'].toString().capitalize!,
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
                              if (clothingSize != '' && colors != '')
                                Row(
                                  children: [
                                    Text(
                                      'Color : ',
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      colors,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Size : ',
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      clothingSize,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                ),
                            ],
                          ),
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
                            Row(
                              children: [
                                Text(
                                  'Quantity : ',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12),
                                ),
                                Text(
                                  '${cartProduct['quantity']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                currency + '${double.parse(cartProduct['total']).toInt()}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
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

  feedbackAndReOrder(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text('Reorder',
                  style: TextStyle(color: Colors.black))),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text('Leave Feedback',
                  style: TextStyle(color: Colors.black))),
        ),
      ],
    );
  }
}
