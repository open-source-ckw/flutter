import '../Provider/CategoriesProvider.dart';
import '../local/localization/language_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../Screens/CategoriesInfoList.dart';
import '../Util/CategoryEntity.dart';
import '../firebase/Storage/StorageHandler.dart';

import 'package:outline_search_bar/outline_search_bar.dart';

import '../Util/Constants.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/DB/Repo/CategoryRepository.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  static const route = 'AllCategories';

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List<Categories> categories = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  StorageHandler storageHandler = StorageHandler();

  // List<Equipments> equipment = [
  //   // Equipment("assets/images/1.jpg", "2 Dumbells"),
  //   // Equipment("assets/images/1.jpg", "Mat"),
  // ];

  List<int> selectedLevels = [];

  CategoryRepository categoryRepository = CategoryRepository();
  CategoriesProvider categoriesProvider = CategoriesProvider();

  Future<void> getCategories() async {
    List<Categories> tempCategories =
        await categoryRepository.getAllCategories();

    setState(() {
      categories = tempCategories;
    });
    /* var data = ModalRoute.of(context)!.settings.arguments;
    if (mounted) {
      setState(() {
        mainCategories = data as List<CategoryEntity>;
        categories = mainCategories;
      });
    }*/
  }

  List<Categories> mainCategories = [];

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      categories = mainCategories;
    } else {
      categories = categories
          .where((c) =>
              c.cs_name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Text(
            "${getTranslated(context, 'all')} ${getTranslated(context, 'categories')}",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline5!.color),
          ),
          centerTitle: true,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: OutlineSearchBar(
                onClearButtonPressed: (enteredKeyword) {
                  getCategories();
                },
                // backgroundColor: Colors.white,
                backgroundColor:
                    Theme.of(context).disabledColor.withOpacity(0.11),
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                onKeywordChanged: (enteredKeyword) =>
                    _runFilter(enteredKeyword),
                maxHeight: 48.0,
                hintText: "${getTranslated(context, 'search_something')}",
                searchButtonPosition: SearchButtonPosition.leading,
              ),
            ),
          )
          // backgroundColor: Colors.transparent,
          ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 60.0,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    // physics: BouncingScrollPhysics(),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      Categories category = categories.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 0.0, right: 0.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoriesInfoList(
                                          category: category,
                                        )));
                            // Navigator.pushNamed(context, CategoriesInfoScreen.route);
                          },
                          minVerticalPadding: 25.0,
                          tileColor:
                              Theme.of(context).disabledColor.withOpacity(0.11),
                          leading: FutureBuilder(
                            future:
                                storageHandler.getImageUrl(category.cs_image),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              return CachedNetworkImage(
                                imageUrl:
                                    snapshot.data != null && snapshot.data != ''
                                        ? snapshot.data!
                                        : Constants.loaderUrl,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              );
                            },
                            initialData: Constants.loaderUrl,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15.0,
                          ),
                          title: Text(category.cs_name),
                          // subtitle: Text('2 workouts'),

                          /*Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entity.text),
                              Text(entity.duration)
                            ],
                          ),*/
                        ),
                      );
                    },
                    itemCount: categories.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
