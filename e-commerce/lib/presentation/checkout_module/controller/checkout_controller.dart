import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:upi_india/upi_india.dart';
import '../../../core/app_api_handler.dart';
import '../../../core/app_auth.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_globals.dart' as global;
import '../../static_module/order_success_view.dart';

class CheckoutController extends GetxController{

  RxBool loading = false.obs;
  RxBool loadingSubmit = false.obs;
  int deliveryCharge = 10;
  List<dynamic> listOfPaymentGateway = [];
  List<dynamic> listOfProduct = [];
  RxString selPayGatewayId = ''.obs;
  //String? selPayGatewayTitle;
  RxMap selPayGateway = {}.obs;
  RxMap shippingData = {}.obs;
  Map<String, dynamic> passOrderData = {};
  Map<String, dynamic> createOrderData = {};
  bool outOfStock = false;

  /// Payment
  final Razorpay razorpay = Razorpay();

  /// Upi
  final UpiIndia upiIndia = UpiIndia();
  List<UpiApp>? apps;
  Future<UpiResponse>? transaction;
  UpiApp? selUpiOption;
  RxString selectedUpiOption = ''.obs;

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  Future<UpiResponse> initiateTransaction(UpiApp app, passSelPayGateway) async {
    if(passSelPayGateway != null){
      return upiIndia.startTransaction(
        app: app,
        receiverUpiId: passSelPayGateway['settings']['vpa']['value'],
        receiverName: passSelPayGateway['settings']['name']['value'],
        transactionRefId: 'TestingUpiIndiaPlugin',
        transactionNote: 'Not actual. Just an example.',
        amount: global.grandTotal,
      );
    }
    return upiIndia.startTransaction(
      app: app,
      receiverUpiId: "1234567890@ybl",
      receiverName: 'Testing',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: global.grandTotal,
    );
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    razorpay.clear();
    createOrderData = {};
    loading = false.obs;
    loadingSubmit = false.obs;
    listOfProduct = [];
    selUpiOption = null;
    super.onClose();
  }

  getShippingData() async {
    await UserAuthService().getCustomer(userID: global.isUserData['ID'].toString()).then((customerData) {
      shippingData.value = customerData;
    });
  }

  sumOfSummary() {
    global.grandTotal = 0;
    global.grandTotal += (global.subTotal + deliveryCharge);
  }

  paymentMethodAPI() async {
    await ApiHandlerService().getPaymentList().then((paymentListData) {
      listOfPaymentGateway = paymentListData;
      loading.value = false;
    });
  }

  // Quantity are available or not
  Future<bool> getProductAddToCartItem() async {
    loadingSubmit.value = true;
    listOfProduct = [];
    await ApiHandlerService().getProductAddToCartItems(global.addToCart[global.isUserID]).then((value) {
      global.addToCart[global.isUserID] = value;
      /// Global key added add to cart product store in the variable
      value['simple'].forEach((key, value) {
        if(value['stock_qty'] <= 0) {
          outOfStock = true;
        } else {
          listOfProduct.add({'product_id': key, 'quantity': value['qty']});
        }
      });
      value['variable'].forEach((key, value) {
        if(value['stock_qty'] <= 0){
          outOfStock = true;
        } else {
          listOfProduct.add({
            'product_id': value['p_id'],
            "variation_id": key,
            'quantity': value['qty']
          });
        }
      });
    });
    return outOfStock;
  }

  submitOrder(){
    if(shippingData.containsKey('shipping') == true && shippingData['shipping']['first_name'] != '') {
      Map<String, dynamic> billings = {
        "first_name": shippingData['billing']['first_name'],
        "last_name": shippingData['billing']['last_name'],
        "address_1": shippingData['billing']['address_1'],
        "address_2": shippingData['billing']['address_2'],
        "city": shippingData['billing']['city'],
        "state": shippingData['billing']['state'],
        "postcode": shippingData['billing']['postcode'],
        "country": shippingData['billing']['country'],
        "email": shippingData['billing']['email'],
        "phone": shippingData['billing']['phone']
      };

      Map<String, dynamic> shippingAddress = {
        "first_name": shippingData['shipping']['first_name'],
        "last_name": shippingData['shipping']['last_name'],
        "address_1": shippingData['shipping']['address_1'],
        "address_2": shippingData['shipping']['address_2'],
        "city": shippingData['shipping']['city'],
        "state": shippingData['shipping']['state'],
        "postcode": shippingData['shipping']['postcode'],
        "country": shippingData['shipping']['country'],
        "phone": shippingData['shipping']['phone']
      };

      passOrderData = {
        "customer_id": global.isUserData['ID'],
        "payment_method": selPayGatewayId.value.toString(),
        "payment_method_title": selPayGateway['title'].toString(),
        "set_paid": false,
        "billing": billings,
        "shipping": shippingAddress,
        "line_items": listOfProduct,
        "shipping_lines": [
          {
            "method_id": "flat_rate",
            "method_title": "Flat Rate",
            "total": "10.00",
          }
        ]
      };
      /*loading.value = true;
      loadingSubmit.value = true;*/
      orderCreateAPI(passOrderData);
    } else {
      const text = 'Please add your shipping address';
      showCheckoutSnackBar(value: text, status: 'error', );
    }
  }

  /// Order create API.
  orderCreateAPI(Map<String, dynamic> orderPassData) async {
    await ApiHandlerService().createOrder(orderPassData).then((responseData) {
      if (responseData.containsKey('data') == true && (responseData['data']['status'] == 400 || responseData['data']['status'] == 404)) {
        loading.value = false;
        loadingSubmit.value = false;
        const text = 'Something went wrong.';
        showCheckoutSnackBar(value: text, status: 'error', );
      } else {
        if(responseData.containsKey('status') == true){
          createOrderData = responseData;
          if(selPayGatewayId.value == 'cod'){
            Timer(const Duration(milliseconds: 1000), () {
              loading.value = false;
              loadingSubmit.value = false;
              Get.offAllNamed(OrderSuccess.route);
            });
          }
          if(selPayGatewayId.value == 'razorpay'){
            razorPayCreateOrderAPI();
          }
          if(selPayGatewayId.value == 'wc-upi'){
            print('object');
            print(selPayGatewayId.value);
            transaction = initiateTransaction(selUpiOption!, selPayGateway);
            transaction?.then((value) {

              print('------------ value ----------');
              print(value);
              print(value.transactionId);
              print(value.approvalRefNo);
              print(value.responseCode);
              print(value.status);

              // If we have data then definitely we will have UpiResponse.
              // It cannot be null
              UpiResponse _upiResponse = value;

              // Data in UpiResponse can be null. Check before printing
              String txnId = _upiResponse.transactionId ?? 'N/A';
              String resCode = _upiResponse.responseCode ?? 'N/A';
              String txnRef = _upiResponse.transactionRefId ?? 'N/A';
              String status = _upiResponse.status ?? 'N/A';
              String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
              print('----status----');
              print(status);
              _checkTxnStatus(status);
              //_upiErrorHandler();
              if(status == 'success'){
                updateOrder(wcOrderId: createOrderData['id'].toString(), mapUpdateOrder: {
                  "status": "completed",
                  "transaction_id": txnId,
                });
              } else {
                loading.value = false;
                loadingSubmit.value = false;
              }
            });
          }
        }
      }
    });
  }

  /// Order update API.
  updateOrder({required String wcOrderId,
    required Map<String, dynamic> mapUpdateOrder}) async {

    loading.value = true;
    loadingSubmit.value = true;

    await ApiHandlerService().updateOrder(wcOrderId, mapUpdateOrder).then((updateOrderData) {
      if(updateOrderData['status'] == 'failed'){
        loading.value = false;
        loadingSubmit.value = false;
        const text = 'Payment failed!!';
        showCheckoutSnackBar(value: text, status: 'error', );
      } else {
        if(updateOrderData['status'] == "completed"){
          Timer(const Duration(milliseconds: 1000), () {
            loading.value = false;
            loadingSubmit.value = false;
            Get.offAllNamed(OrderSuccess.route);
            /*Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                  const OrderSuccess()),
              ModalRoute.withName('/'),
            );*/
          });
        } else if(updateOrderData['status'] == 'pending'){
          /// If user is closed the popup of payment gateway then update the record.
          if(selPayGatewayId.value == 'cod'){
            Timer(const Duration(milliseconds: 1000), () {
              loading.value = false;
              loadingSubmit.value = false;
              Get.offAllNamed(OrderSuccess.route);
              /*Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                    const OrderSuccess()),
                ModalRoute.withName('/'),
              );*/
            });
          }
          if(selPayGatewayId.value == 'razorpay'){
            razorPayCreateOrderAPI();
          }
          if(selPayGatewayId.value == 'wc-upi'){
            transaction = initiateTransaction(selUpiOption!, selPayGateway);
            transaction?.then((value) {
              // If we have data then definitely we will have UpiResponse.
              // It cannot be null
              UpiResponse _upiResponse = value;

              // Data in UpiResponse can be null. Check before printing
              String txnId = _upiResponse.transactionId ?? 'N/A';
              String resCode = _upiResponse.responseCode ?? 'N/A';
              String txnRef = _upiResponse.transactionRefId ?? 'N/A';
              String status = _upiResponse.status ?? 'N/A';
              String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
              _checkTxnStatus(status);
              //_upiErrorHandler();
              if(status == 'success'){
                updateOrder(wcOrderId: createOrderData['id'].toString(), mapUpdateOrder: {
                  "status": "completed",
                  "transaction_id": txnId,
                });
              } else {
                loading.value = false;
                loadingSubmit.value = false;
              }
            });
          }
        }
      }
    });
  }

  razorPayCreateOrderAPI() async {
    Map<String, dynamic> passData = {
      "amount": global.grandTotal*100,
      "currency": "INR",
      "receipt": "rcptid_11",
      "notes": {'woocommerce_order_number':createOrderData['id'],'woocommerce_order_id':createOrderData['id']},
    };
    await ApiHandlerService().createOrderRazorPay(passData).then((value){
      var options = {
        'key': RAZORPAY_API_KEY,
        'amount': value['amount'],
        'currency': value['currency'],
        //'name': 'Acme Corp.',
        'description': 'Order ${createOrderData['id']}',
        'retry': {'enabled': false, 'max_count': 0},
        'order_id': value['id'],
        'notes': value['notes'],
        'prefill': {
          'name': '${shippingData['billing']['first_name']} ${shippingData['billing']['last_name']}',
          'email': shippingData['billing']['email'],
          'contact': '+91'+shippingData['billing']['phone']
        }
        /*'external': {
               'wallets': ['paytm']
         }*/
      };

      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
      razorpay.open(options);
    });
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response){

    /** PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    if (Platform.isAndroid) {
      // Android-specific code
      if(response.error!.containsKey('reason') == true && response.error!['reason'] == 'payment_failed'){
        loading.value = false;
        loadingSubmit.value = false;
        const text = 'Your payment failed. Please try again.';
        showCheckoutSnackBar(value: text, status: 'error', );
      } else {
        loading.value = false;
        loadingSubmit.value = false;
        const text = 'Your payment is declined. Please try again.';
        showCheckoutSnackBar(value: text, status: 'error', );
      }
    } else if (Platform.isIOS) {
      // iOS-specific code
      if(response.error!.containsKey('error') == true && response.error!['error']['reason'] == 'payment_failed'){
        loading.value = false;
        loadingSubmit.value = false;
        const text = 'Your payment failed. Please try again.';
        showCheckoutSnackBar(value: text, status: 'error', );
      } else {
        loading.value = false;
        loadingSubmit.value = false;
        const text = 'Your payment is declined. Please try again.';
        showCheckoutSnackBar(value: text, status: 'error', );
      }
    }
    razorpay.clear();
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){

    /** Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    if(response.paymentId != null){
      updateOrder(wcOrderId: createOrderData['id'].toString(), mapUpdateOrder: {
        "status": "completed",
        "transaction_id": response.paymentId,
      });
    }
    razorpay.clear();
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    //showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
    razorpay.clear();
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        showCheckoutSnackBar(value: 'Transaction Successful', status: 'Success', );
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        showCheckoutSnackBar(value: 'Transaction Submitted', status: 'Success', );
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        showCheckoutSnackBar(value: 'Transaction Failed', status: 'error', );
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  showCheckoutSnackBar({required String value, required String status}) {
    Get.showSnackbar(
      GetSnackBar(
        message: value,
        borderRadius: 20,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(15),
        backgroundColor: status == "Success" ? Colors.green : Colors.red,
      ),
    );
  }
}