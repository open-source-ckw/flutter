import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import "package:gql/ast.dart" as ast;
import "package:gql/language.dart" as lang;
import 'package:graphql_flutter/graphql_flutter.dart';
import "package:source_span/source_span.dart";
import 'package:stacks/routes/app_pages.dart';
import 'package:stacks/services/auth_service.dart';
import 'package:stacks/services/graphql_operations/mutation/user_sign_in.dart';

class UserRepository {
  late GraphQLClient client;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> authenticate({required String provider, required String appId, required token}) async {
    HttpLink _httpLink = HttpLink('https://betterstacks.com/graphql');

    final AuthLink _authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    final Link _link = _authLink.concat(_httpLink);

    client = GraphQLClient(link: _link, cache: GraphQLCache(store: HiveStore()));

    final ast.DocumentNode docNode = lang.parse(
      SourceFile.fromString(userSignIn),
    );

    final MutationOptions _options = MutationOptions(
      variables: <String, String>{'provider': provider, 'app_id': appId},
      document: docNode,
    );

    QueryResult ret = await client.mutate(_options);

    if (ret.data == null) {
      AuthService().logout();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar("Error", "Could not authenticate. Please try again.");
    }

    persistToken("xAuthToken", ret.data!['sign_in_user']!['token']);
  }

  Future<void> deleteToken(String key) async {
    await storage.delete(key: key);
    return;
  }

  Future<void> persistToken(String key, String token) async {
    await storage.write(key: key, value: token);
    return;
  }

  Future<bool> hasToken(String key) async {
    var token = await storage.read(key: key);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken(String key) async {
    return await storage.read(key: key);
  }

  Future<void> addAccessToken(token) async {
    print('------- token --------');
    print(token);
    return await storage.write(key: "accessToken", value: token);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: "accessToken");
  }

  Future<void> deleteAccessToken(String key) async {
    await storage.delete(key: "accessToken");
  }
}
