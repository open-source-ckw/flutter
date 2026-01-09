import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '/app/layout/listing/sedule_tour.dart';

class SendRequst extends StatelessWidget {
  SendRequst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(color: Colors.grey[800]),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Center(
                      child: Text(
                    'Send a request to property owner to \nvisit the property',
                    style: TextStyle(fontSize: 20),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          withNavBar: false, screen: const Seduletour());
                    },
                    child: Text('I WANT TO SEE YOUR PROPERTY ',
                        style:
                            TextStyle(color: Color(0xFF2a5537), fontSize: 15)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      minimumSize: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Size(250, 40);
                        }
                        return Size(250, 40);
                      }),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
