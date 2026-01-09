import 'package:flutter/material.dart';
import 'home.dart';
import 'map.dart';

class TabFilter extends StatelessWidget {
  Map<String, dynamic> filter;
  bool isLoading;
  List<dynamic> listResult = [];
  ValueSetter<Map<String, dynamic>> refreshData;
  int totalResult = 0;
  bool isLoadingMore = false;
  String? onPage;

  TabFilter(
      {Key? key,
      required this.filter,
      required this.isLoading,
      required this.listResult,
      required this.totalResult,
      required this.refreshData,
      required this.isLoadingMore,
      this.onPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (onPage == 'Map')
        ? GMap(
            filter: this.filter,
            isLoading: this.isLoading,
            listAllData: this.listResult,
            refreshData: this.refreshData)
        : Homepage(
            filter: this.filter,
            isLoading: this.isLoading,
            listResult: this.listResult,
            totalResult: this.totalResult,
            refreshData: this.refreshData,
            isLoadingMore: this.isLoadingMore,
          );
  }
}
