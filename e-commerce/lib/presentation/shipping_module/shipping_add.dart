import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_globals.dart' as global;
import 'controller/shipping_controller.dart';

class ShippingAdd extends StatefulWidget {
  const ShippingAdd({Key? key}) : super(key: key);
  static const route = '/shipping_add';

  @override
  State<ShippingAdd> createState() => _ShippingAddState();
}

class _ShippingAddState extends State<ShippingAdd> {
  final shippingController = Get.put(ShippingController());

  String? fName, lName, cName, add1, add2, city, pCode, country, state, phone;

  TextEditingController fNameCnt = TextEditingController();
  TextEditingController lNameCnt = TextEditingController();
  TextEditingController cNameCnt = TextEditingController();
  TextEditingController add1Cnt = TextEditingController();
  TextEditingController add2Cnt = TextEditingController();
  TextEditingController cityCnt = TextEditingController();
  TextEditingController pCodeCnt = TextEditingController();
  TextEditingController countryCnt = TextEditingController();
  TextEditingController stateCnt = TextEditingController();
  TextEditingController phoneCnt = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var passData = Get.arguments;

  @override
  void initState() {
    if(passData != null){
      fNameCnt.text = passData?['shipping']['first_name'];
      lNameCnt.text = passData?['shipping']['last_name'];
      cNameCnt.text = passData?['shipping']['company'];
      add1Cnt.text = passData?['shipping']['address_1'];
      add2Cnt.text = passData?['shipping']['address_2'];
      cityCnt.text = passData?['shipping']['city'];
      pCodeCnt.text = passData?['shipping']['postcode'];
      countryCnt.text = passData?['shipping']['country'];
      stateCnt.text = passData?['shipping']['state'];
      phoneCnt.text = passData?['shipping']['phone'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text((passData != null) ? 'Edit Shipping Address' :
        'Add Shipping Address',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(() => shippingController.loading.isTrue ? bodyProgress() : bodyWidget(),)
    );
  }

  bodyWidget(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// First name....
                TextFormField(
                  controller: fNameCnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'First Name *',
                    labelText: 'First Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (String? val) {
                    fName = val!;
                  },
                ),
                const SizedBox(height: 20,),
                /// Last name....
                TextFormField(
                  controller: lNameCnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Last Name *',
                    labelText: 'Last Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (String? val) {
                    lName = val!;
                  },
                ),
                const SizedBox(height: 20,),
                /// Company name....
                TextFormField(
                  controller: cNameCnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Company',
                    labelText: 'Company',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (String? val) {
                    cName = val!;
                  },
                ),
                const SizedBox(height: 20,),
                /// Address 1....
                TextFormField(
                  controller: add1Cnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Address 1',
                    labelText: 'Address 1',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  onSaved: (String? val) {
                    add1 = val!;
                  },
                ),
                const SizedBox(height: 20,),
                /// Address 2....
                TextFormField(
                  controller: add2Cnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Address 2',
                    labelText: 'Address 2',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    return null;

                  },
                  onSaved: (String? val) {
                    add2 = val!;
                  },
                ),
                const SizedBox(height: 20,),
                /// City ....
                TextFormField(
                  controller: cityCnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'City',
                    labelText: 'City',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                  onSaved: (String? val) {
                    city = val!;
                  },
                ),
                const SizedBox(height: 20,),
                /// State ....
                TextFormField(
                  controller: stateCnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'State',
                    labelText: 'State',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                  onSaved: (String? val) {
                    state = val!;
                  },
                ),
                const SizedBox(height: 20,),
                /// Zip Code(Postal Code) ....
                TextFormField(
                  controller: pCodeCnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Zip Code(Postal Code)',
                    labelText: 'Zip Code(Postal Code)',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your zip Code(Postal Code)';
                    }
                    return null;
                  },
                  onSaved: (String? val) {
                    pCode = val!;
                  },
                ),
                const SizedBox(height: 20,),
                /// Country ....
                TextFormField(
                  controller: countryCnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Country',
                    labelText: 'Country',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your country';
                    }
                    return null;
                  },
                  onSaved: (String? val) {
                    country = val!;
                  },
                ),
                const SizedBox(height: 20,),
                /// Phone ....
                TextFormField(
                  controller: phoneCnt,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Phone',
                    labelText: 'Phone',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.0,
                        ), borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    // Indian Mobile number are of 10 digit only
                    String patten = r'(^[0-9]*$)';
                    RegExp regExp = RegExp(patten);
                    if (value!.isEmpty){
                      return "Please enter your phone";
                    } else if (value.length != 10){
                      return 'Phone number must be of 10 digit';
                    } else if (!regExp.hasMatch(value)){
                      return "Phone number must be digits";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  onSaved: (String? val) {
                    phone = val!;
                  },
                ),
                const SizedBox(height: 40,),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(onPressed: () async {
                    if (_formKey.currentState!
                        .validate()) {
                      shippingController.loading.value = true;
                      Map<String, dynamic> shippingAdd = {
                        "id": global.isUserData['ID'],
                        "billing" : {
                          "first_name": fNameCnt.text,
                          "last_name": lNameCnt.text,
                          "company": cNameCnt.text,
                          "address_1": add1Cnt.text,
                          "address_2": add2Cnt.text,
                          "city": cityCnt.text,
                          "postcode": pCodeCnt.text,
                          "country": countryCnt.text,
                          "state": stateCnt.text,
                          "phone": phoneCnt.text,
                          "email": global.isUserData['user_email']
                        },
                        "shipping" : {
                          "first_name": fNameCnt.text,
                          "last_name": lNameCnt.text,
                          "company": cNameCnt.text,
                          "address_1": add1Cnt.text,
                          "address_2": add2Cnt.text,
                          "city": cityCnt.text,
                          "postcode": pCodeCnt.text,
                          "country": countryCnt.text,
                          "state": stateCnt.text,
                          "phone": phoneCnt.text
                        }
                      };
                      shippingController.editShippingData(passMapData: shippingAdd);
                    }
                  }, style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: Size(MediaQuery.of(context).size.width, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                      child: const Text('SAVE ADDRESS',style: TextStyle(color: Colors.white,fontSize: 20))),
                ),
              ],
            )),),
    );
  }

  Widget bodyProgress() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        bodyWidget(),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}