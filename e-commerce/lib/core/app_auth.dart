import 'app_api_master.dart';
import 'app_constant.dart';

class UserAuthService extends APIMaster {

  Future<Map<String, dynamic>> userLogin(Map<String, dynamic> data) async {
    String url = 'login';
    final String apiUrl = userCustomMainApiURL + url;
    var response = await makePostRequest(apiUrl, data);
    return response;
  }

  Future<Map<String, dynamic>> userSignUp(Map<String, dynamic> data) async {
    String url = 'users';
    final String apiUrl = wordpressAPIURL + url;
    /// Auth used credentials for backend.....
    var response = await makePostRequestWithAuth(apiUrl, data);
    return response;
  }

  Future<Map<String, dynamic>> userEditSignUp(Map<String, dynamic> data) async {
    String url = "users/"+data['id'];
    final String apiUrl = wordpressAPIURL + url;
    /// Auth used credentials for backend.....
    var response = await makePostRequestWithAuth(apiUrl, data);
    return response;
  }

  Future<Map<String, dynamic>> userForgotPassword(Map<String, dynamic> data) async {
    String url = 'forgot_password';
    final String apiUrl = userCustomMainApiURL + url;
    var response = await makePostRequest(apiUrl, data);
    return response;
  }

  Future<Map<String, dynamic>> userFavorites(Map<String, dynamic> data) async {
    String url = 'add-fav';
    final String apiUrl = userCustomMainApiURL + url;
    var response = await makePostRequest(apiUrl, data);
    return response;
  }

  Future<Map<String, dynamic>> userRemoveFavorites(Map<String, dynamic> data) async {
    String url = 'remove-fav';
    final String apiUrl = userCustomMainApiURL + url;
    var response = await makePostRequest(apiUrl, data);
    return response;
  }

  Future<Map<String, dynamic>> getCustomer({required String userID}) async {
    final String apiUrl = 'https://wpdemo.thatsend.app/wp-json/wc/v3/customers/$userID?'+key;
    var response = await makeGetRqst(apiUrl);
    return response;
  }

  Future<List<dynamic>> getWebPages() async {
    String url = 'pages';
    final String apiUrl = wordpressAPIURL + url;
    /// Auth used credentials for backend.....
    var response = await makeGetRequestWithAuth(apiUrl);
    return response;
  }

  /// -------- Delete user account -------
  Future<Map<String, dynamic>> userDeleteAccount(Map<String, dynamic> data) async {
    String url = "users/"+data['id'];
    final String apiUrl = wordpressAPIURL + url;
    /// Auth used credentials for backend.....
    var response = await makePostDeleteRequestWithAuth(apiUrl, data);
    return response;
  }

  Future<Map<String, dynamic>> userEditCustomer({ required Map<String, dynamic> data}) async {

    final String apiUrl = 'https://wpdemo.thatsend.app/wp-json/wc/v3/customers/${data['id']}?'+key;
    var response = await makeCustomPostRequest(apiUrl, data);
    return response;
  }
}