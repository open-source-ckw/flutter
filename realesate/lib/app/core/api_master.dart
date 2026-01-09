import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'global.dart' as global;

class APIMaster {
  APIMaster() {}

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

  Future makePostRqst(String apiUrl, [Map<String, dynamic>? filters]) async {
    var url = Uri.parse(apiUrl);
    var response;

    print('------------ Map Post -----------');
    print(url);
    print(filters);
    if (global.connectionStatus != ConnectivityResult.none) {
      try {
        response = await http.post(url, body: filters);
      } catch (e) {}
    }
    return response;
  }
}
