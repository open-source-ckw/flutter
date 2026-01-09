import 'dart:convert';
import 'dart:io';

import 'app_api_master.dart';
import 'app_constant.dart';
import 'package:http/http.dart' as http;

class ApiHandlerService extends APIMaster {

  Future<List<dynamic>> getProducts() async {
    String url = 'products';
    Map<String, dynamic> passParam = {
      'orderby' : 'date',
      'consumer_key': wcConsumerKey,
      'consumer_secret': wcConsumerSecret,
    };
    var response = await makeGetRequestList(apiEndPoint: url, passParam: passParam);
    return response;
  }

  Future<List<dynamic>> getTrendyProducts() async {
    String url = 'products';
    Map<String, dynamic> passParam = {
      'orderby' : 'popularity',
      'consumer_key': wcConsumerKey,
      'consumer_secret': wcConsumerSecret,
    };
    var response = await makeGetRequestList(apiEndPoint: url, passParam: passParam);
    return response;
  }

  Future<Map<String, dynamic>> getProductWishList(String url) async {

    final String apiUrl = "https://wpdemo.thatsend.app/wp-json/custom/$url"+key;

    var response = await makeGetRqst(apiUrl);

    return response;
  }

  Future<List<dynamic>> getCategoriesProduct(filter) async {
    List<dynamic> getCategoriesProductList = [];

    /*String apiUrl =
        'https://wpdemo.thatsend.net/wp-json/wc/v3/products$filter&consumer_key=ck_b5ec0da1ca6d02240f9f0dfef0a3b72295d33492&consumer_secret=cs_0d569a96d2b06abb1ef706c5b3bb7dec44a7be3a';*/
    String apiUrl =
        'https://wpdemo.thatsend.app/wp-json/custom/getproduct$filter';

    var response = await makeGetRqstMap(apiUrl);

    if(response.containsKey('result') == true){
      getCategoriesProductList = response['result'];
    }
    return getCategoriesProductList;
  }

  Future<List<dynamic>> getCategoriesSearch(filter) async {
    List<dynamic> getCategoriesProductList = [];

    String apiUrl =
        'https://wpdemo.thatsend.app/wp-json/wc/v3/products$filter&consumer_key=ck_b5ec0da1ca6d02240f9f0dfef0a3b72295d33492&consumer_secret=cs_0d569a96d2b06abb1ef706c5b3bb7dec44a7be3a';

    var response = await makeGetRqstList(apiUrl);

    getCategoriesProductList = response;

    return getCategoriesProductList;
  }

  Future<List<dynamic>> getSubCategoriesByID({catId}) async {
     String url = 'products/categories';
    Map<String, dynamic> passParam = {
      'per_page': '100',
      'parent': catId.toString(),
      'consumer_key': wcConsumerKey,
      'consumer_secret': wcConsumerSecret,
    };
    var response = await makeGetRequestList(apiEndPoint: url, passParam: passParam);

    return response;
  }

  Future<List<dynamic>> getMainCategories() async {
    String url = 'products/categories';
    Map<String, dynamic> passParam = {
      'per_page': '20',
      'consumer_key': wcConsumerKey,
      'consumer_secret': wcConsumerSecret,
    };
    var response = await makeGetRequestList(apiEndPoint: url, passParam: passParam);

    return response;
  }

  Future<List<dynamic>> getProductAttributes(filter) async {
    String url = 'products/$filter';
    Map<String, dynamic> passParam = {
      'per_page': '100',
      'consumer_key': wcConsumerKey,
      'consumer_secret': wcConsumerSecret,
    };
    var response = await makeGetRequestList(apiEndPoint: url, passParam: passParam);
    return response;
  }

  Future<List<dynamic>> getProductVariation(pId) async {
    String url = 'products/'+ pId.toString() +'/variations';
    Map<String, dynamic> passParam = {
      'per_page': '100',
      'consumer_key': wcConsumerKey,
      'consumer_secret': wcConsumerSecret,
    };
    var response = await makeGetRequestList(apiEndPoint: url, passParam: passParam);
    return response;
  }

  Future<List<dynamic>> getProductDetailsAPI(filter) async {
    String url = 'products/';
    Map<String, dynamic> passParam = {
      'include': filter,
      'consumer_key': wcConsumerKey,
      'consumer_secret': wcConsumerSecret,
    };
    var response = await makeGetRequestList(apiEndPoint: url, passParam: passParam);
    return response;
  }

  Future<Map<String, dynamic>> getProductAddToCartItems(Map<String, dynamic> data) async {
    String url = 'getstockqty?';
    final String apiUrl = userCustomMainApiURL + url;
    var response = await makeCustomPostRequest(apiUrl, data);
    return response;
  }

  Future<List<dynamic>> getPaymentList() async {
    String url = 'payment_gateways';
    Map<String, dynamic> passParam = {
      'consumer_key': wcConsumerKey,
      'consumer_secret': wcConsumerSecret,
    };
    var response = await makeGetRequestList(apiEndPoint: url, passParam: passParam);
    return response;
  }

  Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> mapOrder) async {
    const String apiUrl = 'https://wpdemo.thatsend.app/wp-json/wc/v3/orders?' + key;
    var response = await makeCustomPostRequest(apiUrl, mapOrder);
    return response;
  }

  Future<List<dynamic>> getOrder({passData, userId, page}) async {

    String url = 'orders';
    Map<String, dynamic> passParam = {
      'consumer_key': wcConsumerKey,
      'consumer_secret': wcConsumerSecret,
      'status': passData,
      'customer': userId,
      'page': page,
      'order': 'desc',
      'orderby': 'date'
    };
    print('passParam');
    print(passParam);
    var response = await makeGetRequestList(apiEndPoint: url, passParam: passParam);

    return response;
  }

  Future<Map<String, dynamic>> updateOrder(String orderId,
      Map<String, dynamic> mapUpdateOrder) async {
    String apiUrl = 'https://wpdemo.thatsend.app/wp-json/wc/v3/orders/$orderId?' + key;
    var response = await makeCustomPutRequest(apiUrl, mapUpdateOrder);
    return response;
  }

  /// RazorPayAPI
  Future<Map<String, dynamic>> createOrderRazorPay(
      Map<String, dynamic> passRazorPayOrder) async {

    var apiUri = Uri(
        scheme: 'https',
        host: 'api.razorpay.com',
        path: 'v1/orders');

    var auth =
        'Basic ' + base64Encode(utf8.encode('$RAZORPAY_API_KEY:$RAZORPAY_SECRET_KEY'));

    var response =
    await http.post(apiUri, body: json.encode(passRazorPayOrder), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      'Authorization': auth,
    });
    var orderResponse = json.decode(response.body);
    return orderResponse;
  }

  Future<Map<String, dynamic>> getProductOrderListItems(Map<String, dynamic> data) async {
    String url  = 'getorderitems?';
    final String apiUrl = userCustomMainApiURL + url;
    var response = await makeCustomPostRequest(apiUrl, data);
    return response;
  }
}