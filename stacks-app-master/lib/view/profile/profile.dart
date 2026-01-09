import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stacks/controller/auth_controller.dart';
import 'package:stacks/controller/profile_controller.dart';
import 'package:stacks/routes/app_pages.dart';
import 'package:stacks/theme/app_colors.dart';
import 'package:stacks/view/widgets/menu/top_menu.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController())!;
    print('==== Profile =====');
    print(controller.email);
    print(controller.name);
    final box = GetStorage();
    print(box.getKeys());
    print(box.getValues());
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/profile_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        CustomScrollView(
          slivers: [
            TopMenu(),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              sliver: SliverToBoxAdapter(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      child: controller.photoURL != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.network(controller.photoURL),
                            )
                          : FlutterLogo(size: 70),
                      radius: 42,
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          controller.name,
                          style: TextStyle(
                            color: Color(0xff002347),
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          controller.email,
                          style: TextStyle(
                            color: Color(0xffb0becc),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.30,
                      child: Container(
                        width: 343,
                        height: 1,
                        color: Color(0xffb0becc),
                      ),
                    ),

                    //Connect more social accounts
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.toNamed(Routes.SOCIAL_ACCOUNTS),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Icon(CupertinoIcons.link, size: 20, color: primaryColor),
                                SizedBox(width: 25),
                                Text(
                                  "Connect more social accounts",
                                  style: TextStyle(
                                    color: Color(0xff002347),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Opacity(
                              opacity: 0.30,
                              child: Container(
                                width: 343,
                                height: 1,
                                color: Color(0xffb0becc),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Settings
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(CupertinoIcons.settings, size: 20, color: primaryColor),
                              SizedBox(width: 25),
                              Text(
                                "Settings",
                                style: TextStyle(
                                  color: Color(0xff002347),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Opacity(
                            opacity: 0.30,
                            child: Container(
                              width: 343,
                              height: 1,
                              color: Color(0xffb0becc),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //About Us
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.toNamed(Routes.ABOUT_US),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Icon(CupertinoIcons.question_circle, size: 20, color: primaryColor),
                                SizedBox(width: 25),
                                Text(
                                  "About Us",
                                  style: TextStyle(
                                    color: Color(0xff002347),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Opacity(
                              opacity: 0.30,
                              child: Container(
                                width: 343,
                                height: 1,
                                color: Color(0xffb0becc),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Terms & Conditions
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.toNamed(Routes.TERMS_CONDITIONS),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Icon(CupertinoIcons.square_list_fill, size: 20, color: primaryColor),
                                SizedBox(width: 25),
                                Text(
                                  "Terms & Conditions",
                                  style: TextStyle(
                                    color: Color(0xff002347),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Opacity(
                              opacity: 0.30,
                              child: Container(
                                width: 343,
                                height: 1,
                                color: Color(0xffb0becc),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Privacy Policy
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.toNamed(Routes.PRIVACY_POLICY),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Icon(CupertinoIcons.lock_shield, size: 20, color: primaryColor),
                                SizedBox(width: 25),
                                Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    color: Color(0xff002347),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Opacity(
                              opacity: 0.30,
                              child: Container(
                                width: 343,
                                height: 1,
                                color: Color(0xffb0becc),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 25,
          left: 15,
          child: GestureDetector(
            onTap: () {
              AuthController().logout();
            },
            child: Row(
              children: [
                Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset('images/logout.png'),
                ),
                SizedBox(width: 10),
                Text(
                  "LOGOUT",
                  style: TextStyle(
                    color: Color(0xff002347),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
