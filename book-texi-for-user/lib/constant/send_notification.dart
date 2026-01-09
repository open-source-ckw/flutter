// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:customer/constant/constant.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

// class SendNotification {
//   static sendOneNotification({required String token, required String title, required String body, required Map<String, dynamic> payload}) async {
//     print(payload);
//     http.Response response = await http.post(
//       Uri.parse('https://fcm.googleapis.com/fcm/send'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'key=${Constant.serverKey}',
//       },
//       body: jsonEncode(
//         <String, dynamic>{
//           'notification': <String, dynamic>{'body': body, 'title': title},
//           'priority': 'high',
//           'data': payload,
//           'to': token
//         },
//       ),
//     );
//     log(response.body);
//   }
// }

// New Notification code.

String constructFCMPayload(String token, String title, String body, Map<String, dynamic> payload) {
  log("token-=-=-----------------------------------$token");

  return jsonEncode({
    "message": {
      "token": token,
      "notification": {'title': title, 'body': body},
      "data": payload
    },
  });
}

class SendNotification {
  static sendOneNotification({required String token, required String title, required String body, required Map<String, dynamic> payload}) async {
    print(payload);
    final String serverAccessToken = await getServerAccessToken();
    http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/driverapp-b9e74/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessToken',
      },
      body: constructFCMPayload(token, title, body, payload),
    );
    log(response.body);
  }
}



// This helps generate a bearer token, which is useful for sending notifications.
Future<String> getServerAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "driverapp-b9e74",
    "private_key_id": "0e5f94e8df98108622ec334e2e6d0d4b93750134",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC0jryXDLpr4kdE\nrUY31/VJEDs6fRz64wbycQ69h5eiq7KOEgWJkS+lQkoCj4GSoiAtE+E/ZIOHUMN+\nLHh2Tgtc55HGQx2vsw/ffODy8rSNCp3NxyBkPXwOZzj1WiHyqAQYZGFjhdChWCe5\nQE3Xgn+lTTrcfBsiHO5wpXztde4Zxkl/Nl7p4lJllLbNTCHzPwZmaxE9yvBB540g\nvwBUMjMCHA3QbfXx0qZLATl1vILQJaJuRA2+yyCJI0ivftcsqkxMKCswIIbMK3rN\n5zb/l/wH8/dZGnM6qsBJoT7rvcAyUaBl6XVd65aPw6Eqj8kbjzGSv32IQ8UVDO/l\nVMZuwVR/AgMBAAECggEAAyHq0bAN1+tQEzfyXOupPMBEVspu40dnCnO9rroYfmD+\nMwrK/8z+B57zy8GTnOilKEMNCF2FDqbvDVRWLq9B8TWvSMJHVJIFt3niKTTevwet\nHzHSNQsACPvveAo9Rol1sLqlGeXrbbEq10LvVsrTzhld6Q9aJShdVqT4WuJN5DKO\nA6BHhsAeIt8q+AsXvAEoHQy7dXVmlGALbtTAe5i7YN3jefNBDFYvElygboWj9t2v\noJQbqexxcaV4zAMzH+RRmamRxCimox7cz/PL16b9lVWhtTZyS6F8Ztu3Fwd5qh9u\nl3Vgl1ARLbOsthQsAAVzGKgfarXwDP2ZzjzLM+iNCQKBgQDSLMEmUDzYrcK72TsW\nKxO7dobHNYGRxUxLDROtHX1LYuNTbJjy0npJ2l712+T67jfCMRSl2gGlILWdxC6H\nDlPLvBEq4jIHEN5QXjMvxef83c/ETSqBmzt59Ngi947gvJ1EOzuKQeeDJS/qjTfb\n/EuSmkJAAQrAEFB69+jok1qiJQKBgQDb7NjuEUiDLUg40rrcs+4GN/nKGhr6kaFh\nZrWciRCMTMFRus1beZRinxVdPClgl3ti/m1EwzcMnK7cy1e2UVkX3tsDhIzT/Zv8\nGKgkK1C0HXv/+MOzAzohjbkiinVqPr7ICkOidFpsoRjpVGt/NBoqiso59pgWmL2g\n3m0eUW/w0wKBgF1s3370c9ethb6S1Z0JEQBns4mh0zLFDSDfczukvClij8Jpp6No\nxEtH8qY/VQ3mDosX3iHLQqfwXkr/Bd+rEryhoM/7NFnHucrn1MELrA/PWafc1WQ/\naLTRjbIdcTmdHhtSaSkQGqVFRoNwur/i6oUEZSamT+0IU34V7UZVGhixAoGAMJ/r\nTqevmqE2aKne+tElfWZ+6fpfoKr2PWzSFqwPZpXJ4GIm6WS2NB/sP1L/6wVTGI4c\nZqmq0DUMTHEBEaRmyGpTjjGOWYinJlPlSSnyjABA3FWKH1hFUAnftw1Z7IW29M+g\nKJkFLSNpOJ2bruI8Ls/E6o/lDIn0006aXauvzlUCgYEAu58l+wwRPnQ5nduoY37E\nCt+Y6vSArlua3ILasCIHVfS3/TDgY6DQ9mKHGydq0fgVaNbdiJSmYneUD0IPn4lL\nYmNQrc+n0tDOfEplCO/AgRuiZ6iJ3OLMm3qRUfnLh6NO6StWX3ioBeu2Gra7MtVU\nxkqjkGbTOJQ/DEPWAMPiWh8=\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-eyafs@driverapp-b9e74.iam.gserviceaccount.com",
    "client_id": "111480319522153956075",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-eyafs%40driverapp-b9e74.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  List<String> scopes = [
    "https://www.googleapis.com/auth/firebase.messaging",
    "https://www.googleapis.com/auth/firebase.database",
  ];

  http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );

// Get Access Token
  auth.AccessCredentials credentials =
  await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client);
  client.close();
  final String bearerToken = credentials.accessToken.data;
  log("log server bearer token:--    $bearerToken");
  return bearerToken;
}

/*

Future<String> getServerAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "driverapp-b9e74",
    "private_key_id": "0e5f94e8df98108622ec334e2e6d0d4b93750134",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC0jryXDLpr4kdE\nrUY31/VJEDs6fRz64wbycQ69h5eiq7KOEgWJkS+lQkoCj4GSoiAtE+E/ZIOHUMN+\nLHh2Tgtc55HGQx2vsw/ffODy8rSNCp3NxyBkPXwOZzj1WiHyqAQYZGFjhdChWCe5\nQE3Xgn+lTTrcfBsiHO5wpXztde4Zxkl/Nl7p4lJllLbNTCHzPwZmaxE9yvBB540g\nvwBUMjMCHA3QbfXx0qZLATl1vILQJaJuRA2+yyCJI0ivftcsqkxMKCswIIbMK3rN\n5zb/l/wH8/dZGnM6qsBJoT7rvcAyUaBl6XVd65aPw6Eqj8kbjzGSv32IQ8UVDO/l\nVMZuwVR/AgMBAAECggEAAyHq0bAN1+tQEzfyXOupPMBEVspu40dnCnO9rroYfmD+\nMwrK/8z+B57zy8GTnOilKEMNCF2FDqbvDVRWLq9B8TWvSMJHVJIFt3niKTTevwet\nHzHSNQsACPvveAo9Rol1sLqlGeXrbbEq10LvVsrTzhld6Q9aJShdVqT4WuJN5DKO\nA6BHhsAeIt8q+AsXvAEoHQy7dXVmlGALbtTAe5i7YN3jefNBDFYvElygboWj9t2v\noJQbqexxcaV4zAMzH+RRmamRxCimox7cz/PL16b9lVWhtTZyS6F8Ztu3Fwd5qh9u\nl3Vgl1ARLbOsthQsAAVzGKgfarXwDP2ZzjzLM+iNCQKBgQDSLMEmUDzYrcK72TsW\nKxO7dobHNYGRxUxLDROtHX1LYuNTbJjy0npJ2l712+T67jfCMRSl2gGlILWdxC6H\nDlPLvBEq4jIHEN5QXjMvxef83c/ETSqBmzt59Ngi947gvJ1EOzuKQeeDJS/qjTfb\n/EuSmkJAAQrAEFB69+jok1qiJQKBgQDb7NjuEUiDLUg40rrcs+4GN/nKGhr6kaFh\nZrWciRCMTMFRus1beZRinxVdPClgl3ti/m1EwzcMnK7cy1e2UVkX3tsDhIzT/Zv8\nGKgkK1C0HXv/+MOzAzohjbkiinVqPr7ICkOidFpsoRjpVGt/NBoqiso59pgWmL2g\n3m0eUW/w0wKBgF1s3370c9ethb6S1Z0JEQBns4mh0zLFDSDfczukvClij8Jpp6No\nxEtH8qY/VQ3mDosX3iHLQqfwXkr/Bd+rEryhoM/7NFnHucrn1MELrA/PWafc1WQ/\naLTRjbIdcTmdHhtSaSkQGqVFRoNwur/i6oUEZSamT+0IU34V7UZVGhixAoGAMJ/r\nTqevmqE2aKne+tElfWZ+6fpfoKr2PWzSFqwPZpXJ4GIm6WS2NB/sP1L/6wVTGI4c\nZqmq0DUMTHEBEaRmyGpTjjGOWYinJlPlSSnyjABA3FWKH1hFUAnftw1Z7IW29M+g\nKJkFLSNpOJ2bruI8Ls/E6o/lDIn0006aXauvzlUCgYEAu58l+wwRPnQ5nduoY37E\nCt+Y6vSArlua3ILasCIHVfS3/TDgY6DQ9mKHGydq0fgVaNbdiJSmYneUD0IPn4lL\nYmNQrc+n0tDOfEplCO/AgRuiZ6iJ3OLMm3qRUfnLh6NO6StWX3ioBeu2Gra7MtVU\nxkqjkGbTOJQ/DEPWAMPiWh8=\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-eyafs@driverapp-b9e74.iam.gserviceaccount.com",
    "client_id": "111480319522153956075",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-eyafs%40driverapp-b9e74.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  List<String> scopes = [
    "https://www.googleapis.com/auth/firebase.messaging",
    "https://www.googleapis.com/auth/firebase.database",
  ];

  http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );

// Get Access Token
  auth.AccessCredentials credentials =
  await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client);
  client.close();
  final String bearerToken = credentials.accessToken.data;
  print("log server bearer token:--    $bearerToken");
  return bearerToken;
}

 */