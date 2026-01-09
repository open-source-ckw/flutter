import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/model/payment_model.dart';
import 'package:customer/payment/createRazorPayOrderModel.dart';
import 'package:http/http.dart' as http;

class RazorPayController {
  Future<CreateRazorPayOrderModel?> createOrderRazorPay(
      {required int amount, required RazorpayModel? razorpayModel}) async {
    final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    RazorpayModel razorPayData = razorpayModel!;
    print(razorPayData.razorpayKey);
    print("we Enter In");
    const url = "${Constant.globalUrl}payments/razorpay/createorder";
    print(orderId);

    final response = await http.post(
      Uri.parse(url),
      body: {
        "amount": (amount * 100).toString(),
        "receipt_id": orderId,
        "currency": "INR",
        "razorpaykey": razorPayData.razorpayKey,
        "razorPaySecret": razorPayData.razorpaySecret,
        "isSandBoxEnabled": razorPayData.isSandbox.toString(),
      },
    );

    if (response.statusCode == 500) {
      return null;
    } else {
      print("=============================");
      print(response.body);
      final data = jsonDecode(response.body);
      print(data);

      return CreateRazorPayOrderModel.fromJson(data);
    }
  }

/*  Future<CreateRazorPayOrderModel?> createOrderRazorPay(
      {required int amount, required RazorpayModel? razorpayModel}) async {
    final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    RazorpayModel razorPayData = razorpayModel!;

    var auth =
        'Basic ${base64Encode(utf8.encode('${razorPayData.razorpayKey}:${razorPayData.razorpaySecret}'))}';
    var headers = {'content-type': 'application/json', 'Authorization': auth};

    const url = "https://api.razorpay.com/v1/orders";
    // const url = "https://api.razorpay.com/payments/razorpay/createorder";
    print(orderId);

    final response = await http.post(Uri.parse(url), headers: headers, body: {
      "amount": (amount * 100).toString(),
      "receipt_id": orderId,
      "currency": "INR",
      "razorpaykey": razorPayData.razorpayKey,
      "razorPaySecret": razorPayData.razorpaySecret,
      "isSandBoxEnabled": razorPayData.isSandbox.toString(),
      "content-type": "application/json"
    });

    */ /* var request =
        http.Request('POST', Uri.parse('https://api.razorpay.com/v1/orders'));

    request.body = json.encode({
      "amount": (amount * 100).toString(),
      "receipt_id": orderId,
      "currency": "INR",
      "razorpaykey": razorPayData.razorpayKey,
      "razorPaySecret": razorPayData.razorpaySecret,
      "isSandBoxEnabled": razorPayData.isSandbox.toString(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);*/ /*
    if (response.statusCode == 500) {
      return null;
    } else {
      print("=============================");
      print(response.body);
      final data = jsonDecode(response.body);
      print(data);

      return CreateRazorPayOrderModel.fromJson(data);
    }
  }*/
}
