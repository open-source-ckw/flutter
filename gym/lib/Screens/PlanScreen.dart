// import 'package:flutter/material.dart';
//
// import 'SignInScreen.dart';
//
// class PlanScreen extends StatefulWidget {
//   const PlanScreen({Key? key}) : super(key: key);
//
//   static const route = '';
//   @override
//   State<PlanScreen> createState() => _PlanScreenState();
// }
//
// class _PlanScreenState extends State<PlanScreen> {
//   int selectedContainer =1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             color: Colors.lightBlueAccent,
//           ),
//
//           Positioned(
//             top: -50,
//             right: 0,
//             left: 0,
//             child: SizedBox(
//               // alignment: Alignment.center,
//                 height: 350,
//                 child: Image.asset('assets/images/young-woman-stretching-before-workout.png',fit: BoxFit.contain,)),
//           ),
//
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: const EdgeInsets.only(top: 20.0),
//               height: MediaQuery.of(context).size.height / 1.4,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(
//                     color: Colors.white, style: BorderStyle.solid, width: 1.0),
//                 borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0)),
//               ),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 15.0, right: 15.0,top:15.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     // crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: const [
//                           Expanded(
//                             child: Text(
//                               'Millions of Users\' choice',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 28.0,
//                               ),
//                               maxLines: 2,
//                             ),
//                           )
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
//                         child: Row(
//                           children: const [
//                             Expanded(
//                               child: Text(
//                                 'We believe that our app should inspire you to be the best version of yourself',
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//                                 ),
//                                 maxLines: 3,
//                                 // textAlign: TextAlign.center,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           getPlanBenefitContainer(
//                               isActive: true,
//                               text: 'Professional videos with coatches'),
//                           getPlanBenefitContainer(
//                               isActive: true,
//                               text: 'Over 100 ready-made workouts'),
//                           getPlanBenefitContainer(
//                               isActive: true,
//                               text: 'Create your personal training plan'),
//                           getPlanBenefitContainer(
//                               isActive: true, text: 'Without advertising'),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 25.0),
//                         child: SizedBox(
//                           height: 125.0,
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             children: [
//                               getPlanPriceContainer(
//                                 isActive: selectedContainer ==1,
//                                   containerIndex: 1,
//                                   duration: 'Monthly',
//                                   cost: '5.99\$',
//                                   daysUnit: 'per month',
//                               isBadge: false),
//                               getPlanPriceContainer(
//                                 isActive: selectedContainer ==2,
//                                   containerIndex: 2,
//                                   duration: 'Yearly',
//                                   cost: '39.99\$',
//                                   daysUnit: 'per year',
//                                 isBadge: true,
//                                 discount: 70
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                           padding: const EdgeInsets.only(top: 25.0),
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.pushNamed(context, SignInScreen.route);
//                               // Navigator.pushNamed(context, ProfileSetup.route);
//                             },
//                             child: Container(
//                               alignment: Alignment.center,
//                               width: MediaQuery.of(context).size.width,
//                               height: 50.0,
//                               decoration: BoxDecoration(
//                                   color: Colors.lightBlue[900],
//                                   border: Border.all(color: Colors.blue.shade50),
//                                   borderRadius: BorderRadius.circular(40.0)),
//                               child: const Text(
//                                 'Continue',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 20.0,
//                                     letterSpacing: 1.0,
//                                     fontWeight: FontWeight.bold),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           )),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget getPlanBenefitContainer(
//       {bool isActive = false, required String text}) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           AnimatedContainer(
//             // padding: const EdgeInsets.only(right: 10.0),
//             duration: const Duration(milliseconds: 1000),
//             curve: Curves.fastOutSlowIn,
//             decoration: BoxDecoration(
//                 color: isActive ? Colors.lightBlue.shade600 : Colors.grey[350],
//                 borderRadius: BorderRadius.circular(50.0),
//                 border: Border.all(
//                     color: isActive ? Colors.lightBlueAccent : Colors.grey,
//                     width: 1.0)),
//             height: 20.0,
//             width: 20.0,
//             child: const Icon(
//               Icons.check,
//               color: Colors.white,
//               size: 14.0,
//             ),
//           ),
//           Expanded(
//               child: Padding(
//             padding: const EdgeInsets.only(left: 10.0),
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 15.0),
//             ),
//           ))
//         ],
//       ),
//     );
//   }
//
//   Widget getPlanPriceContainer(
//       {
//         bool isActive=false,
//         required int containerIndex,
//         required String duration,
//       required String cost,
//       required String daysUnit,
//       bool isBadge = false,
//       int discount = 0}) {
//     return InkWell(
//       onTap: (){
//         setState((){
//           selectedContainer = containerIndex;
//         });
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//         child: Stack(
//           children: [
//            isBadge ?  Positioned(
//                 top: 7.0,
//                 right: 7.0,
//                 child: Container(
//                   padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
//                   color: Colors.blue.shade100,
//                   child: Text('Save $discount \$',style: const TextStyle(fontWeight: FontWeight.bold,),),
//                 )):Container(),
//             Container(
//               width: 170.0,
//               height: 120.0,
//               padding: const EdgeInsets.only(
//                   top: 5.0, bottom: 5.0, left: 25.0, right: 25.0),
//               decoration: BoxDecoration(
//                   border: Border.all(color: isActive ?  Colors.blue.shade600 : Colors.grey.withOpacity(0.3)),
//                   borderRadius: BorderRadius.circular(10.0)),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     FittedBox(
//                         fit: BoxFit.fitWidth,
//                         child: Text(
//                           duration,
//                           style:  TextStyle(
//                             color: isActive ? Colors.blue.shade900:Colors.black,
//                               fontSize: 18.0, fontWeight: FontWeight.bold),
//                         )),
//                     FittedBox(
//                         fit: BoxFit.fitWidth,
//                         child: Text(
//                           cost,
//                           style:  TextStyle(
//                               color: isActive ? Colors.blue.shade900:Colors.black,
//                               fontSize: 20.0, fontWeight: FontWeight.bold),
//                         )),
//                     FittedBox(
//                         fit: BoxFit.fitWidth,
//                         child: Text(
//                           daysUnit,
//                           style: TextStyle(
//                             color: Colors.black.withOpacity(0.4),
//                               fontSize: 14.0, fontWeight: FontWeight.bold),
//                         )),
//                   ]),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
