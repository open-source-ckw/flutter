import 'package:get/get.dart';
import 'package:stacks/view/auth/login.dart';
import 'package:stacks/view/auth/splash.dart';
import 'package:stacks/view/fullview.dart';
import 'package:stacks/view/home.dart';
import 'package:stacks/view/notification_activity.dart';
import 'package:stacks/view/profile/about_us.dart';
import 'package:stacks/view/profile/privacy_policy.dart';
import 'package:stacks/view/profile/profile.dart';
import 'package:stacks/view/profile/social_accounts.dart';
import 'package:stacks/view/map.dart';
import 'package:stacks/view/profile/terms_conditions.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => Splash()),
    GetPage(name: Routes.LOGIN, page: () => Login()),
    GetPage(name: Routes.HOME, page: () => Home(), transition: Transition.fadeIn),
    GetPage(name: Routes.MAP, page: () => MapScreen(), transition: Transition.fadeIn),
    //GetPage(name: Routes.FullView, page: () => FullView(), transition: Transition.fadeIn),
    GetPage(name: Routes.PROFILE, page: () => Profile(), transition: Transition.fadeIn),
    GetPage(name: Routes.ACTIVITY, page: () => NotificationActivity(), transition: Transition.fadeIn),
    GetPage(name: Routes.SOCIAL_ACCOUNTS, page: () => SocialAccounts()),
    GetPage(name: Routes.ABOUT_US, page: () => AboutUs()),
    GetPage(name: Routes.TERMS_CONDITIONS, page: () => TermsConditions()),
    GetPage(name: Routes.PRIVACY_POLICY, page: () => PrivacyPolicy()),
  ];
}