import 'package:fashionia/presentation/product_details_module/new_product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../product_details_module/product_details_view.dart';
import '../product_list_module/product_list_view.dart';
import '../static_module/shimmer_view.dart';
import 'controller/search_controller.dart';

class SearchView extends SearchDelegate {
  final searchController = Get.put(SearchControllerGetX());

  @override
  String get searchFieldLabel => "Product name, Category";

  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    if (query.length < 3) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than three letters.",
            ),
          )
        ],
      );
    }
    return FutureBuilder(
      future: searchController.gettingResultOfSearch(passingParam: query),
      builder: (context, AsyncSnapshot<dynamic> suggestionList) {
        if (suggestionList.connectionState == ConnectionState.none) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        } else if (suggestionList.connectionState == ConnectionState.waiting) {

          /// Loader......
          return LinearProgressIndicator(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          );
        } else if(suggestionList.data['products'].length == 0 && suggestionList.data['category'].length == 0) {
          /// No data Found
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: Text('No data found')),
            ],
          );
        } else {
          /// List show of search history....
          return Column(
            children: <Widget>[
              Card(
                elevation: 0.0,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0.0),
                  title: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 10, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Search history',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                fontSize: 20.0,
                                color: Colors.black87,
                                fontFamily: 'Avenir')),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: _buildList(context, suggestionList.data),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  List<Widget> _buildList(context, Map<String, dynamic> suggestionList) {
    List<Widget> listItems = [];
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    for (var i = 0; i < suggestionList['products'].length; i++) {
      listItems.add(
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.grey[50],
          //elevation: 0.1,
          child: ListTile(
            trailing: const Icon(Icons.north_west),
            title: RichText(
              text: TextSpan(
                text: suggestionList['products']![i]['name'],
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              maxLines: 2,
            ),
            subtitle: const Text('is Product'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewProductDetailsScreen(productData: suggestionList['products'][i]),));
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsView(
                    productData: suggestionList['products'][i],
                  ),
                ),
              );*/
            },
          ),
        ),
      );
    }
    for (var i = 0; i < suggestionList['category'].length; i++) {
      listItems.add(
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.grey[200],
          //margin: const EdgeInsets.only(bottom: 2.0),
          //elevation: 0.1,
          child: ListTile(
            trailing: const Icon(Icons.north_west),
            title: RichText(
              text: TextSpan(
                text: suggestionList['category']![i]['name'],
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              maxLines: 2,
            ),
            subtitle: const Text('is Category'),
            onTap: () {
              Get.toNamed(ProductListView.route, arguments: {'catProductList' : suggestionList['category'][i], 'isPage' : 'category'},);
            },
          ),
        ),
      );
    }
    return listItems;
  }
}