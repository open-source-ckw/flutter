import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CupertinoActivityIndicator(/*radius: 25.0,*/),
      ),
    );
  }
}

class IconImage extends StatelessWidget {
  const IconImage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/logo.png',
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
          ),
        ),
      ),
    );
  }
}
