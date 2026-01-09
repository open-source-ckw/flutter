// // ignore_for_file: prefer_const_constructors
//
// import 'package:flutter/material.dart';
//
//
// import '../Util/TrainingEntity.dart';
// import 'FullBodyWorkout.dart';
//
// class PersonalTraining extends StatelessWidget {
//   static const String route = 'PersonalTraining';
//   List<TrainingEntity> trainings = [];
//   PersonalTraining({Key? key}) : super(key: key);
//
//   List categoryTraining = ['Beginner', 'Advanced', 'Medium', 'Irregular Training'];
//
//   @override
//   Widget build(BuildContext context) {
//   dynamic data = ModalRoute.of(context)!.settings.arguments;
//   trainings = data;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//           backgroundColor: Colors.white,
//         // centerTitle: true,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Center(
//                 child: Text(
//                   'Personal Trainings',
//                   textAlign: TextAlign.left,
//                   style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal),
//                 ),
//               ),
//             ),
//
//             GestureDetector(
//               child: Text('Create',style: TextStyle(fontSize: 15.0,letterSpacing: 1.0,fontWeight: FontWeight.normal),),onTap: (){
//               Navigator.pushNamed(context, FullBodyWorkoutScreen.route);
//             },)
//           ],
//         ),
//
//       ),
//       body: SingleChildScrollView(
//         physics:  NeverScrollableScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 10),
//           child: Column(
//             children: [
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 7.0, right: 7.0, bottom: 10.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         height: 35.0,
//                         width: 85.0,
//                         padding: EdgeInsets.all(7.0),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(25.0),
//                             border: Border.all(width: 2)),
//                         child: const Text(
//                           'Clear All',
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 35.0,
//                         width: MediaQuery.of(context).size.width - 100.0,
//                         child: ListView.builder(
//                           clipBehavior: Clip.antiAliasWithSaveLayer,
//                           physics: const BouncingScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.only(left: 7.0, right: 7.0),
//                               child: Container(
//                                   height: 5.0,
//                                   width: 85.0,
//                                   padding: EdgeInsets.all(7.0),
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(25.0),
//                                       border: Border.all(width: 2)),
//                                   alignment: Alignment.center,
//                                   child: Text(categoryTraining[index])),
//                             );
//                           },
//                           itemCount: categoryTraining.length,
//                           scrollDirection: Axis.horizontal,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height -101.0,
//                 width: MediaQuery.of(context).size.width,
//                 child: GridView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2, mainAxisSpacing: 0.0, childAspectRatio: 1.2),
//                   itemBuilder: (context, index) {
//                     TrainingEntity training = trainings[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(left: 7.0, right: 7.0,top: 7.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Stack(
//                             children: [
//                               ClipRRect(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   child: Image.asset('assets/images/1.jpg')),
//                               Positioned(
//                                   top: 7.0,
//                                   right: 7.0,
//                                   child: training.isFavorite
//                                       ? Icon(
//                                     Icons.favorite,
//                                     color: Colors.red,
//                                   )
//                                       : Icon(
//                                     Icons.favorite_border,
//                                     color: Colors.red,
//                                   ))
//                             ],
//                           ),
//                           Text(training.text),
//                           Text(training.subtext)
//                         ],
//                       ),
//                     );
//                   },
//                   itemCount: trainings.length,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
