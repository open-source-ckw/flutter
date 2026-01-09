import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:stacks/controller/profile_controller.dart';

class SocialAccounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController())!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        shadowColor: Colors.grey.shade50,
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Social Accounts",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff002347),
            fontSize: 20,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Click on social media icon to link your accounts",
                  style: TextStyle(
                    color: Color(0xffb0becc),
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GridView.count(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: (controller.socialAccounts.length / 2).ceil(),
                // Generate 100 widgets that display their index in the List.
                children: List.generate(controller.socialAccounts.length, (index) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        print(index);
                      },
                      child: SvgPicture.asset(
                        controller.socialAccounts[index],
                        semanticsLabel: "Icon for ${controller.socialAccounts[index]}",
                        height: 50,
                        width: 50,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 15),
              Opacity(
                opacity: 0.30,
                child: Container(
                  width: 343,
                  height: 1,
                  color: Color(0xffb0becc),
                ),
              ),
              SizedBox(height: 25),
              TextBox(image: "images/logos_gmail.png", text: 'jonathandoe@gmail.com'),
              SizedBox(height: 20),
              TextBox(image: "images/logos_facebook.png", text: "jonathandoeson"),
              SizedBox(height: 20),
              TextBox(image: "images/logos_whatsapp.png", text: "+01 234 567 89 10"),
              SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                    child: Text(
                      "SAVE CHANGES",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        letterSpacing: 0.80,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Color(0xffffb34b))))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  final String text;
  final String image;

  const TextBox({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: false,
      autocorrect: true,
      decoration: InputDecoration(
        hintText: text,
        prefixIcon: Image.asset(
          image,
          height: 20,
          width: 20,
        ),
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: Color(0x63b0becc),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: Color(0x63b0becc),
            width: 1,
          ),
        ),
      ),
    );
  }
}
