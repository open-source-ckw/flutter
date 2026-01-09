import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'app_constant.dart';
import 'app_net_response.dart';

class APIMaster {
  APIMaster();

  Future<Map<String, dynamic>> makeGetRequestMap({apiUrl, passParam}) async {
    Map<String, dynamic> mapData = {};
    var apiUrl = Uri(
        scheme: wcScheme,
        host: wcHost,
        path: wcPath + 'products',
        queryParameters: {
          'consumer_key': wcConsumerKey,
          'consumer_secret': wcConsumerSecret,
          'orderby': 'date'
        });
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      if (response.body != '') {
        mapData = jsonDecode(response.body);
      }
    }
    return mapData;
  }

  Future<List<dynamic>> makeGetRequestList({required String apiEndPoint, required Map<String, dynamic> passParam}) async {
    List<dynamic> listData = [];
    var apiUrl = Uri(
        scheme: wcScheme,
        host: wcHost,
        path: wcPath + apiEndPoint,
        queryParameters: passParam);

    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      if (response.body != '') {
        listData = jsonDecode(response.body);
      }
    }
    return listData;
  }

  Future<Map<String, dynamic>> makeGetRqst(String apiUrl) async {
    Map<String, dynamic> mapData = {};
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body != '') {
        mapData = jsonDecode(response.body);
      }
    }
    return mapData;
  }

  Future<Map<String, dynamic>> makeGetRqstMap(String apiUrl) async {
    Map<String, dynamic> mapData = {};
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body != '') {
        mapData = jsonDecode(response.body);
      }
    }
    return mapData;
  }

  Future<List<dynamic>> makeGetRqstList(String apiUrl) async {
    List<dynamic> listData = [];
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body != '') {
        listData = jsonDecode(response.body);
      }
    }
    return listData;
  }

  Future<List<dynamic>> makeGetRequestWithAuth(String apiUrl, [Map<String, dynamic>? filters]) async {
    var url = Uri.parse(apiUrl);
    List<dynamic> listData = [];
    var response;
    //   if (global.connectionStatus != ConnectivityResult.none) {
    try {
      response = await http.get(
          url,
          headers: {HttpHeaders.authorizationHeader: administrativeBasicAuth}
      );
      if (NetworkUtils.isReqSuccess(response)) {
        if (response.body != '') {
          listData = jsonDecode(response.body);
        }
      } else {
        listData = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    //  }
    return listData;
  }

  Future<Map<String, dynamic>> makePostRequest(String apiUrl, [Map<String, dynamic>? filters]) async {
    var url = Uri.parse(apiUrl);
    Map<String, dynamic> mapData = {};
    var response;
 //   if (global.connectionStatus != ConnectivityResult.none) {
      try {
        response = await http.post(
          url,
          body: filters,
        );
        if (NetworkUtils.isReqSuccess(response)) {
          if (response.body != '') {
            mapData = jsonDecode(response.body);
          }
        } else {
          mapData = jsonDecode(response.body);
        }
      } catch (e) {
        print(e);
      }
  //  }
    return mapData;
  }

  Future<Map<String, dynamic>> makePostRequestWithAuth(String apiUrl, [Map<String, dynamic>? filters]) async {
    var url = Uri.parse(apiUrl);
    Map<String, dynamic> mapData = {};
    var response;
    //   if (global.connectionStatus != ConnectivityResult.none) {
    try {
      response = await http.post(
        url,
        body: filters,
        headers: {HttpHeaders.authorizationHeader: administrativeBasicAuth}
      );
      if (NetworkUtils.isReqSuccess(response)) {
        if (response.body != '') {
          mapData = jsonDecode(response.body);
        }
      } else {
        mapData = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    //  }
    return mapData;
  }

  Future<Map<String, dynamic>> makePostDeleteRequestWithAuth(String apiUrl, [Map<String, dynamic>? filters]) async {
    var url = Uri.parse(apiUrl);
    Map<String, dynamic> mapData = {};
    var response;
    //   if (global.connectionStatus != ConnectivityResult.none) {
    try {
      response = await http.delete(
          url,
          body: filters,
          headers: {HttpHeaders.authorizationHeader: administrativeBasicAuth}
      );
      if (NetworkUtils.isReqSuccess(response)) {
        if (response.body != '') {
          mapData = jsonDecode(response.body);
        }
      } else {
        mapData = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    //  }
    return mapData;
  }

  Future<Map<String, dynamic>> makeCustomPostRequest(String apiUrl, [Map<String, dynamic>? filters]) async {
    var url = Uri.parse(apiUrl);
    Map<String, dynamic> mapData = {};
    var response;
    //   if (global.connectionStatus != ConnectivityResult.none) {
    try {
      response = await http.post(
        url,
        body: json.encode(filters),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }
      );
      if (NetworkUtils.isReqSuccess(response)) {
        if (response.body != '') {
          mapData = jsonDecode(response.body);
        }
      } else {
        mapData = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    //  }
    return mapData;
  }

  Future<Map<String, dynamic>> makeCustomPutRequest(String apiUrl, [Map<String, dynamic>? filters]) async {
    var url = Uri.parse(apiUrl);
    Map<String, dynamic> mapData = {};
    var response;
    //   if (global.connectionStatus != ConnectivityResult.none) {
    try {
      response = await http.put(
          url,
          body: json.encode(filters),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }
      );
      if (NetworkUtils.isReqSuccess(response)) {
        if (response.body != '') {
          mapData = jsonDecode(response.body);
        }
      } else {
        mapData = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    //  }
    return mapData;
  }
}
