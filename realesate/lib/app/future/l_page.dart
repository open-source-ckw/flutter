import 'package:flutter/material.dart';
import '/app/core/api_master.dart';
import '/app/map.dart';

import 'home.dart';

class LPage extends StatefulWidget {
  bool isGMap;
  Map<String, dynamic>? filter;

  LPage({Key? key, required this.isGMap, this.filter}) : super(key: key);

  @override
  State<LPage> createState() => _LPageState();
}

class _LPageState extends State<LPage> {
  APIMaster objApiH = APIMaster();
  List<Map<String, String>> listData = [];
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (widget.isGMap)
          ? GMap(
              filter: widget.filter,
              isLoading: this._isLoading,
              listAllData: [],
              refreshData: (data) {},
            )
          : Home(),
    );
  }
}
