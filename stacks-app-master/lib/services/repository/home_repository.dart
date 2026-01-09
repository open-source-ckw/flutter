import 'package:get/get.dart';
import "package:gql/ast.dart" as ast;
import "package:gql/language.dart" as lang;
import 'package:graphql_flutter/graphql_flutter.dart';
import "package:source_span/source_span.dart";
import 'package:stacks/controller/auth_controller.dart';
import 'package:stacks/services/graphql_operations/mutation/add_link_to_user.dart';
import 'package:stacks/services/graphql_operations/mutation/delete_link_to_user.dart';
import 'package:stacks/services/graphql_operations/query/fetch_links.dart';
import 'package:stacks/services/repository/user_repository.dart';

class HomeRepository {
  Future<GraphQLClient> _setUp() async {
    await AuthController().graphDataAuthenticate();

    String? token = await UserRepository().getToken('xAuthToken');

    print('token');
    print(token);

    HttpLink _link = HttpLink('https://betterstacks.com/graphql', defaultHeaders: {"X-Authorization": '$token' /*"Fx8hYL9mhYsYFexQpc6k"*/});

    GraphQLClient client = GraphQLClient(link: _link, cache: GraphQLCache(store: HiveStore()));

    return client;
  }

  Future<QueryResult?> fetchCollectionsLinks({int page = 1, int retry = 0}) async {
    try {
      GraphQLClient client = await _setUp();

      final QueryOptions _options = QueryOptions(
        document: gql(fetchCollectionsLinksQuery),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"page": page},
      );

      var result = await client.query(_options);
       /*if (result.data == null && retry < 2) {
         return await this.fetchCollectionsLinks(retry: retry + 1);
       }*/

      return result;
    } catch (e) {
      print("fetchCollectionsLinks Error: $e");
      // if (retry < 2) {
      //   await AuthController().graphDataAuthenticate();
      //   return await fetchLinks(retry: retry + 1);
      // }
    }
  }

  Future<QueryResult?> fetchCollectionsLinksId({id,int page = 1, int retry = 0}) async {
    try {
      GraphQLClient client = await _setUp();

      final QueryOptions _options = QueryOptions(
        document: gql(fetchCollectionsSingelLinksQuery),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"page": page, "id": id},
      );

      var result = await client.query(_options);
      /*if (result.data == null && retry < 2) {
        return await this.fetchCollectionsLinksId(retry: retry + 1);
      }*/

      return result;
    } catch (e) {
      print("fetchCollectionsLinksId Error: $e");
      // if (retry < 2) {
      //   await AuthController().graphDataAuthenticate();
      //   return await fetchLinks(retry: retry + 1);
      // }
    }
  }

  Future<QueryResult?> fetchLinks({int page = 1, int retry = 0}) async {
    print('============== fetch links ==========');
    try {
      GraphQLClient client = await _setUp();

      final QueryOptions _options = QueryOptions(
        document: gql(fetchLinksQuery),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"page": page},
      );

      var result = await client.query(_options);
       if (result.data == null && retry < 4) {
         print('_________fetchLinks retry ${retry}____________');
         return await this.fetchLinks(retry: retry + 1);
       }

      return result;
    } catch (e) {
      print("fetchLinks Error: $e");
       if (retry < 2) {
         print('------------graphDataAuthenticate------------');
         await AuthController().graphDataAuthenticate();
         return await fetchLinks(retry: retry + 1);
       }
    }
  }

  Future<QueryResult?> fetchLinkDetails({id, int retry = 0}) async {
    try {
      GraphQLClient client = await _setUp();

      final QueryOptions _options = QueryOptions(
        document: gql(getLinkDetailsByIdQuery),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"id": id},
      );

      var result = await client.query(_options);
      /*if (result.data == null && retry < 2) {
        return await this.fetchLinkDetails(retry: retry + 1);
      }*/

      return result;
    } catch (e) {
      print("fetchLinksDetails Error: $e");
    }
  }

  Future<QueryResult?> deleteLinks({id}) async {
    try {
      GraphQLClient client = await _setUp();

      final QueryOptions _options = QueryOptions(
        document: gql(deleteLinkToUserQuery),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"id": id},
      );

      var result = await client.query(_options);
      // if (result.data == null && retry < 2) {
      //   return await this.fetchLinks(retry: retry + 1);
      // }

      return result;
    } catch (e) {
      print("deleteLinks Error: $e");
      // if (retry < 2) {
      //   await AuthController().graphDataAuthenticate();
      //   return await fetchLinks(retry: retry + 1);
      // }
    }
  }

  Future<QueryResult> getLinkById(String id) async {
    GraphQLClient client = await _setUp();

    final ast.DocumentNode docNode = lang.parse(
      SourceFile.fromString(getLinkByIdQuery),
    );

    final QueryOptions _options = QueryOptions(document: docNode, variables: {'id': id});

    return await client.query(_options);
  }

  Future<QueryResult> addLinkToUser(String url) async {
    GraphQLClient client = await _setUp();

    RegExp exp = new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

    var matches = exp.firstMatch(url);

    url = url.substring(matches!.start, matches.end);

    final ast.DocumentNode docNode = lang.parse(
      SourceFile.fromString(addLinkToUserQuery),
    );

    final MutationOptions _options = MutationOptions(
      document: docNode,
      variables: <String, dynamic>{'target_url': url, 'latitude': 0.0, 'longitude': 0.0},
    );

    return await client.mutate(_options);
  }

  /// Search query
  Future<QueryResult?> getSearchLink({int page = 1, searchQuery,}) async {
    try {
      GraphQLClient client = await _setUp();

      final QueryOptions _options = QueryOptions(
        document: gql(getSearchLinkQuery),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"page": page, "query" : searchQuery},
      );

      var result = await client.query(_options);

      return result;
    } catch (e) {
      print("getSearchLink Error: $e");
    }
  }

  /// map places query
  Future<QueryResult?> getPlacesLinks({int page = 1, mapBound /*searchQuery,*/ }) async {
    try {
      GraphQLClient client = await _setUp();

      final QueryOptions _options = QueryOptions(
        document: gql(getPlacesLinksQuery),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"page": 1,  "boundary" : mapBound, /*"query" : searchQuery*/},
      );

      var result = await client.query(_options);

      return result;
    } catch (e) {
      print("getPlacesLinks Error: $e");
    }
  }

  Future<void> get logoutUser async {
    UserRepository().deleteToken('xAuthToken');
    AuthController authController = Get.find<AuthController>();
    authController.logout();
  }
}