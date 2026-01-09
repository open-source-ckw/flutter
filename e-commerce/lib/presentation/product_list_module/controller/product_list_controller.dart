import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_api_handler.dart';
import '../../../core/app_constant.dart';

class ProductListController extends GetxController with GetSingleTickerProviderStateMixin{

  final passParameter = Get.arguments;
  RxMap filter = {}.obs;
  RxBool loading = false.obs;
  RxBool isLoadingMore = false.obs;
  bool noDataFound = false;
  RxList listCatData = [].obs;
  List listSubCatData = [];
  int page = 1;
  final scrollController = ScrollController();

  /// Home listing show ......
  List listNewProductData = [];
  List listTrendProductData = [];
  TabController? tabController;
  int selectedIndex = 0;
  RxBool isPage = true.obs;

  /// ----------- Sort feature -------------
  RxInt selectedSortBy = 0.obs;
  List<dynamic> _sortList = [];
  Map<String, dynamic> sortListMap = {
    "sort_by": {
      "TITLE": "sortby",
      "OPTION": {
        "date|desc": "Newest",
        "popularity|desc": "Popular",
        "rating|desc": "Customer review",
        "price|asc": "Price : Lowest to High",
        "price|desc": "Price : Highest to Low",
      }
    }
  };

  @override
  void onInit() {
    tabController = TabController(length: 1, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    isLoadingMore = false.obs;
    noDataFound = false;
    listCatData = [].obs;
    selectedSortBy = 0.obs;
    page = 1;
    filter = {}.obs;
    super.onClose();
  }

  Future<void> scrollListener() async {
    if(isLoadingMore.value == true) return;
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent && noDataFound == false){
      isLoadingMore.value = true;
      page = page+1;

      await getProductList();
      isLoadingMore.value = false;
    }
  }

  /// Get product list API........
  getProductList() async {
    var url;
    // url = '?include_variations=true&per_page=10';
    url = '?exclude_variations=true&per_page=10';

    if (filter.containsKey('featuredProduct') == true) {
      url += '&featured=' + '${filter['featuredProduct']}';
    }

    if (filter.containsKey('Category') == true &&
        filter['Category'] != null) {
      url += '&category=${filter['Category']
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(" ", "")}';
    }

    if (filter.containsKey('sort_by') == true) {
      var strSplit = filter['sort_by'].split('|');
      url += '${'&orderby=' + strSplit[0]}&order=' + strSplit[1];
    }

    if (filter.containsKey('Colors') == true) {
      url += '&attribute=pa_color&attribute_term=${filter['Colors']
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(" ", "")}';
    }

    if (filter.containsKey('ClothingSize') == true) {
      url += '&attribute=pa_clothingsize&attribute_term=${filter['ClothingSize']
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(" ", "")}';
    }

    if (filter.containsKey('min_price') == true) {
      url += '&min_price=${filter['min_price']}';
    }

    if (filter.containsKey('max_price') == true) {
      url += '&max_price=${filter['max_price']}';
    }

    url += '&page=$page';

    print('url');
    print("-------$url");

    await ApiHandlerService().getCategoriesProduct(url).then((value) {
      if(value.isNotEmpty){
        //listCatData.value = value;
        listCatData.addAll(value);
        loading.value = false;

      } else {
        loading.value = false;
        if(page > 0){
          noDataFound = true;
        }
      }
    });
  }

  productSubCat({catId}) async {
    await ApiHandlerService().getSubCategoriesByID(catId: catId).then((proCatData) {
      listSubCatData = proCatData;
      //loading = false;
    });
  }

  Future<void> pullRefresh() async {
    //loading.value = true;
    await getProductList();
    await Future.delayed(const Duration(seconds: 1));
    //loading.value = false;
  }

  settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.all(0.0),
                  title: Container(
                    decoration: const BoxDecoration(),
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 4.0,
                          width: 60.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Sort By',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  subtitle: Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        children: colSort(context),
                      )),
                ),
              ],
            ),
          );
        });
  }

  List<Widget> colSort(context) {
    List<Widget> columnContent = [];
    for (var i = 0; i < _sortList.length; i++) {
      columnContent.add(getSortOrder(context, _sortList[i], i));
    }
    return columnContent;
  }

  Widget getSortOrder(context, String sortList, dynamic index) {
    var listKey = sortListMap['sort_by'][cOPTIONS].keys.toList();
    return Card(
      elevation: 0.0,
      color: (selectedSortBy.value == index)
          ? Theme.of(context).primaryColor
          : Colors.white,
      margin: const EdgeInsets.only(
        bottom: 1.0,
      ),
      child: ListTile(
        onTap: () {
          selectedSortBy.value = index;
          listCatData = [].obs;
          page = 1;
          Map<String, dynamic> sortFilters = {
            'sort_by': listKey[selectedSortBy.value],
          };
          filter.addAll(sortFilters);
          getProductList();
          Navigator.pop(context);
          loading.value = true;
        },
        title: RichText(
            text: TextSpan(
              text: sortList,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: (selectedSortBy.value == index) ? Colors.white : Colors.black,)
              /*style: TextStyle(
                  color: (selectedSortBy.value == index) ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),*/
            ),
        ),
      ),
    );
  }

  createOptions() {
    if ((sortListMap.containsKey('sort_by') == true) &&
        sortListMap['sort_by'].containsKey(cOPTIONS)) {
      if (sortListMap['sort_by'][cOPTIONS] is Map) {
        _sortList = sortListMap['sort_by'][cOPTIONS].values.toList();
      } else if (sortListMap['sort_by'][cOPTIONS] is List) {
        _sortList = sortListMap['sort_by'][cOPTIONS];
      }
    }
  }

  setFormSelectedValue() {
    if (filter != null) {
      if (filter.containsKey('sort_by') == true) {
        // Get a key of
        selectedSortBy.value = _sortList
            .indexOf(sortListMap['sort_by'][cOPTIONS][filter['sort_by']]);
      }
    }
  }
}