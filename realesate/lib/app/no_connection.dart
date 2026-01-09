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
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Colors.red,
              ),
              Text('No internet connection.'),
              TextButton(
                onPressed: () {
                  //TODO: Call to check connectivity again
                  setState(() {});
                },
                child: Container(
                  child: Text('Retry'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
