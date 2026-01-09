import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:stacks/consts.dart';
import 'package:stacks/routes/app_pages.dart';
import 'package:stacks/services/repository/home_repository.dart';
import 'package:stacks/theme/app_colors.dart';

class HomeController extends GetxController {
  var count = 0.obs;

  RxBool _loading = false.obs;
  RxBool _isList = true.obs;

  get loading => _loading.value;

  get isList => _isList.value;

  RxList _links = [].obs;
  RxList _searchLinks = [].obs;
  RxList _collectionsLinks = [].obs;
  RxList _placesLinks = [].obs;
  RxMap _collectionsLinksId = {}.obs;
  RxMap _linkDetails = {}.obs;
  RxMap _deleteLink = {}.obs;
  RxMap _latLng = {}.obs;

  List get links => _links;
  List get searchLinks => _searchLinks;
  List get collectionsLinks => _collectionsLinks;
  List get placesLinks => _placesLinks;
  Map get latLng => _latLng;
  Map get collectionsLinksId => _collectionsLinksId;
  Map get linkDetails => _linkDetails;
  Map get deleteLink => _deleteLink;

  set links(arr) {
   /* print(')))))))))))))))))))');
    print(arr);
    print(_links);*/
    _links.addAll(arr);
  }
  //set links(arr) => _links.addAll(arr);
  set searchLinks(arr) => _searchLinks(arr);
  set collectionsLinks(arr) => _collectionsLinks.addAll(arr);
  set placesLinks(arr) => _placesLinks(arr);
  set latLng(arr) => _latLng(arr);
  set collectionsLinksId(arr) => _collectionsLinksId.addAll(arr);
  set linkDetails(arr) => _linkDetails.addAll(arr);
  set deleteLink(arr) => _deleteLink.addAll(arr);

  RxInt _currentPage = 1.obs;
  set currentPage(val) => _currentPage.value = val;
  get currentPage => _currentPage.value;

  StreamSubscription? _intentDataStreamSubscription;
  static const platform = const MethodChannel('app.channel.shared.data');

  @override
  void onInit() async {
    _isList.value = GetStorage().read(VIEW) != null ? GetStorage().read(VIEW) : false;
    await getLinks();
    await getCollectionsLinks();

    update();
    super.onInit();
  }

  @override
  void onClose() async {
    _intentDataStreamSubscription?.cancel();
    super.onClose();
  }

  Future<void> getCollectionsLinks({passQueryString}) async {
    _loading.value = true;

    if(currentPage > 1) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('Loading more...')));
    }

    QueryResult? result = await HomeRepository().fetchCollectionsLinks(page: currentPage);

    _loading.value = false;


    if (result != null) {
      if(result.data != null) {
        collectionsLinks = result.data!['stacks'];
      }

      if(result.data == null) {
        currentPage = 0; ///Disable the page calls as there is no more data.
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('No more data found!')));
      }
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<void> getCollectionsLinksId({id}) async {
    _loading.value = true;

    if(currentPage > 1) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('Loading more...')));
    }

    QueryResult? result = await HomeRepository().fetchCollectionsLinksId(id: id);

    _loading.value = false;

    if (result != null) {
      if(result.data != null) {
        collectionsLinksId = result.data!['stack'];
      }

      if(result.data == null) {
        currentPage = 0; ///Disable the page calls as there is no more data.
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('No more data found!')));
      }
    }
  }

  Future<void> getLinks([bool refresh = false]) async {
    /*count++;
    links = [count];
    return;*/
    if(refresh == true){
      links = [].obs;
      _links = [].obs;
      currentPage = 1;
    }
    _loading.value = true;
    if(currentPage > 1) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('Loading more...')));
    }

    QueryResult? result = await HomeRepository().fetchLinks(page: currentPage);

    _loading.value = false;
     print(_loading.value);
    printWrapped(result.toString());
    printWrapped('+++++++++++++++++++ END ++++++++++++++++');
    if (result != null) {
      if(result.data != null) {
        links = result.data!['links'];
      }

      if(result.data == null) {
        currentPage = 0; ///Disable the page calls as there is no more data.
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('No more data found!')));
      }
    }
  }

  Future<void> getSearchLinks({passQueryString}) async {
    _loading.value = true;

    if(currentPage > 1) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('Loading more...')));
    }

    QueryResult? result = await HomeRepository().getSearchLink(page: currentPage, searchQuery: passQueryString);

    _loading.value = false;

    if (result != null) {
      if(result.data != null) {
        searchLinks = result.data!['links'];
      }

      if(result.data == null) {
        currentPage = 0; ///Disable the page calls as there is no more data.
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('No more data found!')));
      }
    }
  }

  Future<void> getLinkDetails({id}) async {
    _loading.value = true;

    if(currentPage > 1) {
      // Get.snackbar("Loading More...", "", backgroundColor: Colors.black, colorText: Colors.white, snackPosition:SnackPosition.BOTTOM);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('Loading more...')));
    }

    QueryResult? result = await HomeRepository().fetchLinkDetails(id: id);

    _loading.value = false;

    if (result != null) {
      if(result.data != null) {
        linkDetails = result.data!['link'];
      }

      if(result.data == null) {
        currentPage = 0; ///Disable the page calls as there is no more data.
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('No more data found!')));
      }
    }
  }

  Future<void> deleteLinks({id}) async {
    if(id != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('Are you sure? you want to remove this.'),
        action: SnackBarAction(
          label: 'Remove',
          textColor: primaryColor,
          onPressed: () async {
            _loading.value = true;

            QueryResult? result = await HomeRepository().deleteLinks(id: id);

            _loading.value = false;

            if (result != null) {
              if(result.data != null) {
                deleteLink = result.data;
              }
              await getLinks(true);
              update();

              if(result.data != null) {
                currentPage = 0; ///Disable the page calls as there is no more data.
                ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('Record are deleted!')));
              }
            }
          },
        ),
      ));
    }
  }

  Future<void> getPlacesLinks({passQueryString, mapBound}) async {
    _loading.value = true;

    if(currentPage > 1) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('Loading more...')));
    }

    QueryResult? result = await HomeRepository().getPlacesLinks(page: currentPage, mapBound: mapBound /*searchQuery: passQueryString*/ );

    _loading.value = false;
   /* printWrapped('+++++++++++++++++++ Start ++++++++++++++++');
    printWrapped(result.toString());
    printWrapped('+++++++++++++++++++ END ++++++++++++++++');*/
    if (result != null) {
      if(result.data != null) {
        placesLinks = result.data!['places'];
        if(placesLinks.isNotEmpty){
          latLng = {
            'lat' : placesLinks[0]['latitude'],
            'lng' : placesLinks[0]['longitude'],
          };
        }
      }

      if(placesLinks.isEmpty) {
        //currentPage = 0; ///Disable the page calls as there is no more data.
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('No Results. Zoom in or narrow your search.')));
      }
    }
  }

  Future<void> changePage(int val) async {
    switch (val) {
      case 0:
        if (Get.currentRoute != Routes.HOME) Get.offAllNamed(Routes.HOME);
        break;
      case 1:
        Get.toNamed(Routes.MAP);
        break;
      case 2:
        Get.toNamed(Routes.ACTIVITY);
        break;
      case 3:
        Get.toNamed(Routes.PROFILE);
        break;
    }
    update();
  }

  Future<void> changeView(int val) async {
    _isList.value = val == 0 ? true : false;
    GetStorage().write(VIEW, _isList.value);
    update();
  }

  receiveShareIntent() {
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) async {
      _loading.value = true;
      await _addLinks(value);
      _loading.value = false;
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
  }

  ///
  /// When app is not running
  getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedText");
    if (sharedData != null) {
      await _addLinks(sharedData);
    }
  }

  Future<void> _addLinks(String url) async {
    try {
      _loading.value = true;
      await HomeRepository().addLinkToUser(url);
      await getLinks();
      update();
      _loading.value = false;
    } catch (e) {
      printError(info: e.toString());
      Get.snackbar("Error", "Could not add your link this time.");
      _loading.value = false;
    }
  }
}
