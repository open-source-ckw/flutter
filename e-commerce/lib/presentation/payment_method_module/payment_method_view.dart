import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/payment_method_controller.dart';

class PaymentMethodView extends StatefulWidget {
  const PaymentMethodView({Key? key}) : super(key: key);
  static const route = '/paymentMethod_view';

  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  final paymentMethodController = Get.put(PaymentMethodController());

  @override
  void initState() {
    paymentMethodController.getPayListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(() => (paymentMethodController.isLoading.value == false) ? bodyWidget() : const Center(
        child: CircularProgressIndicator(),
      ),)
    );
  }

  bodyWidget(){
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Payment Method',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Column(
                children: paymentMethodData(),
              ),
            ],
          ),
        ));
  }

  paymentMethodData() {
    List<Widget> payMethodData = <Widget>[];
    if (paymentMethodController.listPaymentData.isNotEmpty) {
      for (int i = 0; i < paymentMethodController.listPaymentData.length; i++) {
        if (paymentMethodController.listPaymentData[i]['enabled'] == true){
          payMethodData.add(RadioListTile(
            activeColor: Theme.of(context).primaryColor,
            title: Text(paymentMethodController.listPaymentData[i]['title'],),
            value: '${paymentMethodController.listPaymentData[i]['id']}',
            groupValue: paymentMethodController.selPayGateway.value,
            onChanged: (value) {
              paymentMethodController.selPayGateway.value = value.toString();
              paymentMethodController.selPayGatewayTitle.value =
              paymentMethodController.listPaymentData[i]['title'];
            },
          ));
        }
        /*Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/card5.jpg'),
            CheckboxListTile(
              title: const Text(
            'Use as a Default Payment Method',
            style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              value: _isSelectedVal,
              onChanged: (bool? value) {
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        );*/
      }
    }
    return payMethodData;
  }
}