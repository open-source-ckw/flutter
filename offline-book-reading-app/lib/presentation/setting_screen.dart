import 'package:book_reader_app/core/colors.dart';
import 'package:book_reader_app/core/responsive.dart';
import 'package:book_reader_app/presentation/custom/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

import '../provider/font_size_provider.dart';

class SettingScreen extends StatelessWidget {
  final Isar isar;
  const SettingScreen({super.key, required this.isar});

  static const route = '/Setting_screen';

  final String dummy = "गृहस्थ के लिए आचार्यों ने षट क्रियाएँ बतलाई हैं। इनमें देव पूजा श्रावक धर्म का प्रमुख अंग है। जिनपूजा ही मोक्षमार्ग के लिए सर्वोत्कृष्ट उपाय है।.....";

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontSizeProvider>(context);
    return Scaffold(
      drawer: AppDrawer(isar: isar),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text("TEXT SETTING FOR CONTENT PAGE", style: TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w600),),
            const HeightGap(gap: 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bold", style: TextStyle(fontWeight: FontWeight.w600, color: appBlack, fontSize: 15),),
                    const HeightGap(gap: 0.02),
                    Text("(गहरे शब्द)", style: TextStyle(fontWeight: FontWeight.w600, color: appBlack, fontSize: 15),),
                  ],
                ),
                Switch(
                  thumbColor: WidgetStatePropertyAll(primaryColor),
                  activeTrackColor: primaryColor.withOpacity(0.6),
                  inactiveTrackColor: secondaryColor,
                  inactiveThumbColor: primaryColor.withOpacity(0.7),
                  value: fontProvider.isBold,
                  onChanged: (val) {
                    fontProvider.toggleBold(val);
                  },
                ),
              ],
            ),
             Divider(
               color: primaryColor,
               thickness: 1.5,
             ),
            const HeightGap(gap: 0.02),
            Text("Default Text Size : ${fontProvider.fontSize.toString()}", style: TextStyle(fontWeight: FontWeight.w600, color: appBlack, fontSize: 15),),
            Text("( शब्दों का आकार )", style: TextStyle(fontWeight: FontWeight.w600, color: appBlack, fontSize: 15),),

            Row(
              children: [
                Text("A-", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: appBlack),),
                Expanded(
                  child: Slider(
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    activeColor: primaryColor,
                    allowedInteraction: SliderInteraction.tapAndSlide,
                    min: 10,
                    max: 35,
                    // divisions: 25,

                    value: fontProvider.fontSize.toDouble(),
                    onChanged: (val) {
                      fontProvider.updateFontSize(val.toInt());
                    },
                  ),
                ),
                Text("A+", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 35, color: appBlack),),
              ],
            ),
            Divider(
              color: primaryColor,
              thickness: 1.5,
            ),
            const HeightGap(gap: 0.02),
            Text("Space Between Each Line: ${fontProvider.height.toString()}", style: TextStyle(color: appBlack, fontSize: 15),),
            Text("( दो लाइन के बीच का अंतर )", style: TextStyle(color: appBlack, fontSize: 15),),
            Slider(
              activeColor: primaryColor,
              allowedInteraction: SliderInteraction.slideOnly,
              min: 1.0,
              max: 10.0,
              value: fontProvider.height.toDouble(),
              onChanged: (val) {
                fontProvider.lineHeight(val.toInt());
              },
            ),
            Divider(
              color: primaryColor,
              thickness: 1.5,
            ),
            const HeightGap(gap: 0.02),
            Text(dummy, style: TextStyle(color: appBlack, fontSize: fontProvider.fontSize.toDouble(), fontWeight: fontProvider.isBold ? FontWeight.bold : FontWeight.normal, height: fontProvider.height.toDouble()),)
          ],
        ),
      ),
    );
  }
}
