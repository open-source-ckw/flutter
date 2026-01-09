import 'package:book_reader_app/core/colors.dart';
import 'package:book_reader_app/core/responsive.dart';
import 'package:book_reader_app/models/new_model.dart';
import 'package:book_reader_app/presentation/bottom_bar.dart';
import 'package:book_reader_app/presentation/setting_screen.dart';
import 'package:book_reader_app/presentation/topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

class AppDrawer extends StatefulWidget {
  final Isar isar;
  const AppDrawer({super.key, required this.isar});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 260,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 8.0, top: 50, right: 8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [secondaryColor, lighterSecondary],
                transform: const GradientRotation(180)
              ),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Modern logo area
            Center(
              child: Column(
                children: [
                  Align(
                      alignment: AlignmentGeometry.center,
                      child: Container(
                          padding: const EdgeInsets.all(10.0),
                          height: 100,
                          width: 120,
                          decoration: BoxDecoration(
                              color: appWhite.withOpacity(0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: secondaryColor.withOpacity(0.6),
                                  spreadRadius: 3,
                                  blurRadius: 8,
                                  offset: const Offset(3, 3)
                                ),
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.6),
                                  spreadRadius: 3,
                                  blurRadius: 8,
                                  offset: const Offset(-1, -1)
                                )
                              ],
                              borderRadius: const BorderRadiusGeometry.only(
                                  topLeft: Radius.elliptical(100, 40),
                                  bottomRight: Radius.elliptical(100, 40),
                                  topRight: Radius.elliptical(60, 100),
                                  bottomLeft: Radius.elliptical(60, 100))),
                          child: Image.asset(
                            "assets/app-images/book_app_image.png",
                            fit: BoxFit.cover,
                          ))),
                  const HeightGap(gap: 0.010),
                ],
              ),
            ),

            const HeightGap(gap: 0.025),
            Divider(color: appGray300),

            // ✅ Home item
            ListTile(
              leading: Icon(Icons.home_outlined, color: primaryColor),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                  TurnPageRoute(
                    overleafColor: appWhite,
                    transitionDuration: const Duration(milliseconds: 700),
                    builder: (context) => BottomBar(isar: widget.isar),),
                      (route) => false,
                );
              },
            ),

            // ✅ Dynamic sections
            Expanded(
              child: FutureBuilder<List<Section>>(
                future: widget.isar.sections.where().findAll(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final sections = snapshot.data!;
                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: sections.length,
                      itemBuilder: (context, index) {
                        final section = sections[index];
                        return ListTile(
                          dense: true,
                          horizontalTitleGap: 10,
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: Text(
                              section.sId.toString(),
                              style: TextStyle(
                                fontSize: 13,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            section.sSubTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(
                              TurnPageRoute(
                                overleafColor: appWhite,
                                transitionDuration: const Duration(milliseconds: 700),
                                builder: (_) => TopicsScreen(
                                  isar: widget.isar,
                                  sectionSubTitle: section.sSubTitle,
                                  sectionId: section.sId,
                                  fromDrawer: true,
                                ),
                              ),
                                  (route) => false,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined, color: primaryColor),
              title: const Text(
                "Settings",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingScreen(isar: widget.isar),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );

  }
}
