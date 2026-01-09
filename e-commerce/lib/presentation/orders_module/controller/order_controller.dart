import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_api_handler.dart';
import '../../../core/app_globals.dart' as global;

class OrderController extends GetxController with GetSingleTickerProviderStateMixin {

  final scrollController = ScrollController();

  List<Tab> myTabs = <Tab>[
    const Tab(
      text: 'Any',
    ),
     const Tab(
      text: 'Delivered',
    ),
    const Tab(
      text: 'Processing',
    ),
    const Tab(
      text: 'Pending',
    ),
    const Tab(
      text: 'Cancelled',
    ),
  ];

  RxBool loading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool noDataFound = false.obs;
  int selectedIndex = 0;
  RxInt page = 1.obs;
  RxList listOrderCatData = [].obs;
  RxMap mapOrderCatData = {}.obs;

  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: myTabs.length, vsync: this);
    scrollController.addListener(scrollListener);
    tabController.addListener(() async {
      if(tabController.indexIsChanging == false){
          loading.value = true;
          noDataFound.value = false;
          page.value = 1;
          mapOrderCatData.value = {};
          //listOrderCatData.value = [];
          selectedIndex = tabController.index;
          await getOrderData();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    listOrderCatData = [].obs;
    page = 1.obs;
    //tabController.dispose();
    super.onClose();
  }

  Future<void> scrollListener() async {
    if(isLoadingMore.isTrue) return;
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent && noDataFound.isFalse){
      isLoadingMore.value = true;
      page = page+1;
      await getOrderData();
      isLoadingMore.value = false;
    }
  }

  getOrderData() async {
    String passParam = 'any';
    if(selectedIndex == 1) {
      passParam = 'completed';
    } else if(selectedIndex == 2){
      passParam = 'processing';
    } else if(selectedIndex == 3){
      passParam = 'pending';
    } else if(selectedIndex == 4){
      passParam = 'cancelled';
    }
    await ApiHandlerService().getOrder(passData: passParam, userId: global.isUserData['ID'], page: page.toString()).then((orderData) {
      print(orderData);
      if(orderData.isNotEmpty){
        if(selectedIndex == 1) {
          passParam = 'delivered';
        }
        if(mapOrderCatData.containsKey(passParam)){
          mapOrderCatData[passParam].addAll(orderData);
        } else {
          mapOrderCatData.addAll({passParam : orderData});
        }

        /*for(var i=0; i < orderData.length; i++){
          if(orderData[i]['status'] == 'completed' ){
            mapOrderCatData.addAll({'delivered' : orderData});
          }

          if(orderData[i]['status'] == 'processing'){
            mapOrderCatData.addAll({'processing' : orderData});
          }

          if(orderData[i]['status'] == 'pending'){
            mapOrderCatData.addAll({'pending' : orderData});
          }

          if(orderData[i]['status'] == 'cancelled'){
            mapOrderCatData.addAll({'cancelled' : orderData});
          }
        }*/
        loading.value = false;
      } else {
        loading.value = false;
        if(page > 0){
          noDataFound.value = true;
        }
      }
      /*if(orderData.isNotEmpty){
        listOrderCatData.addAll(orderData);
        loading.value = false;
      } else {
        loading.value = false;
        if(page > 0){
          noDataFound.value = true;
        }
      }*/
    });
  }

  getOrderDataOld() async {
    String passParam = 'any';
    if(selectedIndex == 1) {
      passParam = 'completed';
    } else if(selectedIndex == 2){
      passParam = 'processing';
    } else if(selectedIndex == 3){
      passParam = 'pending';
    } else if(selectedIndex == 4){
      passParam = 'cancelled';
    }
    await ApiHandlerService().getOrder(passData: passParam, userId: global.isUserData['ID'], page: page.toString()).then((orderData) {
      if(orderData.isNotEmpty && page.value == 1){
        listOrderCatData.value = [];
        listOrderCatData.value = orderData;
        loading.value = false;
      } else if(orderData.isNotEmpty){
        listOrderCatData.addAll(orderData);
        loading.value = false;
      } else {
        loading.value = false;
        if(page > 0){
          noDataFound.value = true;
        }
      }
    });
  }

  Future<void> pullRefresh() async {
    await getOrderData();
    await Future.delayed(const Duration(seconds: 1));
  }
}