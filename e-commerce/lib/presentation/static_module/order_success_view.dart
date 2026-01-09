import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout_module/layout_view.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({Key? key}) : super(key: key);
  static const route = '/order_success_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/success.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                    child: Text(
                  'Success!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w900),
                )),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Your order will be delivered soon.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Thank you for choosing our app!.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed(LayoutView.route);
                        /*Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                   const LayOutPage()),
                          ModalRoute.withName('/'),
                        );*/
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size(250, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text('Continue Shopping',
                          style: TextStyle(color: Colors.white, fontSize: 20))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
