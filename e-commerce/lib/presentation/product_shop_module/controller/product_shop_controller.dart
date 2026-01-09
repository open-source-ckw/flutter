import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_api_handler.dart';

class ProductShopController extends GetxController with GetSingleTickerProviderStateMixin{

  RxBool loading = true.obs;
  RxList listCategoryList = [].obs;
  RxMap mapListSubCategoryData = {}.obs;

  List<Tab> myTabs = <Tab>[
    const Tab(text: 'Women'),
    const Tab(text: 'Men'),
  ];

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  getCategoryListData() async {
    await ApiHandlerService().getSubCategoriesByID(catId: 0).then((categoryListData) {
      listCategoryList.value = categoryListData;
      for(var i=0; i<categoryListData.length; i++){
        getSubCategoryListData(catId: categoryListData[i]['id'], catName: categoryListData[i]['name']);
      }
      //loading.value = false;
    });
  }

  getSubCategoryListData({catId, catName}) async {
    await ApiHandlerService().getSubCategoriesByID(catId: catId).then((subCategoryListData) {
      mapListSubCategoryData.addAll({catName : subCategoryListData});
      loading.value = false;
    });
  }
}