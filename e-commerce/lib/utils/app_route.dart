import 'package:flutter/cupertino.dart';
import '../presentation/app_settings_module/app_settings_view.dart';
import '../presentation/checkout_module/checkout_view.dart';
import '../presentation/forgot_module/forgot_view.dart';
import '../presentation/introduction_module/introduction_view.dart';
import '../presentation/layout_module/layout_view.dart';
import '../presentation/login_module/login_view.dart';
import '../presentation/order_details_module/order_details_view.dart';
import '../presentation/orders_module/order_view.dart';
import '../presentation/payment_method_module/payment_method_view.dart';
import '../presentation/product_bag_module/product_bag_view.dart';
import '../presentation/product_details_module/product_details_view.dart';
import '../presentation/product_list_module/product_list_view.dart';
import '../presentation/search_module/search_view.dart';
import '../presentation/shipping_module/shipping_add.dart';
import '../presentation/shipping_module/shipping_view.dart';
import '../presentation/signup_module/signup_view.dart';
import '../presentation/splash_module/splash_view.dart';
import '../presentation/static_module/order_success_view.dart';
import '../presentation/upi_module/upi_view.dart';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (context) => const SplashView(),
  IntroductionView.route: (context) => const IntroductionView(),
  LoginView.route: (context) => const LoginView(),
  LayoutView.route: (context) => const LayoutView(),
  SignupView.route: (context) => const SignupView(),
  ForgotPasswordView.route: (context) => const ForgotPasswordView(),
  ProductListView.route: (context) => const ProductListView(),
  //ProductDetailsView.route: (context) => ProductDetailsView(),
  ProductBagView.route: (context) => const ProductBagView(),
  CheckoutView.route: (context) => const CheckoutView(),
  OrderSuccess.route: (context) => const OrderSuccess(),
  PaymentMethodView.route: (context) => const PaymentMethodView(),
  AppSettingsView.route: (context) => const AppSettingsView(),
  ShippingView.route: (context) => const ShippingView(),
  ShippingAdd.route: (context) => const ShippingAdd(),
  OrderView.route: (context) => const OrderView(),
  OrderDetailsView.route: (context) => const OrderDetailsView(),
  UpiView.route: (context) => const UpiView(),
};