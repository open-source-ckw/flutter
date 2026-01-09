import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/dash_board_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/Preferences.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DashBoardController>(
        init: DashBoardController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              // elevation: 0,
              // backgroundColor: AppColors.darkModePrimary,
              // backgroundColor: themeChange.getThem()
              //     ? AppColors.darkBackground
              //     : AppColors.background,
              title: controller.selectedDrawerIndex.value == 0
                  ? StreamBuilder(
                      stream: FireStoreUtils.fireStore
                          .collection(CollectionName.driverUsers)
                          .doc(FireStoreUtils.getCurrentUid())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            'Something went wrong'.tr,
                            style: GoogleFonts.poppins(
                              color: themeChange.getThem()
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Constant.loader(context);
                        }

                        DriverUserModel? driverModel =
                            DriverUserModel.fromJson(snapshot.data!.data()!);
                        return Container(
                          width: Responsive.width(50, context),
                          height: Responsive.height(5.5, context),
                          decoration: BoxDecoration(
                            color: themeChange.getThem()
                                ? AppColors.darkBackground
                                : AppColors.background,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                alignment: Alignment(
                                    driverModel.isOnline == true ? -1 : 1, 0),
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  width: Responsive.width(26, context),
                                  height: Responsive.height(8, context),
                                  decoration: const BoxDecoration(
                                    color: AppColors.darkModePrimary,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  ShowToastDialog.showLoader("Please wait");
                                  if (driverModel.documentVerification ==
                                      false) {
                                    ShowToastDialog.closeLoader();
                                    _showAlertDialog(context, "document");
                                  } else if (driverModel.vehicleInformation ==
                                          null ||
                                      driverModel.serviceId == null) {
                                    ShowToastDialog.closeLoader();
                                    _showAlertDialog(
                                        context, "vehicleInformation");
                                  } else {
                                    driverModel.isOnline = true;
                                    await FireStoreUtils.updateDriverUser(
                                        driverModel);

                                    ShowToastDialog.closeLoader();
                                  }
                                },
                                child: Align(
                                  alignment: const Alignment(-1, 0),
                                  child: Container(
                                    width: Responsive.width(26, context),
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Online'.tr,
                                      style: GoogleFonts.poppins(
                                          color: driverModel.isOnline == true
                                              ? themeChange.getThem()
                                                  ? Colors.white
                                                  : Colors.black
                                              : themeChange.getThem()
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  driverModel.isOnline = false;
                                  await FireStoreUtils.updateDriverUser(
                                      driverModel);

                                  ShowToastDialog.closeLoader();
                                },
                                child: Align(
                                  alignment: const Alignment(1, 0),
                                  child: Container(
                                    width: Responsive.width(26, context),
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Offline'.tr,
                                      style: GoogleFonts.poppins(
                                          color: driverModel.isOnline == false
                                              ? themeChange.getThem()
                                                  ? Colors.white
                                                  : Colors.black
                                              : themeChange.getThem()
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                  : Text(
                      controller
                          .drawerItems[controller.selectedDrawerIndex.value]
                          .title,
                      style: GoogleFonts.poppins(
                        color:
                            themeChange.getThem() ? Colors.white : Colors.black,
                      ),
                      // style: GoogleFonts.adamina(),
                    ),
              centerTitle: true,
              leading: Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 11, bottom: 11),
                    child: Image.asset("assets/wf-driver-logo.png"),

                    /*SvgPicture.asset('assets/icons/ic_humber.svg',
                        // color: AppColors.background,

                        color: themeChange.getThem()
                            ? AppColors.background
                            : AppColors.darkBackground),*/
                  ),
                );
              }),
              /*leading: Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 20, top: 20, bottom: 20),
                    child: SvgPicture.asset('assets/icons/ic_humber.svg',
                        color: themeChange.getThem()
                            ? AppColors.background
                            : AppColors.darkBackground),
                  ),
                );
              }),*/
            ),
            drawer: buildAppDrawer(context, controller),
            body: WillPopScope(
                onWillPop: controller.onWillPop,
                child: (Preferences.getBoolean(
                            Preferences.backgroundLocationAccess) ==
                        true)
                    ? controller.getDrawerItemWidget(
                        controller.selectedDrawerIndex.value)
                    : SizedBox()),
          );
        });
  }

  Future<void> _showAlertDialog(BuildContext context, String type) async {
    final controllerDashBoard = Get.put(DashBoardController());

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final themeChange = Provider.of<DarkThemeProvider>(context);

        return AlertDialog(
          // <-- SEE HERE
          title: Text(
            'Information'.tr,
            style: GoogleFonts.poppins(
              color: themeChange.getThem() ? Colors.white : Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'To start earning with WayFinder - Driver you need to fill in your personal information'
                      .tr,
                  style: GoogleFonts.poppins(
                    color: themeChange.getThem() ? Colors.white : Colors.black,
                  ),
                ), /* Text(
                  'To start earning with GoRide you need to fill in your personal information'
                      .tr,
                  style: GoogleFonts.poppins(
                    color: themeChange.getThem() ? Colors.white : Colors.black,
                  ),
                ),*/
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No'.tr,
                style: GoogleFonts.poppins(
                  color: themeChange.getThem() ? Colors.white : Colors.black,
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                'Yes'.tr,
                style: GoogleFonts.poppins(
                  color: themeChange.getThem() ? Colors.white : Colors.black,
                ),
              ),
              onPressed: () {
                if (type == "document") {
                  controllerDashBoard.onSelectItem(7);
                } else {
                  controllerDashBoard.onSelectItem(8);
                }
              },
            ),
          ],
        );
      },
    );
  }

  buildAppDrawer(BuildContext context, DashBoardController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    var drawerOptions = <Widget>[];
    for (var i = 0; i < controller.drawerItems.length; i++) {
      var d = controller.drawerItems[i];
      drawerOptions.add(InkWell(
        onTap: () {
          controller.onSelectItem(i);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: i == controller.selectedDrawerIndex.value
                    ? AppColors.darkModePrimary
                    : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Image.asset(
                  d.icon,
                  width: 20,
                  // color: i == controller.selectedDrawerIndex.value
                  //     ? themeChange.getThem()
                  //         ? Colors.black
                  //         : Colors.white
                  //     : themeChange.getThem()
                  //         ? Colors.white
                  //         : AppColors.drawerIcon,
                ),
                /*SvgPicture.asset(
                  d.icon,
                  width: 20,
                  color: i == controller.selectedDrawerIndex.value
                      ? themeChange.getThem()
                          ? Colors.black
                          : Colors.white
                      : themeChange.getThem()
                          ? Colors.white
                          : AppColors.drawerIcon,
                ),*/
                const SizedBox(
                  width: 20,
                ),
                Text(
                  d.title,
                  style: GoogleFonts.poppins(
                      color: i == controller.selectedDrawerIndex.value
                          ? themeChange.getThem()
                              ? Colors.black
                              : Colors.white
                          : themeChange.getThem()
                              ? Colors.white
                              : Colors.black,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ));
    }
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: FutureBuilder<DriverUserModel?>(
                future: FireStoreUtils.getDriverProfile(
                    FireStoreUtils.getCurrentUid()),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Constant.loader(context);
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text(
                          snapshot.error.toString(),
                          style: GoogleFonts.poppins(
                            color: themeChange.getThem()
                                ? Colors.white
                                : Colors.black,
                          ),
                        );
                      } else {
                        DriverUserModel driverModel = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: CachedNetworkImage(
                                  height: Responsive.width(15, context),
                                  width: Responsive.width(15, context),
                                  imageUrl: driverModel.profilePic.toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Constant.loader(context),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                        // maxRadius: 60,
                                        // minRadius: 60,
                                        backgroundColor:
                                            AppColors.darkModePrimary,
                                        child: Text(
                                            driverModel.fullName
                                                .toString()
                                                .characters
                                                .first,
                                            style: GoogleFonts.poppins(
                                                // fontSize: 45.0,
                                                fontWeight: FontWeight.w500,
                                                color: themeChange.getThem()
                                                    ? Colors.black
                                                    : Colors.white)),
                                      )),

                              /*CachedNetworkImage(
                                height: Responsive.width(15, context),
                                width: Responsive.width(15, context),
                                imageUrl: driverModel.profilePic.toString(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Constant.loader(context),
                                errorWidget: (context, url, error) =>
                                    Image.network(Constant.userPlaceHolder),
                              ),*/
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(driverModel.fullName.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                      color: themeChange.getThem()
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                driverModel.email.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  color: themeChange.getThem()
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    default:
                      return Text(
                        'Error'.tr,
                        style: GoogleFonts.poppins(
                          color: themeChange.getThem()
                              ? Colors.white
                              : Colors.black,
                        ),
                      );
                  }
                }),
          ),
          Column(children: drawerOptions),
        ],
      ),
    );
  }
}
