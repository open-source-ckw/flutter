import 'package:flutter/material.dart';

class ButtonRefresh extends StatelessWidget {
  final onTap;

  const ButtonRefresh({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "linkRefresh",
      mini: true,
      backgroundColor: const Color(0xFFFFFFFF),
      foregroundColor: Colors.white,
      onPressed: onTap,
      child: Image.asset('images/icon_refresh.png'),
    );
  }
}
