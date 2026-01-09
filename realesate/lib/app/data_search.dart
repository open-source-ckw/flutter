import 'package:flutter/material.dart';
import 'core/global.dart' as global;
import 'core/get_data.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class DataSearch extends SearchDelegate<String> {
  final Map<String, dynamic>? filterData;

  DataSearch({this.filterData})
      : super(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        );
  SearchResult searchResult = SearchResult();
  List suggestionList = [];

  @override
  String get searchFieldLabel => global.mapConfige['search_placeholder'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      highlightColor: Theme.of(context).colorScheme.background,
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, (query == '') ? 'clear' : '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }
    return FutureBuilder(
      future: searchResult.getSuggestions(query),
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
          return Column(
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
        } else if (suggestionList.data != null &&
            suggestionList.data.length == 0) {
          print('Do not found section');
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: Text('No data found.')),
            ],
          );
        } else {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: (suggestionList.data != null)
                  ? suggestionList.data.length
                  : 0,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    size: 32,
                  ),
                  title: RichText(
                      text: TextSpan(
                    // Substring.condition add becuase query.length are too long so add condition.
                    text: suggestionList.data[index]['title'].substring(
                        0,
                        (suggestionList.data[index]['title'].length <=
                                query.length
                            ? suggestionList.data[index]['title'].length
                            : query.length)),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: suggestionList.data[index]['title'].substring(
                            (suggestionList.data[index]['title'].length <=
                                    query.length
                                ? suggestionList.data[index]['title'].length
                                : query.length)),
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
                  subtitle: RichText(
                    text: TextSpan(
                      text: (suggestionList.data[index]['type'] == 'cs')
                          ? 'City'
                          : (suggestionList.data[index]['type'] == 'zip')
                              ? 'Postal Code'
                              : (suggestionList.data[index]['type'] == 'mls')
                                  ? 'MLS#'
                                  : (suggestionList.data[index]['type'] ==
                                          'add')
                                      ? 'Address'
                                      : (suggestionList.data[index]['type'] ==
                                              'area')
                                          ? 'Area'
                                          : 'Neighborhood',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  onTap: () {
                    close(
                        context,
                        suggestionList.data[index]['title'] +
                            '_' +
                            suggestionList.data[index]['type']);
                  },
                  onLongPress: () => null,
                );
              });
        }
      },
    );
  }
}
