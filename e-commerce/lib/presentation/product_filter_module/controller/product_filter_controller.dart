import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_api_handler.dart';
import '../../product_list_module/controller/product_list_controller.dart';

class ProductFilterController extends GetxController{

  final productListController = Get.put(ProductListController());

  RxBool loading = true.obs;
  bool loadingBody = false;
  double startValue = 0.00;
  double endValue = 5000.00;
  List<dynamic> filterList = [];
  List<dynamic> categoryTree = [];

  Map<String, dynamic> categoriesMap = {};
  Map<String, dynamic> variationList = {};
  Map<String, dynamic> colorsList = {};
  Map<String, dynamic> clothingSizeList = {};
  Map<String, dynamic> checkedFilters = {};
  Map<String, dynamic> selectedFilterType = {};
  Map<String, dynamic> selectedFilterTypeColor = {};
  Map<String, dynamic> listColor = {
    'Black': Colors.black,
    'Red': Colors.red,
    'Blue': Colors.blue,
    'White': Colors.white,
    'Pink': Colors.pink,
    'Yellow': Colors.yellow,
    'Dark blue': Colors.blue[900],
    'Dark green': Colors.green[900],
    'Green': Colors.green,
    'Grey': Colors.grey,
    'Indigo': Colors.indigo,
    'Light grey': Colors.grey[200],
    'Light pink': Colors.pink,
    'Lite green': Colors.green,
    'Multi Peach': Colors.deepOrange[300],
    'Navy blue': Colors.blue[600],
    'Olive': const Color(0xFFBAB86C),
    'Orange': Colors.orange,
    'Royal blue': Colors.blue[900],
    'Sky blue': Colors.lightBlue,
  };

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    //loading = true.obs;
    // TODO: implement onClose
    super.onClose();
  }

  /// API call of get filters.......
  getFilterList() async {
    await ApiHandlerService().getMainCategories().then((mainCategories) async {
      categoryTree = mainCategories;
    });

    if (colorsList.containsKey('Colors') == false) {
      await getFilterVariationByID(1).then((value) {
        colorsList.addAll({'Colors': value});
      });
    }

    if (clothingSizeList.containsKey('ClothingSize') == false) {
      await getFilterVariationByID(2).then((value) {
        clothingSizeList.addAll({'ClothingSize': value});
      });
    }

    loading.value = false;
  }

  Future<List<dynamic>> getFilterVariationByID(int id) async {
    if (id == null) return [];
    var url = 'attributes/' + '$id' + '/terms';
    List<dynamic> variationData = await ApiHandlerService().getProductAttributes(url);
    return variationData;
  }

  List<dynamic> buildTreeCategory(data, [parent = 0]) {
    List<dynamic> mData = [];
    for (int i = 0; i < data.length; i++) {
      // Preserve current data
      var row = data[i];

      // Check parent category
      if (row['parent'] == parent) {
        // Current record unset from main list
        data.remove(i);
        // Get all child category
        var cCat = buildTreeCategory(data, row['id']);

        if (cCat.isNotEmpty) {
          row.addAll({'CHILD': cCat});
        }
        mData.add(row);
      }
    }
    return mData;
  }
}