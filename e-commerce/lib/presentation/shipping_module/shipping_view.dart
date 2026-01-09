import 'package:fashionia/presentation/shipping_module/shipping_add.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/shipping_controller.dart';

class ShippingView extends StatefulWidget {
  const ShippingView({Key? key}) : super(key: key);
  static const route = '/shipping_view';

  @override
  State<ShippingView> createState() => _ShippingViewState();
}

class _ShippingViewState extends State<ShippingView> {
  final shippingController = Get.put(ShippingController());

  @override
  void initState() {
    shippingController.getShippingData();
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
          'Shipping Address',
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: (shippingController.shippingData.containsKey('shipping') == true && shippingController.shippingData['shipping']['address_1'] == '') ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Get.toNamed(ShippingAdd.route)?.then((value) {
            if(value == true){
              shippingController.loading.value = true;
              shippingController.getShippingData();
            }
          });
        },
        child: const Icon(
          Icons.add,
        ),
      ) : FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Get.toNamed(ShippingAdd.route, arguments: shippingController.shippingData)?.then((value) {
            if(value == true){
              shippingController.loading.value = true;
              shippingController.getShippingData();
            }
          });
        },
        child: const Icon(
          Icons.edit,
        ),
      ),
      body: Obx(() => (shippingController.loading.isFalse) ? bodyWidget() : const Center(child: CircularProgressIndicator()),),
    );
  }

  bodyWidget(){
    return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: (shippingController.shippingData.containsKey('shipping') == true && shippingController.shippingData['shipping']['first_name'] != '')
                    ? Text(
                  shippingController.shippingData['shipping']['first_name'] + ' ' + shippingController.shippingData['shipping']['last_name'],
                  style: const TextStyle(
                      color: Colors.black, fontSize: 18),
                )
                    : const Text('Please add your name.', style: TextStyle(
                    color: Colors.black, fontSize: 18),),
                subtitle: (shippingController.shippingData.containsKey('shipping') == true && shippingController.shippingData['shipping']['address_1'] != '')
                    ? Text(
                  '${shippingController.shippingData['shipping']['address_1']}, ' + '${shippingController.shippingData['shipping']['city']}, ' + '${shippingController.shippingData['shipping']['postcode']}, ' + '${shippingController.shippingData['shipping']['state']}, ' + '${shippingController.shippingData['shipping']['country']}, ' + '${shippingController.shippingData['shipping']['phone']} ',
                  style: const TextStyle(color: Colors.grey),
                )
                    : const Text('Please add your address.',
                  style: TextStyle(color: Colors.black),
                ),
            ),
          ),));
  }
}