import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacks/theme/app_colors.dart';
import 'package:stacks/view/widgets/menu/top_menu.dart';

class NotificationActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: CustomScrollView(
          slivers: [
            TopMenu(),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              sliver: SliverToBoxAdapter(
                /*child: Container(
                  child: Text("Notification Screen"),
                ),*/
              ),
            ),
          ],
        ),
      ),
    );
  }
}
