import 'package:flutter/material.dart';

class AppConstants {
  static const Color sBg = Color(0xffedf2f4);
  static const Color appPrimaryColor = Color(0xff023047);
  static const Color snackColor = Colors.green;
  static Color errorSnackColor = Colors.red.shade500;
  static Color warningSnackColor = Colors.yellow.shade200;

  static authButton(
      {required String text,
      required Function() onTap,
      required double width,
      required TextStyle textStyle}) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      constraints: BoxConstraints(minWidth: width, minHeight: 35),
      fillColor: AppConstants.appPrimaryColor,
      onPressed: onTap,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }

  static deleteAccountButton(
      {required String text,
      required Function() onTap,
      required double width,
      required TextStyle textStyle}) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      constraints: BoxConstraints(minWidth: width, minHeight: 35),
      fillColor: Colors.red,
      onPressed: onTap,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }

  static dialogBox(
      {required context,
      required title,
      required Function() yesOnTap,
      required Function() noOnTap}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: yesOnTap,
                          child: Text('Yes'),
                        ),
                        TextButton(
                          onPressed: noOnTap,
                          child: Text('No'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  static imagePickerBottomSheet(
      {required context,
      required Function() galleyOnTap,
      required Function() camaraOnTap}) {
    return showModalBottomSheet(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        // backgroundColor: Colors.white,
        barrierColor: Colors.blue.withOpacity(0.1),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: galleyOnTap,
                          child: Column(
                            children: const [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 90,
                              ),
                              Text(
                                'Gallery',
                              ),
                            ],
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      InkWell(
                          onTap: camaraOnTap,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_outlined,
                                size: 90,
                              ),
                              Text('Camera'),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  static const TextStyle textStyle20 =
      TextStyle(fontSize: 20, color: Colors.white,/*fontFamily: "Comici"*/);

  static const TextStyle textStyle15 =
      TextStyle(fontSize: 15, color: AppConstants.appPrimaryColor,/*fontFamily: "Comici"*/);

  static const TextStyle textStyle40 =
      TextStyle(fontSize: 40, color: AppConstants.appPrimaryColor,/*fontFamily: "Comici"*/);

  static InputDecoration authInputDec = InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    helperStyle: AppConstants.textStyle15,
    border: OutlineInputBorder(
        borderSide: BorderSide(color: AppConstants.appPrimaryColor),
        borderRadius: BorderRadius.circular(10)),
  );

  static getSuccessMsg(num) {
    switch (num) {
      case 1:
        {
          return 'Email address is not registered with us. Please sign up.';
        }
        break;
      case 2:
        {
          return 'Successfully registered and verification email is sent to your registered email please check your email to verify and login.';
        }
        break;
      case 3:
        {
          return 'Reset password link is sent to your email.Please check your email and reset the password';
        }
        break;
      default:
        {
          //Body of default case
        }
        break;
    }
  }

  static getErrorMsg(num) {
    switch (num) {
      case 1:
        {
          return 'Email address is not registered with us. Please sign up.';
        }
        break;
      case 2:
        {
          return 'Wrong password. Please enter correct password.';
        }
        break;
      case 3:
        {
          return 'Please enter password.';
        }
        break;
      case 4:
        {
          return 'Please enter full name.';
        }
        break;
      case 5:
        {
          return 'Please enter last name.';
        }
        break;
      case 6:
        {
          return 'Please enter phone number.';
        }
        break;
      case 7:
        {
          return 'Please select DOB.';
        }
        break;
      case 8:
        {
          return 'Please select gender.';
        }
        break;
      case 9:
        {
          return 'Please select Relation.';
        }
        break;
      case 10:
        {
          return 'Please select blood group.';
        }
        break;
      case 11:
        {
          return 'Email is already use for other family member. Please try another email.';
        }
        break;
      case 12:
        {
          return 'We have blocked all requests from this device due to unusual activity. Try again later.';
        }
        break;
      default:
        {
          return 'Something went wrong. Please try again.';
        }
        break;
    }
  }

  static getWarningMsg(num) {
    switch (num) {
      case 1:
        {
          return 'Invalid email. Please enter valid email.';
        }
        break;
      case 2:
        {
          return 'Your email is not verified. Please check your email to verify.';
        }
        break;
      case 3:
        {
          return 'Email is already registered. Please try with different email.';
        }
        break;
      default:
        {
          return 'Something went wrong. Please try again.';
        }
        break;
    }
  }

  static getAddDataMsg(num) {
    switch (num) {
      case 1:
        {
          return 'Member is added successfully.';
        }
        break;
      case 2:
        {
          return 'Report is added successfully.';
        }
        break;
      default:
        {
          return 'Something went wrong. Please try again.';
        }
        break;
    }
  }

  static getEditDataMsg(num) {
    switch (num) {
      case 1:
        {
          return 'Member profile is update successfully.';
        }
        break;
      case 2:
        {
          return 'Report is update successfully.';
        }
        break;
      case 3:
        {
          return 'User Profile is update successfully.';
        }
        break;
      default:
        {
          return 'Something went wrong. Please try again.';
        }
        break;
    }
  }

  static String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email.'
        : value.isEmpty
            ? 'Please enter email.'
            : null;
  }
}
