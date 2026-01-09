import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacks/consts.dart';
import 'package:stacks/services/auth_service.dart';
import 'package:stacks/services/repository/user_repository.dart';
import 'package:stacks/view/auth/login.dart';
import 'package:stacks/view/home.dart';

class AuthController extends GetxController {
  final authService = AuthService();
  final fb = FacebookLogin();
  final _googleSignin1 = GoogleSignIn(scopes: ["email", "profile"]);
  Rxn<User> firebaseUser = Rxn<User>();
  final box = GetStorage();

  Stream<User?> get currentUser => authService.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase user one-time fetch
  Future<User?> get getUser async => _auth.currentUser;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  ///
  /// Token
  final Rxn<String> _token = Rxn<String>(null);

  get token => _token.value;

  set token(value) => _token.value = value;

  @override
  void onReady() async {
    GetStorage().writeIfNull(VIEW, false);
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);
    firebaseUser.value = await getUser;
    firebaseUser.bindStream(user);
    super.onReady();
  }

  handleAuthChanged(_firebaseUser) async {
    if (_firebaseUser == null) {
      Get.offAll(() => Login());
    } else {
      box.write(PHOTO, _firebaseUser.photoURL.toString());
      box.write(NAME, _firebaseUser.displayName.toString());
      box.write(EMAIL, _firebaseUser.email.toString());
      box.write(UID, _firebaseUser.uid.toString());
      Get.offAll(() => Home());
    }
  }

  Future<void> graphDataAuthenticate({provider, appId, token}) async {

    bool hasToken = await UserRepository().hasToken('xAuthToken');
    if (hasToken) {
      return;
    }

    if (provider != null) {
      await UserRepository().addAccessToken("$provider|$token|$appId");
    } else {
      // store the access token form google or facebook to use later
      String? savedTokenValue = await UserRepository().getAccessToken();
      if (savedTokenValue != null) {
        token = savedTokenValue.split("|")[1];
        provider = savedTokenValue.split("|")[0];
        appId = savedTokenValue.split("|")[2];
      }
    }

    return await UserRepository().authenticate(provider: provider, appId: appId, token: token);
  }

  loginGoogle() async {
    print('--------- login google ---------');
    try {
      EasyLoading.show(maskType: EasyLoadingMaskType.black, dismissOnTap: false);

      print('1');

      final GoogleSignInAccount googleUser = (await _googleSignin1.signIn())!;

      print('2');
      print(googleUser);

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('3');
      print(googleAuth);

      final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      print('4');
      print(credential);

      //Firebase Sign in
      final UserCredential result = await authService.signInWithCredential(credential);

      print('5');
      print(result);

      // Set the login provider
      token = googleAuth.accessToken;

      print('6');
      print(token);

      await graphDataAuthenticate(provider: 'google_oauth2', appId: result.user!.uid, token: token);

      print('token' + token);

      EasyLoading.dismiss();
    } catch (error) {
      print('----------- testing ----------');
      printError(info: error.toString());
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }

  loginFacebook() async {
    try {
      EasyLoading.show(maskType: EasyLoadingMaskType.black, dismissOnTap: false);

      final res = await fb.logIn(permissions: [FacebookPermission.publicProfile, FacebookPermission.email]);

      switch (res.status) {
        case FacebookLoginStatus.success:
          //Get Token
          final FacebookAccessToken fbToken = res.accessToken!;

          //Convert to Auth Credential
          final AuthCredential credential = FacebookAuthProvider.credential(fbToken.token);

          //User Credential to Sign in with Firebase
          final result = await authService.signInWithCredential(credential);

          // Set the login provider
          token = fbToken.token;

          await graphDataAuthenticate(provider: 'facebook', appId: result.user!.uid, token: token);

          break;
        case FacebookLoginStatus.cancel:
          break;
        case FacebookLoginStatus.error:
          break;
      }
      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
    }
  }

  logout() async {
    await _deleteCacheDir();
    await _deleteAppDir();
    await authService.logout();
  }

  /// this will delete cache
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }

  /// this will delete app's storage
  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (await appDir.exists()) {
      await appDir.delete(recursive: true);
    }
  }
}
