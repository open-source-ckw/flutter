import 'package:fashionia/presentation/home_module/home_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../product_bag_module/product_bag_view.dart';
import '../product_favorite_module/product_favorite_view.dart';
import '../product_shop_module/product_shop_view.dart';
import '../user_profile_module/user_profile_view.dart';
import 'controller/layout_controller.dart';
import 'package:badges/badges.dart' as badges;
import '../../../core/app_globals.dart' as global;

class LayoutView extends StatefulWidget {
  const LayoutView({Key? key}) : super(key: key);
  static const route = '/layout_view';

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  final layoutController = Get.put(LayoutController());

  final pages = [
    const HomeView(),
    const ProductShopView(),
    const ProductBagView(),
    const ProductFavoriteView(),
    const UserProfileView(),
  ];

  @override
  void initState() {
    layoutController.pageIndex.value = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: pages[layoutController.pageIndex.value],
      bottomNavigationBar: buildMyNavBar(context),
    ),);
  }

  buildMyNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(24),
        topLeft: Radius.circular(24),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: layoutController.pageIndex.value,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey.withOpacity(.60),
        selectedFontSize: 12,
        unselectedFontSize: 10,
        selectedIconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
            size: 25
        ),
        /*selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,*/
        onTap: (value) {
          // Respond to item press.
          layoutController.pageIndex.value = value;
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: layoutController.pageIndex.value == 0
                ? const Icon(
              Icons.home,
            )
                : const Icon(
              Icons.home_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Shop',
            icon: layoutController.pageIndex.value == 1
                ? const Icon(
              Icons.shopping_cart,
            )
                : const Icon(
              Icons.shopping_cart_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Bag',
            icon: layoutController.pageIndex.value == 2
                ? const Icon(
              Icons.shopping_bag,
            ) : const Icon(
              Icons.shopping_bag_outlined,
            ),
          ),
          BottomNavigationBarItem(
              label: 'Favorites',
              icon: layoutController.pageIndex.value == 3
                  ? const FaIcon(
                FontAwesomeIcons.solidHeart,
              )
                  : const FaIcon(
                FontAwesomeIcons.heart,
              )
          ),
          BottomNavigationBarItem(
              label: 'Profile',
              icon: layoutController.pageIndex.value == 4
                  ? const FaIcon(
                FontAwesomeIcons.userLarge,
              )
                  : const FaIcon(
                FontAwesomeIcons.user,
              )
          ),
        ],
      ),
    );
  }
}