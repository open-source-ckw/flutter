import 'package:flutter/material.dart';

class NoInternetConnection extends StatefulWidget {
  const NoInternetConnection({Key? key}) : super(key: key);

  @override
  State<NoInternetConnection> createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/no-internet-connection.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const Text('No internet connection.', style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
