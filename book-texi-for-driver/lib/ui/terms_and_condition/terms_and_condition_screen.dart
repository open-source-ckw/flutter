import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../themes/app_colors.dart';
import '../../utils/DarkThemeProvider.dart';

class TermsAndConditionScreen extends StatelessWidget {
  final String? type;

  const TermsAndConditionScreen({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      // backgroundColor: AppColors.primary,
      backgroundColor: AppColors.darkModePrimary,

      appBar: AppBar(
        // elevation: 0,
        // backgroundColor: themeChange.getThem()
        //     ? AppColors.darkBackground
        //     : AppColors.background,
        title: Text(
          type == "privacy" ? "Privacy Policy".tr : "Terms and Conditions".tr,
          // style: TextStyle(
          //     // color: AppColors.background,
          //
          //     color: themeChange.getThem()
          //         ? AppColors.background
          //         : AppColors.darkBackground),
        ),
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              /*color: themeChange.getThem()
                    ? AppColors.background
                    : AppColors.darkBackground*/
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(
            //   height: Responsive.width(8, context),
            //   width: Responsive.width(100, context),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Html(
                  shrinkWrap: true,
                  data: type == "privacy"
                      ? Constant.privacyPolicy
                      : Constant.termsAndConditions,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
