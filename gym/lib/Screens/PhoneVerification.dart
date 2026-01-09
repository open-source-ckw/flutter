// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../Screens/ProfileSetup.dart';
// import '../Util/Constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// class PhoneVerification extends StatefulWidget {
//   const PhoneVerification({Key? key}) : super(key: key);
//
//   static const route = 'phoneVerification';
//   @override
//   State<PhoneVerification> createState() => _PhoneVerificationState();
// }
//
// class _PhoneVerificationState extends State<PhoneVerification> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.lightBlue.shade50,
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         padding: EdgeInsets.only(left: 25.0,right: 25.0),
//         alignment: Alignment.center,
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: SingleChildScrollView(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.only(top:20.0,bottom: 20.0),
//                     child: Text(
//                       'Phone verification',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 28.0
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.only(top:10.0),
//                     child: Text(
//                       'We sent a code to your number',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontSize: 18.0
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   '9(173)605-76-05',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 18.0
//                   ),
//                 ),
//                 TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       // Navigator.pushNamed(context, ProfileSetup.route);
//                     },
//                     child: const Text(
//                       'Change',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontSize: 18.0
//                       ),
//
//                     ),)
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top:25.0),
//               child: Form(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     SizedBox(
//                       height: 75,
//                       width: 75,
//                       child: TextField(
//                         onChanged: (value) {
//                           if (value.length == 1) {
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                         decoration: InputDecoration(
//                             // hintText: '0',
//                             fillColor: Colors.white,
//                             filled: true,
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10.0))),
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.headline6,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(1),
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 75,
//                       width: 75,
//                       child: TextField(
//                         onChanged: (value) {
//                           if (value.length == 1) {
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                         decoration: InputDecoration(
//                             // hintText: '0',
//                             fillColor: Colors.white,
//                             filled: true,
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10.0))),
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.headline6,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(1),
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 75,
//                       width: 75,
//                       child: TextField(
//                         onChanged: (value) {
//                           if (value.length == 1) {
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                         decoration: InputDecoration(
//                             // hintText: '0',
//                             fillColor: Colors.white,
//                             filled: true,
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10.0))),
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.headline6,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(1),
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 75,
//                       width: 75,
//                       child: TextField(
//                         onChanged: (value) {
//                           if (value.length == 1) {
//                             // FocusScope.of(context).nextFocus();
//                           }
//                         },
//                         decoration: InputDecoration(
//                             // hintText: '0',
//                             fillColor: Colors.white,
//                             filled: true,
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10.0))),
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.headline6,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(1),
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top:15.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Don\'t receive your code?',textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontSize: 18.0
//                     ),),
//                   TextButton(onPressed: () {}, child: const Text('Resend',textAlign: TextAlign.center,))
//                 ],
//               ),
//             ),
//
//
//             // Expanded(child: SizedBox()),
//
//             InkWell(
//
//               onTap: (){
//                 Navigator.pushNamed(context, ProfileSetup.route);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(top:15.0),
//                 child: Container(
//                   alignment: Alignment.center,
//                   width: MediaQuery.of(context).size.width,
//                   height: 50.0,
//                   decoration: BoxDecoration(
//                       color: Colors.lightBlue[900],
//                       border: Border.all(color: Colors.blue.shade50),
//                       borderRadius: BorderRadius.circular(40.0)),
//                   child: const Text(
//                     'Next',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20.0,
//                         letterSpacing: 1.0,
//                         fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         )),
//       ),
//     );
//   }
// }
// Future<bool> saveSharedPref({required String uuid,required String fullName,required String email,required String phone, required String password })async{
//   SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
//   await sharedPreferences.setString(Constants.faUUID, uuid);
//   await sharedPreferences.setString(Constants.faFullName, fullName);
//   await sharedPreferences.setString(Constants.faEmail, email);
//   await sharedPreferences.setString(Constants.faPhone, phone);
//   return await sharedPreferences.setString(Constants.faPassword, password);
//
// }
//
// // SAVE THE USER VALUES IN SHARED PREF
