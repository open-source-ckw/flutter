import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upi_india/upi_app.dart';
import '../../../core/app_globals.dart' as global;
import '../../core/app_constant.dart';
import '../shipping_module/shipping_add.dart';
import '../upi_module/upi_view.dart';
import 'controller/checkout_controller.dart';
import 'dart:io' show Platform;

class CheckoutView extends StatefulWidget {
  const CheckoutView({Key? key}) : super(key: key);
  static const route = '/checkout_view';

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final checkoutController = Get.put(CheckoutController());

  @override
  void initState() {
    checkoutController.loading.value = true;

    if (Platform.isAndroid) {
      /// Upi app Get in your device.....
      checkoutController.upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
        checkoutController.apps = value;
      }).catchError((e) {
        checkoutController.apps = [];
      });
    }

    /// Shipping address get...
    checkoutController.getShippingData();
    /// Sum of product with qty...
    checkoutController.sumOfSummary();
    /// Payment method...
    checkoutController.paymentMethodAPI();
    super.initState();
  }

  @override
  void dispose() {
    checkoutController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'CheckOut',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(() => (checkoutController.loading.isFalse)
          ? _body()
          : (checkoutController.loadingSubmit.isTrue)
          ? bodyProgress()
          : const Center(
           child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _body() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipping Address',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: (checkoutController.shippingData.containsKey('shipping') == true && checkoutController.shippingData['shipping']['first_name'] != '')
                        ? Text(
                      checkoutController.shippingData['shipping']['first_name'] + checkoutController.shippingData['shipping']['last_name'],
                      style: const TextStyle(
                          color: Colors.black, fontSize: 18),
                    )
                        : const Text('Please add your name.', style: TextStyle(
                        color: Colors.black, fontSize: 18),),
                    subtitle: Obx(() => (checkoutController.shippingData.containsKey('shipping') == true && checkoutController.shippingData['shipping']['address_1'] != '')
                        ? Text(
                            '${checkoutController.shippingData['shipping']['address_1']}, ' + '${checkoutController.shippingData['shipping']['city']}, ' + '${checkoutController.shippingData['shipping']['postcode']}, ' + '${checkoutController.shippingData['shipping']['state']}, ' + '${checkoutController.shippingData['shipping']['country']}, ' + '${checkoutController.shippingData['shipping']['phone']} ',
                            style: const TextStyle(color: Colors.grey),
                          )
                        : const Text('Please add your address.',
                      style: TextStyle(color: Colors.black),
                    ),),
                    trailing: GestureDetector(
                      onTap: () {
                        if(checkoutController.shippingData.containsKey('shipping') == true && checkoutController.shippingData['shipping']['address_1'] != '') {
                          Get.toNamed(ShippingAdd.route, arguments: checkoutController.shippingData)?.then((value) {
                            if(value == true){
                              checkoutController.getShippingData();
                            }
                          });
                        } else {
                          Get.toNamed(ShippingAdd.route)?.then((value) {
                            if(value == true){
                              checkoutController.getShippingData();
                            }
                          });
                        }
                      },
                      child: Text((checkoutController.shippingData.containsKey('shipping') == true && checkoutController.shippingData['shipping']['address_1'] != '') ?
                      'Change' : 'Add',
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    )
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //paymentWidget(),
              if (checkoutController.listOfPaymentGateway.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'More ways to pay',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  for (var i = 0; i < checkoutController.listOfPaymentGateway.length; i++)
                    if (checkoutController.listOfPaymentGateway[i]['enabled'] == true)
                      RadioListTile(
                        title: Text(checkoutController.listOfPaymentGateway[i]['title']),
                        value: '${checkoutController.listOfPaymentGateway[i]['id']}',
                        groupValue: checkoutController.selPayGatewayId.value,
                        onChanged: (value) {
                          checkoutController.selPayGatewayId.value = value.toString();
                          checkoutController.selPayGateway.value = checkoutController.listOfPaymentGateway[i];

                          /// Testing......
                          /*if(checkoutController.selPayGatewayId.value == 'wc-upi'){
                            Get.toNamed(UpiView.route, arguments: checkoutController.listOfPaymentGateway[i]);
                          }*/
                        },
                      ),
                ],
              ),
              if(checkoutController.selPayGatewayId.value == 'wc-upi')
                displayUpiApps(),
              //TextButton(onPressed: (){Get.toNamed(UpiView.route);}, child: Text('UPI'),),
              const SizedBox(
                height: 20,
              ),
              //deliveryWidget(),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Order :',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 17),
                      ),
                      const Spacer(),
                      Text(
                        currency +'${global.subTotal}',
                        style:
                        const TextStyle(color: Colors.black, fontSize: 17),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Delivery :',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 17),
                      ),
                      const Spacer(),
                      Text(
                        currency + '${checkoutController.deliveryCharge}',
                        style:
                        const TextStyle(color: Colors.black, fontSize: 17),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Summary :',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 20),
                      ),
                      const Spacer(),
                      Text(
                        currency + '${global.grandTotal}',
                        style:
                        const TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: GetBuilder<CheckoutController>(
                  init: CheckoutController(),
                  builder: (context){
                    return ElevatedButton(
                      onPressed: (checkoutController.selPayGatewayId.value == 'cod' || checkoutController.selPayGatewayId.value == 'razorpay' || (checkoutController.selPayGatewayId.value == 'wc-upi' && checkoutController.selUpiOption?.name != null))
                          ? () {
                              checkoutController.loading.value = true;
                              checkoutController.loadingSubmit.value = true;
                              /// Checking Add to cart item quantity.
                              checkoutController.getProductAddToCartItem().then((value){
                                if(value == true){
                                  checkoutController.loading.value = false;
                                  checkoutController.loadingSubmit.value = false;
                                  Get.back(result: true);
                                  const text = 'Please remove out of stock product.';
                                  checkoutController.showCheckoutSnackBar(value: text, status: 'error');
                                } else {
                                  /// Processed to order creation....
                                  if(checkoutController.createOrderData.isEmpty) {
                                    checkoutController.submitOrder();
                                  } else {
                                    /// If user is closed the popup of payment gateway then update the record.
                                    checkoutController.updateOrder(wcOrderId: checkoutController.createOrderData['id'].toString(), mapUpdateOrder: {
                                      "payment_method": checkoutController.selPayGatewayId.toString(),
                                      "payment_method_title": checkoutController.selPayGateway['title'].toString(),
                                    });
                                  }
                                }
                              });
                              checkoutController.listOfProduct.clear();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(400, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Submit Order',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    );
                  }),
              ),
            ],
          )),
    );
  }

  paymentWidget(){
    return Column(
      children: [
        Row(
          children: const [
            Text(
              'Payment',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Spacer(),
            Text(
              'Change',
              style: TextStyle(color: Colors.red, fontSize: 18),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: Image.asset('assets/card1.jpg')),
            const SizedBox(
              width: 30,
            ),
            const Text('*** **** *976',
                style: TextStyle(color: Colors.black, fontSize: 18)),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  deliveryWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Method',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        const SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: 100,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      height: 60,
                      width: 80,
                      child: Image.asset('assets/card2.jpg'),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    const Text(
                      '2-3 days',
                      style:
                      TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 100,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      height: 60,
                      width: 80,
                      child: Image.asset('assets/card3.jpg'),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    const Text(
                      '2-3 days',
                      style:
                      TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 100,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      height: 60,
                      width: 80,
                      child: Image.asset('assets/card4.jpg'),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    const Text(
                      '2-3 days',
                      style:
                      TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget displayUpiApps() {
    if (checkoutController.apps == null) {
      if (Platform.isAndroid) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Center(
          child: Text(
            "This feature coming soon for your device.",
            style: checkoutController.header,
          ),
        );
      }
    } else if (checkoutController.apps!.isEmpty) {
      if (Platform.isAndroid) {
        return Center(
          child: Text(
            "No apps found to use UPI transaction.",
            style: checkoutController.header,
          ),
        );
      } else {
        return Center(
          child: Text(
            "This feature coming soon for your device.",
            style: checkoutController.header,
          ),
        );
      }
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: ButtonBar(
            children: checkoutController.apps!.map((UpiApp app){
              return GetBuilder<CheckoutController>(
                init: CheckoutController(),
                  builder: (context){
                    return RadioMenuButton(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.memory(
                              app.icon,
                              height: 60,
                              width: 60,
                            ),
                            Text(app.name),
                          ],
                        ),
                      ),
                      value: app,
                      groupValue: checkoutController.selUpiOption,
                      onChanged: (value) {
                        checkoutController.selUpiOption = value as UpiApp?;
                        checkoutController.update();
                      },
                    );
                  }
              );
            }).toList(),
          ),
        ),
      );
      // return Align(
      //   alignment: Alignment.topCenter,
      //   child: SingleChildScrollView(
      //     physics: const BouncingScrollPhysics(),
      //     child: Wrap(
      //       children: checkoutController.apps!.map<Widget>((UpiApp app) {
      //         return GestureDetector(
      //           onTap: () {
      //             checkoutController.transaction = checkoutController.initiateTransaction(app, checkoutController.selPayGateway);
      //             setState((){});
      //           },
      //           child: SizedBox(
      //             height: 100,
      //             width: 100,
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: <Widget>[
      //                 Image.memory(
      //                   app.icon,
      //                   height: 60,
      //                   width: 60,
      //                 ),
      //                 Text(app.name),
      //               ],
      //             ),
      //           ),
      //         );
      //       }).toList(),
      //     ),
      //   ),
      // );
    }
  }

  Widget bodyProgress() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _body(),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
