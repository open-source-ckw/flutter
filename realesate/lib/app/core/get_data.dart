import 'dart:convert';
import 'api_master.dart';
import 'net_response.dart';
import 'global.dart' as global;
import 'constant.dart';

class SearchResult extends APIMaster {
  Future<List> getSuggestions(String query) async {
    List returnList = [];
    Map<String, dynamic> f_data = {"keywords": query};

    var post = {
      module: "search", ///address
      action: "autosuggestion",
      "key": API_KEY,
      "filter": jsonEncode(f_data),
    };

    var response = await this.makePostRqst(
        global.mapConfige['url_api_domain'] + global.optUrl, post);
    if (NetworkUtils.isReqSuccess(response) == true) {
      var mapData = jsonDecode(response.body.toString());
      // Check response is success then return the data
      if (mapData['Status'] == 'Success') {
        returnList = mapData['Result'];
      }
    } else {
      // TODO: If not get success response then do some logic here
    }
    return returnList;
  }

  Future<Map<String, dynamic>> getListData(
      [Map<String, dynamic>? filter]) async {
    Map<String, dynamic> returnMap = {};
    var post = {
      module: "listing",
      action: "searchdata",
      "key": API_KEY,
      "filter": jsonEncode(filter),
    };

    print('--------------------------------');
    print(global.mapConfige['url_api_domain'] + global.optUrl);
    print(post);

    var response = await this.makePostRqst(
        global.mapConfige['url_api_domain'] + global.optUrl, post);

    if (NetworkUtils.isReqSuccess(response) == true) {
      var mapData = jsonDecode(response.body.toString());
      // Check response is success then return the data

      if (mapData['Status'] == 'Success') returnMap = mapData['Result'];
    } else {
      // TODO: If not get success response then do some logic here
    }
    return returnMap;
  }

  Future<Map<String, dynamic>> getDelScreen(
      [Map<String, dynamic>? filter]) async {
    Map<String, dynamic> returnMap = {};
    //Future<bool> retunData;
    var post = {
      module: "listing",
      action: "fulldata",
      "key": API_KEY,
      "filter": jsonEncode(filter),
    };
    var response = await this.makePostRqst(
        global.mapConfige['url_api_domain'] + global.optUrl, post);
    if (NetworkUtils.isReqSuccess(response) == true) {
      var dlsData = jsonDecode(response.body.toString());

      // Check response is success then return the data
      if (dlsData['Status'] == 'Success') {
        returnMap = dlsData['Result'];
      }
    } else {
      // TODO: If not get success response then do some logic here
    }
    return returnMap;
  }

  Future<Map<String, dynamic>> getPropType() async {
    Map<String, dynamic> returnMap = {};
    var post = {
      module: "property",
      action: "gettype",
      "key": API_KEY,
    };
    var response = await this.makePostRqst(
        global.mapConfige['url_api_domain'] + global.optUrl, post);

    if (NetworkUtils.isReqSuccess(response) == true) {
      var dlsData = jsonDecode(response.body.toString());
      // Check response is success then return the data
      if (dlsData['Status'] == 'Success') {
        returnMap = dlsData['Result'];
      }
    } else {
      // TODO: If not get success response then do some logic here
    }
    return returnMap;
  }

  Future<Map> getInquiryUserData(String module, String action,
      [Map<String, dynamic>? filter]) async {
    Map returnMap = {};
    var post = {
      module: module, //"user",
      action: action, //"inquiry",
      "key": API_KEY,
      "filter": jsonEncode(filter),
    };
    var response = await this.makePostRqst(
        global.mapConfige['url_api_domain'] + global.optUrl, post);

    if (NetworkUtils.isReqSuccess(response) == true) {
      var mapData = jsonDecode(response.body.toString());
      // Check response is success then return the data
      if (mapData['Status'] == 'Success') {
        returnMap = mapData['Result'];
      }
    } else {
      // TODO: If not get success response then do some logic here
    }
    return returnMap;
  }

  Future<Map<String, dynamic>> getSeduleUserData(
      [Map<String, dynamic>? filter]) async {
    Map<String, dynamic> returnMap = {};
    var post = {
      module: "user",
      action: "schedule",
      "key": API_KEY,
      "filter": jsonEncode(filter),
    };
    var response = await this.makePostRqst(
        global.mapConfige['url_api_domain'] + global.optUrl, post);

    if (NetworkUtils.isReqSuccess(response) == true) {
      var scheduleData = jsonDecode(response.body.toString());
      // Check response is success then return the data
      if (scheduleData['Status'] == 'Success') {
        returnMap = scheduleData['Result'];
      }
    } else {
      // TODO: If not get success response then do some logic here
    }
    return returnMap;
  }

  Future<Map<String, dynamic>> getFilterData() async {
    Map<String, dynamic> returnMap = {};
    var post = {
      module: "property",
      action: "searchfilters",
      "key": API_KEY,
    };
    var response = await this.makePostRqst(
        global.mapConfige['url_api_domain'] + global.optUrl, post);

    if (NetworkUtils.isReqSuccess(response) == true) {
      var filterData = jsonDecode(response.body.toString());
      // Check response is success then return the data
      if (filterData['Status'] == 'Success') {
        returnMap = filterData['Result'];
      }
    } else {
      // TODO: If not get success response then do some logic here
    }
    return returnMap;
  }

  Future<Map<String, dynamic>> getAdvanceFilterData(
      [Map<String, dynamic>? filter]) async {
    Map<String, dynamic> returnMap = {};

    var post = {
      module: "property",
      action: "advancedsearch",
      "key": API_KEY,
      "filter": jsonEncode(filter),
    };
    var response = await this.makePostRqst(
        global.mapConfige['url_api_domain'] + global.optUrl, post);

    if (NetworkUtils.isReqSuccess(response) == true) {
      var adfilterData = jsonDecode(response.body.toString());
      // Check response is success then return the data
      if (adfilterData['Status'] == 'Success') {
        returnMap = adfilterData['Result'];
      }
    } else {
      // TODO: If not get success response then do some logic here
    }
    return returnMap;
  }
}
