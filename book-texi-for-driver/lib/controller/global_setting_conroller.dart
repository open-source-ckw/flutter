import 'dart:convert';
import 'dart:developer';

import 'package:driver/constant/constant.dart';
import 'package:driver/model/currency_model.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/language_model.dart';
import 'package:driver/utils/Preferences.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../utils/DarkThemeProvider.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    notificationInit();
    getCurrentCurrency();
    getThemeMode();
    super.onInit();
  }

  getCurrentCurrency() async {
    if (Preferences.getString(Preferences.languageCodeKey)
        .toString()
        .isNotEmpty) {
      LanguageModel languageModel = Constant.getLanguage();

      ///LocalizationService().changeLocale(languageModel.code.toString());
    } else {
      /// Set default language selected.......
      Map<String, dynamic> defaultLanguage = {
        'image': "",
        'code': "en",
        'isDeleted': false,
        'enable': true,
        'name': "English",
        'id': "oKs39NhwMe7YsGRKLcFD",
        'isRtl': false
      };
      LanguageModel data = LanguageModel.fromJson(defaultLanguage);
      Preferences.setString(Preferences.languageCodeKey, jsonEncode(data));
    }

    await FireStoreUtils().getGoogleAPIKey();

    await FireStoreUtils().getCurrency().then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(
            id: "",
            code: "USD",
            decimalDigits: 2,
            enable: true,
            name: "US Dollar",
            symbol: "\$",
            symbolAtRight: false);
      }
    });
  }

  NotificationService notificationService = NotificationService();

  notificationInit() {
    notificationService.initInfo().then((value) async {
      String? token = await NotificationService.checkAndRegenerateToken();
      log(":::::::TOKEN:::::: $token");

      if (FirebaseAuth.instance.currentUser != null) {
        await FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid())
            .then((value) {
          if (value != null) {
            DriverUserModel driverUserModel = value;
            driverUserModel.fcmToken = token;
            FireStoreUtils.updateDriverUser(driverUserModel);
          }
        });
      }
    });
  }

  getThemeMode() async {
    DarkThemeProvider themeChangeProvider = DarkThemeProvider();
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
    String value = 'System';
    if (themeChangeProvider.darkTheme == 0) {
      //themeChange.darkTheme = 0;
      value = 'Dark mode';
    } else if (themeChangeProvider.darkTheme == 1) {
      //themeChange.darkTheme = 1;
      value = 'Light mode';
    } else {
      //themeChange.darkTheme = 2;
      value = 'System';
      //themeChangeProvider.darkTheme = 2;
    }
    Preferences.setString(
      Preferences.themKey,
      value.toString(),
    );
  }
}
