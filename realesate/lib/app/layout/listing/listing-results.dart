import 'package:flutter/material.dart';
import 'listing_box.dart';
import '../../loader.dart';

class ListingResults extends StatefulWidget {
  bool isLoading;
  List listAllData = [];
  ValueSetter<Map<String, dynamic>> refreshData;
  bool isLoadingMore = false;
  int total_result;
  Map<String, dynamic> filterData;

  ListingResults({
    Key? key,
    required this.filterData,
    required this.isLoading,
    required this.listAllData,
    required this.refreshData,
    required this.isLoadingMore,
    required this.total_result,
  }) : super(key: key);

  @override
  State<ListingResults> createState() => _ListingResultsState();
}

class _ListingResultsState extends State<ListingResults> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      //listener
      if (_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels &&
          widget.listAllData.length != widget.total_result) {
        Map<String, dynamic> data = Map<String, dynamic>();
        if (widget.listAllData.length < widget.total_result &&
            widget.isLoading == false) {
          data['filter'] = widget.filterData;
          data['action'] = 'scroll';
          widget.refreshData(data);
        }
        //widget.refreshData({});
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(children: [
      (widget.isLoading == true && widget.listAllData.length == 0)
          ? Loader()
          : CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ListingBox(data: widget.listAllData[index] ?? "");
                    },
                    childCount: widget.listAllData.length,
                  ),
                ),
              ],
            ),
      (widget.isLoadingMore)
          ? Center(
              child: Container(
              //padding: EdgeInsets.all(20.0),
              //height: 175,
              //width: MediaQuery.of(context).size.width - 175,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //color: Colors.grey.shade50,
                color: Color.fromARGB(1, 0, 0, 0),
              ),
              //color: Colors.grey.shade200,
              child: loader(),
            ),
      )
          : SizedBox()
    ]);
  }

  loader() {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        color: Colors.white60,
      ),
      alignment: AlignmentDirectional.center,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Loader(),
          Text(
            "Loading...",
          ),
        ],
      ),
    );
  }
}
