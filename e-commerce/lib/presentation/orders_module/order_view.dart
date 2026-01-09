import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/app_constant.dart';
import '../order_details_module/order_details_view.dart';
import '../search_module/search_view.dart';
import '../static_module/shimmer_view.dart';
import 'controller/order_controller.dart';

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);
  static const route = '/order_view';

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final orderController = Get.put(OrderController());

  @override
  void initState() {
    orderController.loading.value = true;
    orderController.getOrderData();
    super.initState();
  }

  @override
  void dispose() {
    orderController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
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
        body: bodyWidget());
  }

  bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // construct the profile details widget here
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'My Orders',
            style: TextStyle(
                color: Colors.black, fontSize: 35, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // the tab bar with two items
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 50,
            child: AppBar(
              backgroundColor: Colors.grey[50],
              elevation: 0.0,
              bottom: TabBar(
                controller: orderController.tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Creates border
                    color: Colors.black),
                unselectedLabelColor: Colors.black,
                tabs: orderController.myTabs,
              ),
            ),
          ),
        ),

        // create widgets for each tab bar here
        Expanded(
            child: Obx(() => TabBarView(
            controller: orderController.tabController,
            children: orderController.myTabs.map((Tab tab) {
              final String label = tab.text!;
              return Container(
                  child: _bodyNew(
                      status: label,
                      statusIndex: orderController.tabController.index));
            }).toList(),
          ),
        )),
      ],
    );
  }

  _bodyNew({required String? status, required int statusIndex}) {
    final mainLabelStatus = status?.toLowerCase();
    if(orderController.loading.isFalse){
      if(orderController.mapOrderCatData[mainLabelStatus] != null){
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: orderController.pullRefresh,
          child: ListView.builder(
              controller: orderController.scrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: orderController.isLoadingMore.isTrue
                  ? orderController.mapOrderCatData[mainLabelStatus].length + 1
                  : orderController.mapOrderCatData[mainLabelStatus].length,
              itemBuilder: (BuildContext context, int index) {
                if (index < orderController.mapOrderCatData[mainLabelStatus].length) {
                  DateTime datetime = DateTime.parse(orderController.mapOrderCatData[mainLabelStatus][index]['date_created']);
                  String orderDateTime =
                  DateFormat("yyyy-MMM-dd").format(datetime);
                  final orderNo =
                  orderController.mapOrderCatData[mainLabelStatus][index]['number'];
                  final trackNo =
                  orderController.mapOrderCatData[mainLabelStatus][index]['id'];
                  final qty = (orderController.mapOrderCatData[mainLabelStatus][index]['line_items'].isNotEmpty)
                      ? '${orderController.mapOrderCatData[mainLabelStatus][index]['line_items'][0]['quantity']}'
                      : '0';
                  final totalAmt =
                  orderController.mapOrderCatData[mainLabelStatus][index]['total'];
                  final status =
                  orderController.mapOrderCatData[mainLabelStatus][index]['status'];

                  return ((status ==
                      orderController.mapOrderCatData[mainLabelStatus][index]
                      ['status'] &&
                      statusIndex == orderController.selectedIndex) ||
                      (status == 'any' &&
                          statusIndex == orderController.selectedIndex))
                      ? Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipPath(
                        clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Order No :',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(orderNo,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text(
                                    orderDateTime,
                                    style: const TextStyle(
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Tracking number:',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'DEMOIW${trackNo}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Quantity:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      qty,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Wrap(
                                  children: [
                                    const Text(
                                      'Total Amount:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      currency + '${double.parse(totalAmt).toInt()}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      style: ButtonStyle(
                                        padding:
                                        MaterialStateProperty.all(
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal: 20)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(18.0),
                                                side: const BorderSide(
                                                    color:
                                                    Colors.black))),
                                      ),
                                      onPressed: () {
                                        Get.toNamed(OrderDetailsView.route, arguments: orderController.mapOrderCatData[mainLabelStatus][index]);
                                      },
                                      child: const Text(
                                        'Details',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16),
                                      )),
                                  const Spacer(),
                                  Text(
                                    status
                                        .substring(0, 1)
                                        .toUpperCase() +
                                        status.substring(1),
                                    style: const TextStyle(
                                        color: Colors.green),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      : const SizedBox();
                } else {
                  return (orderController.isLoadingMore.isTrue)
                      ? const ShimmerSingleList()
                      : const SizedBox();
                }
              }),
        );
      } else {
        if(orderController.mapOrderCatData[mainLabelStatus] != null && orderController.mapOrderCatData[mainLabelStatus].length < 0){
          return const Center(
            child: Text(
              'No data found',
              style: TextStyle(color: Colors.black),
            ),
          );
        } else {
          return const SizedBox();
        }
      }
    }
    return const ShimmerList();
    return (orderController.loading.isFalse)
        ? (orderController.listOrderCatData.isNotEmpty)
        ? ListView.builder(
        controller: orderController.scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: orderController.isLoadingMore.isTrue
            ? orderController.listOrderCatData.length + 1
            : orderController.listOrderCatData.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < orderController.listOrderCatData.length) {
            DateTime datetime = DateTime.parse(orderController
                .listOrderCatData[index]['date_created']);
            String orderDateTime =
            DateFormat("yyyy-MMM-dd").format(datetime);
            final orderNo =
            orderController.listOrderCatData[index]['number'];
            final trackNo =
            orderController.listOrderCatData[index]['id'];
            final qty = (orderController
                .listOrderCatData[index]['line_items'].isNotEmpty)
                ? '${orderController.listOrderCatData[index]['line_items'][0]['quantity']}'
                : '0';
            final totalAmt =
            orderController.listOrderCatData[index]['total'];
            final status =
            orderController.listOrderCatData[index]['status'];

            return ((status ==
                orderController.listOrderCatData[index]
                ['status'] &&
                statusIndex == orderController.selectedIndex) ||
                (status == 'any' &&
                    statusIndex == orderController.selectedIndex))
                ? Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Order No :',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(orderNo,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Text(
                              orderDateTime,
                              style: const TextStyle(
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Tracking number:',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                'DEMOIW${trackNo}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          Row(
                            children: [
                              const Text(
                                'Quantity:',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                qty,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Wrap(
                            children: [
                              const Text(
                                'Total Amount:',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                currency+ '${double.parse(totalAmt).toInt()}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            TextButton(
                                style: ButtonStyle(
                                  padding:
                                  MaterialStateProperty.all(
                                      const EdgeInsets
                                          .symmetric(
                                          horizontal: 20)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(18.0),
                                          side: const BorderSide(
                                              color:
                                              Colors.black))),
                                ),
                                onPressed: () {
                                  Get.toNamed(OrderDetailsView.route, arguments: orderController.listOrderCatData[index]);
                                },
                                child: const Text(
                                  'Details',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16),
                                )),
                            const Spacer(),
                            Text(
                              status
                                  .substring(0, 1)
                                  .toUpperCase() +
                                  status.substring(1),
                              style: const TextStyle(
                                  color: Colors.green),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
                : const SizedBox();
          } else {
            return (orderController.isLoadingMore.isTrue)
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : const SizedBox();
          }
        })
        : const Center(
        child: Text(
          'No data found',
          style: TextStyle(color: Colors.black),
        ))
        : const Center(
      child: CircularProgressIndicator(),
    );
  }

  _bodyNewOld({required String? status, required int statusIndex}) {
    if(orderController.loading.isFalse){
      if(orderController.listOrderCatData.isNotEmpty){
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: orderController.pullRefresh,
          child: ListView.builder(
              controller: orderController.scrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: orderController.isLoadingMore.isTrue
                  ? orderController.listOrderCatData.length + 1
                  : orderController.listOrderCatData.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < orderController.listOrderCatData.length) {
                  DateTime datetime = DateTime.parse(orderController
                      .listOrderCatData[index]['date_created']);
                  String orderDateTime =
                  DateFormat("yyyy-MMM-dd").format(datetime);
                  final orderNo =
                  orderController.listOrderCatData[index]['number'];
                  final trackNo =
                  orderController.listOrderCatData[index]['id'];
                  final qty = (orderController
                      .listOrderCatData[index]['line_items'].isNotEmpty)
                      ? '${orderController.listOrderCatData[index]['line_items'][0]['quantity']}'
                      : '0';
                  final totalAmt =
                  orderController.listOrderCatData[index]['total'];
                  final status =
                  orderController.listOrderCatData[index]['status'];

                  return ((status ==
                      orderController.listOrderCatData[index]
                      ['status'] &&
                      statusIndex == orderController.selectedIndex) ||
                      (status == 'any' &&
                          statusIndex == orderController.selectedIndex))
                      ? Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipPath(
                        clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Order No :',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(orderNo,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text(
                                    orderDateTime,
                                    style: const TextStyle(
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Tracking number:',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'DEMOIW${trackNo}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Quantity:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      qty,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Wrap(
                                  children: [
                                    const Text(
                                      'Total Amount:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        currency + '${double.parse(totalAmt).toInt()}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      style: ButtonStyle(
                                        padding:
                                        MaterialStateProperty.all(
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal: 20)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(18.0),
                                                side: const BorderSide(
                                                    color:
                                                    Colors.black))),
                                      ),
                                      onPressed: () {
                                        Get.toNamed(OrderDetailsView.route, arguments: orderController.listOrderCatData[index]);
                                      },
                                      child: const Text(
                                        'Details',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16),
                                      )),
                                  const Spacer(),
                                  Text(
                                    status
                                        .substring(0, 1)
                                        .toUpperCase() +
                                        status.substring(1),
                                    style: const TextStyle(
                                        color: Colors.green),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      : const SizedBox();
                } else {
                  return (orderController.isLoadingMore.isTrue)
                      ? const ShimmerSingleList()
                      : const SizedBox();
                }
              }),
        );
      } else {
        return const Center(
            child: Text(
              'No data found',
              style: TextStyle(color: Colors.black),
            ));
      }
    }
    return const ShimmerList();
    return (orderController.loading.isFalse)
        ? (orderController.listOrderCatData.isNotEmpty)
            ? ListView.builder(
                controller: orderController.scrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: orderController.isLoadingMore.isTrue
                    ? orderController.listOrderCatData.length + 1
                    : orderController.listOrderCatData.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index < orderController.listOrderCatData.length) {
                    DateTime datetime = DateTime.parse(orderController
                        .listOrderCatData[index]['date_created']);
                    String orderDateTime =
                        DateFormat("yyyy-MMM-dd").format(datetime);
                    final orderNo =
                        orderController.listOrderCatData[index]['number'];
                    final trackNo =
                        orderController.listOrderCatData[index]['id'];
                    final qty = (orderController
                            .listOrderCatData[index]['line_items'].isNotEmpty)
                        ? '${orderController.listOrderCatData[index]['line_items'][0]['quantity']}'
                        : '0';
                    final totalAmt =
                        orderController.listOrderCatData[index]['total'];
                    final status =
                        orderController.listOrderCatData[index]['status'];

                    return ((status ==
                                    orderController.listOrderCatData[index]
                                        ['status'] &&
                                statusIndex == orderController.selectedIndex) ||
                            (status == 'any' &&
                                statusIndex == orderController.selectedIndex))
                        ? Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ClipPath(
                                clipper: ShapeBorderClipper(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Order No :',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(orderNo,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600)),
                                          const Spacer(),
                                          Text(
                                            orderDateTime,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Tracking number:',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'DEMOIW${trackNo}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Quantity:',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              qty,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Wrap(
                                          children: [
                                            const Text(
                                              'Total Amount:',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                currency+ '${double.parse(totalAmt).toInt()}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 20)),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                        side: const BorderSide(
                                                            color:
                                                                Colors.black))),
                                              ),
                                              onPressed: () {
                                                Get.toNamed(OrderDetailsView.route, arguments: orderController.listOrderCatData[index]);
                                              },
                                              child: const Text(
                                                'Details',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              )),
                                          const Spacer(),
                                          Text(
                                            status
                                                    .substring(0, 1)
                                                    .toUpperCase() +
                                                status.substring(1),
                                            style: const TextStyle(
                                                color: Colors.green),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  } else {
                    return (orderController.isLoadingMore.isTrue)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const SizedBox();
                  }
                })
            : const Center(
                child: Text(
                'No data found',
                style: TextStyle(color: Colors.black),
              ))
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
