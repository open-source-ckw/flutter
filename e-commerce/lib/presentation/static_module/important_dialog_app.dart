import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_constant.dart';

importantDialogApp(){
  Get.defaultDialog(
      contentPadding: const EdgeInsets.all(10.0),
      title: "Important",
      //middleText: "Fashion is our demonstration app for vendors. If you are interested and impressed with our app and have to build your own, please get in touch with us at sales@thatsend.com email and +91-87590-08991 mobile.",
      backgroundColor: Colors.black,
      titleStyle: const TextStyle(color: Colors.white),
      middleTextStyle: const TextStyle(color: Colors.white),
      textConfirm: "Contact Us",
      textCancel: "Cancel",
      cancelTextColor: Colors.white,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      barrierDismissible: true,
      radius: 50,
      onConfirm: (){
        _launchAsInAppWebViewWithCustomHeaders(Uri(scheme: companyScheme, host: companyHost, path: companyPath));
      },
      content: Column(
        children: [
          Text.rich(
            TextSpan(
              text: 'Fashionia is our demonstration app for vendors. If you are interested and impressed with our app and have to build your own, please get in touch with us at ',
              style: const TextStyle(fontSize: 20, color: Colors.white),
              children: [
                TextSpan(
                  text: 'sales@thatsend.com ',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    String email = Uri.encodeComponent("sales@thatsend.com");
                    String subject = Uri.encodeComponent("Hello fashionia");
                    String body = Uri.encodeComponent("Hi! I'm using your fashionia app. I'm impressed to use your app. I'm planning to have to build my own app.");
                    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
                    if (await launchUrl(mail)) {
                    //email app opened
                    }else{
                    //email app is not opened
                    }
                  },
                ),
                const TextSpan(
                  text: 'email and ',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: '+91-87590-08991 ',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    _makePhoneCall('+918759008991');
                  },
                ),
                const TextSpan(
                  text: 'mobile.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      )
  );
}


Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch $launchUrl';
  }
}

Future<void> _launchAsInAppWebViewWithCustomHeaders(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
    throw Exception('Could not launch $url');
  }
}