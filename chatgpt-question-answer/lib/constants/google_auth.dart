import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_data.dart';

class AuthenticationRepository {
  AuthenticationRepository();

  final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  // final appleSignIn = TheAppleSignIn();

  static GoogleSignInAccount? _user1;

  static GoogleSignInAccount get user => _user1!;

  Future<bool> checkUser() async {
    // User? user = FirebaseAuth.instance.currentUser;
    //
    // if(user != null){
    //   return true;
    // }
    return false;
  }

/*  Future<UserCredential?> signUpWithGmailId() async {
    return await googleSignIn.signIn().then((googleUser) async {
      if (googleUser != null) {
        _user1 = googleUser;
        SharedPreferences? preferences = await SharedPreferences.getInstance();
        preferences.setString(LocalData.appData['faUUID']!, _user1!.id);
        preferences.setString(LocalData.appData['faEmail']!, _user1!.email);
        // preferences.setString(Constants.faFullName, _user1!.);
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // print("Email: ${user.email.toString()}");
        // print(credential.toString());
        return await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          // print(value);
          return value;
        });
      }
      return null;
    });
  }*/

  Future<UserCredential?> signUpWithGmailId() async {
    return await googleSignIn.signIn().then((googleUser) async {
      if (googleUser != null) {
        _user1 = googleUser;
        SharedPreferences? preferences = await SharedPreferences.getInstance();
        preferences.setString(LocalData.appData['faUUID']!, _user1!.id);
        preferences.setString(LocalData.appData['faEmail']!, _user1!.email);
        // preferences.setString(Constants.faFullName, _user1!.);
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // print("Email: ${user.email.toString()}");
        // print(credential.toString());
        return await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          // print(value);
          return value;
        });
      }
      return null;
    });
  }

  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   String userEmail = "";
  //
  //   final loginResult = await FacebookAuth.instance
  //       .login(permissions: ['email', 'public_profile', 'user_birthday']);
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //   final userData = await FacebookAuth.instance.getUserData();
  //
  //   userEmail = userData['email'];
  //
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }
}
