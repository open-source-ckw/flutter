import 'package:flutter/material.dart';

Color scaffoldBackgroundColor = const Color(0xffedf2f4);
Color cardColor = const Color(0xFF555868);
// Color cardColor = const Color(0xFFe0fbfc);
Color appPrimaryColor = const Color(0xff023047);

const createDB = "createDB";
const getDB = "getDB";

List m = [];

logOutDialog(
    {required context,
    required text,
    required title,
    required Function() yesOnTap,
    required Function() noOnTap}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              title,
              // style: TextStyle(fontFamily: "Comici"),
            ),
            content: Text(text),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: yesOnTap,
                    child: const Text('Yes',
                        style:
                            TextStyle(/*fontFamily: "Comici",*/ fontSize: 15)),
                  ),
                  TextButton(
                    onPressed: noOnTap,
                    child: const Text(
                      'No',
                      style: TextStyle(/*fontFamily: "Comici",*/ fontSize: 15),
                    ),
                  )
                ],
              ),
            ],
          );
        });
      });
}
