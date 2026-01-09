// // import 'package:flutter/material.dart';
// //
// // class AppColors{
// //
// //   static const Color darkGreyColor = Color(0xff10151E);
// //   // static const Color backgroundColor = Color(0xff00050f);
// //   static const Color darkBGColor = Color(0xff0B152A);
// //   static const Color darkBoxColor = Color(0xff404040);
// //
// //   static ThemeData themeDataDark(bool isDarkTheme, BuildContext context) {
// //     return ThemeData(
// //       primaryColor: isDarkTheme? Colors.lightBlue : Colors.lightBlue,
// //       backgroundColor:isDarkTheme? Colors.white : AppColors.darkBGColor,
// //       highlightColor: Colors.transparent,
// //       hoverColor: Colors.transparent,
// //       scaffoldBackgroundColor: Colors.transparent,
// //       splashColor: Colors.transparent,
// //       appBarTheme: const AppBarTheme(
// //           color: Colors.transparent
// //       ),
// //       focusColor: Colors.transparent,
// //       disabledColor: Colors.grey,
// //       brightness: isDarkTheme ? Brightness.dark : Brightness.light,
// //     );
// //   }
// //
// //   static ThemeData themeDataWhite(bool isDarkTheme, BuildContext context) {
// //     return ThemeData(
// //       primaryColor: Colors.white,
// //       backgroundColor:isDarkTheme? Colors.white : AppColors.darkBGColor,
// //       highlightColor: Colors.transparent,
// //       hoverColor: Colors.transparent,
// //       scaffoldBackgroundColor: Colors.transparent,
// //       splashColor: Colors.transparent,
// //       appBarTheme: const AppBarTheme(
// //           color: Colors.transparent
// //       ),
// //       focusColor: Colors.transparent,
// //       disabledColor: Colors.grey,
// //       brightness: isDarkTheme ? Brightness.dark : Brightness.light,
// //     );
// //   }
// //
// // }
//
// import 'package:flutter/material.dart';
//
// const COLOR_PRIMARY = Colors.deepOrangeAccent;
// const COLOR_ACCENT = Colors.orange;
//
// ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: COLOR_PRIMARY,
//     floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: COLOR_ACCENT
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ButtonStyle(
//             padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                 EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0)
//             ),
//             shape: MaterialStateProperty.all<OutlinedBorder>(
//                 RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0))
//             ),
//             backgroundColor: MaterialStateProperty.all<Color>(COLOR_ACCENT)
//         )
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//         border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide.none
//         ),
//         filled: true,
//         fillColor: Colors.grey.withOpacity(0.1)
//     )
// );
//
// ThemeData darkTheme = ThemeData(
//
//   brightness: Brightness.dark,
//   // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
//   switchTheme: SwitchThemeData(
//     trackColor: MaterialStateProperty.all<Color>(Colors.grey),
//     thumbColor: MaterialStateProperty.all<Color>(Colors.white),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide.none
//       ),
//       filled: true,
//       fillColor: Colors.grey.withOpacity(0.1)
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ButtonStyle(
//           padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//               EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0)
//           ),
//           shape: MaterialStateProperty.all<OutlinedBorder>(
//               RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0)
//               )
//           ),
//           backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
//           foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
//           overlayColor: MaterialStateProperty.all<Color>(Colors.black26)
//       )
//   ),
// );
//
