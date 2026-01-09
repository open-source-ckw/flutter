import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacks/view/widgets/menu/menu_activity.dart';
import 'package:stacks/view/widgets/menu/menu_map.dart';
import 'package:stacks/view/widgets/menu/menu_my_list.dart';
import 'package:stacks/view/widgets/menu/menu_profile.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      pinned: true,
      floating: false,
      collapsedHeight: 80.0,
      expandedHeight: 80.0,
      flexibleSpace: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x59a1b3cc),
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Stacks',
                  style: TextStyle(
                    color: Color(0xff002347),
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopMenuOld extends StatelessWidget {
  const TopMenuOld({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      pinned: true,
      floating: false,
      collapsedHeight: 80.0,
      expandedHeight: 100.0,
      flexibleSpace: Container(
        width: double.infinity,
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x59a1b3cc),
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [MenuMyList(), MenuMap(), MenuActivity(), MenuProfile()],
          ),
        ),
      ),
    );
  }
}

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x59a1b3cc),
            blurRadius: 15,
            offset: Offset(0, 0),
          ),
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [MenuMyList(), MenuMap(), MenuActivity(), MenuProfile()],
        ),
      ),
    );
  }
}
