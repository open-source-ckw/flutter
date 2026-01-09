// import 'package:flutter/material.dart';
//
// import 'WarmUpScreen.dart';
//
// class FullBodyWorkoutScreen extends StatefulWidget {
//   const FullBodyWorkoutScreen({Key? key}) : super(key: key);
//
//   // static const String route = '/';
//   static const String route = 'FullBodyWorkout';
//   @override
//   State<FullBodyWorkoutScreen> createState() => _FullBodyWorkoutScreenState();
// }
//
// class _FullBodyWorkoutScreenState extends State<FullBodyWorkoutScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.blue.shade50,
//         appBar: AppBar(
//           elevation: 0.0,
//           backgroundColor: Colors.blue.shade50,
//           centerTitle: true,
//           title: const Text('Full Body Workout'),
//         ),
//         body: Container(
//           padding: const EdgeInsets.all(10.0),
//           height: MediaQuery.of(context).size.height - 50,
//           width: MediaQuery.of(context).size.width,
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text('Full Body Workout'),
//                       IconButton(
//                           onPressed: () {}, icon: const Icon(Icons.edit))
//                     ],
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Container(
//                       height: 75.0,
//                       width: (MediaQuery.of(context).size.width / 3) - 30.0,
//                       padding: EdgeInsets.all(15.0),
//                       decoration: BoxDecoration(
//                           color: Colors.blueGrey.shade50,
//                           borderRadius: BorderRadius.circular(10.0),
//                           border: Border.all(
//                               color: Colors.blueGrey.withAlpha(30))),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [Text('12'), Text('Exercises')],
//                       ),
//                     ),
//                     Container(
//                       height: 75.0,
//                       width: (MediaQuery.of(context).size.width / 3) - 30.0,
//                       padding: EdgeInsets.all(15.0),
//                       decoration: BoxDecoration(
//                           color: Colors.blueGrey.shade50,
//                           borderRadius: BorderRadius.circular(10.0),
//                           border: Border.all(
//                               color: Colors.blueGrey.withAlpha(30))),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [Text('30:00'), Text('Time')],
//                       ),
//                     ),
//                     Container(
//                       height: 75.0,
//                       width: (MediaQuery.of(context).size.width / 3) - 30.0,
//                       padding: EdgeInsets.all(15.0),
//                       decoration: BoxDecoration(
//                           color: Colors.blueGrey.shade50,
//                           borderRadius: BorderRadius.circular(10.0),
//                           border: Border.all(
//                               color: Colors.blueGrey.withAlpha(30))),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [Text('260'), Text('Calorie')],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 25.0,
//                 ),
//
//                 ListTile(
//                   onTap: () {},
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(15.0),
//                           topRight: Radius.circular(15.0))),
//                   title: Text('Choose Equipment'),
//                   trailing: Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('2 Dumbells, Mat'),
//                         Icon(
//                           Icons.arrow_forward_ios,
//                           size: 15.0,
//                         ),
//                       ],
//                     ),
//                   ),
//                   tileColor: Colors.white,
//                 ),
//                 ListTile(
//                   onTap: () {},
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(15.0),
//                           bottomRight: Radius.circular(15.0))),
//                   title: Text('Choose Focus Area'),
//                   trailing: Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Legs, Core muscles'),
//                         Icon(
//                           Icons.arrow_forward_ios,
//                           size: 15.0,
//                         ),
//                       ],
//                     ),
//                   ),
//                   tileColor: Colors.white,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Warm-up'),
//                     TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, WarmUpScreen.route);
//                         },
//                         child: Text('Edit'))
//                   ],
//                 ),
//                 getListTile(
//                     imagePath: 'assets/images/1.jpg',
//                     title: 'Cobra Stretch',
//                     subTitle: '0:30',
//                     icon: Icons.info_outline,
//                     onTap: () {}),
//                 getListTile(
//                     imagePath: 'assets/images/1.jpg',
//                     title: 'Extended Side Angle',
//                     subTitle: '0:30',
//                     icon: Icons.info_outline,
//                     onTap: () {}),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Workout'),
//                   ],
//                 ),
//                 getEmptyListTime(
//                     imagePath: 'assets/images/1.jpg',
//                     title: 'Add Exercises',
//                     onTap: () {}),
//                 // getListTile(imagePath: 'assets/images/1.jpg', title: 'Low Lunge', subTitle: '0:30', icon:Icons.info_outline, onTap: (){}),
//                 // getListTile(imagePath: 'assets/images/1.jpg', title: 'Downward Dog', subTitle: '0:30', icon:Icons.info_outline, onTap: (){}),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Stretching'),
//                     TextButton(onPressed: () {}, child: Text('Edit'))
//                   ],
//                 ),
//                 getListTile(
//                     imagePath: 'assets/images/1.jpg',
//                     title: 'Low Lunge',
//                     subTitle: '0:30',
//                     icon: Icons.info_outline,
//                     onTap: () {}),
//
//                 getListTile(
//                     imagePath: 'assets/images/1.jpg',
//                     title: 'Downward Dog',
//                     subTitle: '0:30',
//                     icon: Icons.info_outline,
//                     onTap: () {}),
//
//
//
//               ],
//             ),
//           ),
//         ),
//
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.blue.shade50,
//         elevation: 0,
//         child: Container(
//           height: 70,
//           width: MediaQuery.of(context).size.width,
//           // padding: EdgeInsets.only(top: 25.0),
//           alignment: Alignment.center,
//           child: InkWell(
//             onTap: () {},
//             child: Container(
//               alignment: Alignment.center,
//               width: MediaQuery.of(context).size.width - 20.0,
//               height: 50.0,
//               decoration: BoxDecoration(
//                   color: Colors.lightBlue[900],
//                   // border: Border.all(),
//                   borderRadius: BorderRadius.circular(40.0)),
//               child: const Text(
//                 'Save & Start',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20.0,
//                     letterSpacing: 1.0,
//                     fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       ),
//
//     );
//   }
//
//   Widget getEmptyListTime({
//     required String imagePath,
//     required String title,
//     required dynamic onTap,
//     subTitle,
//     icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 7.0,top: 10),
//       child: ListTile(
//         onTap: () {
//           // Navigator.pushNamed(context, AllExercises.route);
//         },
//         minVerticalPadding: 12.0,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//         tileColor: Colors.white,
//         leading: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.asset(imagePath)),
//         trailing: Icon(
//           icon,
//           size: 30.0,
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title),
//             Text('')
//           ],
//         ),
//         // subtitle: Text(''),
//       ),
//     );
//   }
//
//   Widget getListTile(
//       {required String imagePath,
//       required String title,
//       required String subTitle,
//       required IconData icon,
//       required dynamic onTap}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 7.0),
//       child: ListTile(
//         onTap: () {
//           // Navigator.pushNamed(context, AllExercises.route);
//         },
//         minVerticalPadding: 12.0,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//         tileColor: Colors.white,
//         leading: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.asset(imagePath)),
//         trailing: Icon(
//           icon,
//           size: 30.0,
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [Text(title), Text(subTitle)],
//         ),
//       ),
//     );
//   }
// }
