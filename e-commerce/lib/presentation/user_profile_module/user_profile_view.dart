import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_globals.dart' as global;
import '../app_settings_module/app_settings_view.dart';
import '../internet_connectivity_module/internet_connectivity_view.dart';
import '../login_module/login_view.dart';
import '../orders_module/order_view.dart';
import '../payment_method_module/payment_method_view.dart';
import '../shipping_module/shipping_view.dart';
import '../static_module/important_dialog_app.dart';
import '../static_module/web_view.dart';
import 'controller/user_profile_controller.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final userProfileController = Get.put(UserProfileController());
  // create an instance
  final GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[100],
        bottomSheet: GetBuilder<GetXNetworkManager>(builder: (builder)=> Container(
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          child: (_networkManager.connectionType == 0) ? const Text('No Internet connection', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,) : const SizedBox(),),),
          //body: _body()
          body: Obx(
            () => (userProfileController.loading.isFalse)
                ? _body()
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
      ),
    );
  }

  Widget _body() {
    return Container(
        color: Colors.grey[100],
        width: double.infinity,
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (global.isLoggedIn.isTrue)
                  ? Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Profile',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 35,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Edit by Me......
                              (global.isUserData['user_url'].isNotEmpty)
                                  ? CircleAvatar(
                                      radius: 32,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: NetworkImage(
                                          global.isUserData['user_url']),
                                    )
                                  : CircleAvatar(
                                      radius: 32,
                                      backgroundColor: Colors.grey[200],
                                      child: Text(
                                        (global.isUserData['display_name'] !=
                                                '')
                                            ? '${global.isUserData['display_name'][0].toUpperCase()}'
                                            : '',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      global.isUserData['display_name'],
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      global.isUserData['user_email'],
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'Sign in for the best experience',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed(LoginView.route)?.then((value) {
                                if (value == true) {
                                  userProfileController.loading.value = true;
                                  userProfileController.loading.value = false;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 40),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'SIGN IN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
              if (global.isLoggedIn.isTrue)
                Card(
                  color: Colors.grey[100],
                  margin: const EdgeInsets.only(bottom: 2.0),
                  elevation: 0.1,
                  child: ListTile(
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'My Orders',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    subtitle: const Text(
                      'Orders delivered, processing, pending, cancelled',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    onTap: () {
                      Get.toNamed(OrderView.route);
                    },
                  ),
                ),
              if (global.isLoggedIn.isTrue)
                Card(
                  color: Colors.grey[100],
                  margin: const EdgeInsets.only(bottom: 2.0),
                  elevation: 0.1,
                  child: ListTile(
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Shipping Address',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    subtitle: const Text(
                      'Your shipping address',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    onTap: () {
                      Get.toNamed(ShippingView.route);
                    },
                  ),
                ),
              Card(
                color: Colors.grey[100],
                margin: const EdgeInsets.only(bottom: 2.0),
                elevation: 0.1,
                child: ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Payment Method',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  subtitle: const Text(
                    'Available payment methods',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  onTap: () {
                    Get.toNamed(PaymentMethodView.route);
                  },
                ),
              ),
              Obx(() => (userProfileController.onePage.isNotEmpty)
                  ? pageApplication()
                  : const SizedBox(),),
              if (global.isLoggedIn.isTrue)
                Card(
                  color: Colors.grey[100],
                  margin: const EdgeInsets.only(bottom: 2.0),
                  elevation: 0.1,
                  child: ListTile(
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Settings',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    subtitle: const Text(
                      'User details, Password, Delete account',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    onTap: () {
                      Get.toNamed(AppSettingsView.route);
                    },
                  ),
                ),
              Card(
                color: Colors.grey[100],
                margin: const EdgeInsets.only(bottom: 2.0),
                elevation: 0.1,
                child: ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Contact Us',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  subtitle: const Text(
                    'Get in touch with us.',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  onTap: () {
                    importantDialogApp();
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget pageApplication() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        (userProfileController.onePage.containsKey('Terms of Use') == true)
            ? Card(
                color: Colors.grey[100],
                margin: const EdgeInsets.only(bottom: 2.0),
                elevation: 0.1,
                child: ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  title: Text(
                    userProfileController.onePage['Terms of Use']['title']
                        ['rendered'],
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  subtitle: const Text(
                    'The rules, specifications, and requirements for the use of a product or service.',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => WebView(
                          webPages:
                              userProfileController.onePage['Terms of Use'],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const SizedBox(),
        (userProfileController.onePage.containsKey('Privacy Policy') == true)
            ? Card(
                color: Colors.grey[100],
                margin: const EdgeInsets.only(bottom: 2.0),
                elevation: 0.1,
                child: ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  title: Text(
                    userProfileController.onePage['Privacy Policy']['title']
                        ['rendered'],
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  subtitle: const Text(
                    "The ways a party gathers, uses, discloses, and manages a customer or client's data.",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => WebView(
                          webPages:
                              userProfileController.onePage['Privacy Policy'],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
