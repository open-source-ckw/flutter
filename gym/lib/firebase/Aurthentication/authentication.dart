import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../Screens/SignInScreen.dart';
import '../../Util/Constants.dart';

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

  Future<UserCredential?> signUpWithGmailId() async {
    return await googleSignIn.signIn().then((googleUser) async {
      if (googleUser != null) {
        _user1 = googleUser;
        SharedPreferences? preferences = await SharedPreferences.getInstance();
        preferences.setString(Constants.faUUID, _user1!.id);
        preferences.setString(Constants.faEmail, _user1!.email);
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

/*  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile', 'user_birthday']
    );


    String userEmail = "";

    // Create a credential from the access token1
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final userData = await FacebookAuth.instance.getUserData();
    SharedPreferences? preferences = await SharedPreferences.getInstance();
    preferences.setString(Constants.faUUID, userData['id']);
    preferences.setString(Constants.faEmail, userData['email']);

    userEmail = userData['email'];

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }*/

// Future<void> signOutWithGmailId(context) async {
//
//   SharedPreferences sharedPreferences =
//   await SharedPreferences.getInstance();
//   sharedPreferences.clear();
//   DatabaseReference reference = FirebaseDatabase.instance.ref();
//   reference.onDisconnect();
//   googleSignIn.disconnect();
//   await googleSignIn.signOut()
//       .then((value) async {
//     Navigator.pushNamedAndRemoveUntil(
//         context, SignInScreen.route, (route) => false);
//       });
// }
}
