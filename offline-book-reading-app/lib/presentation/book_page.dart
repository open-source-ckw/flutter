import 'dart:io';

import 'package:book_reader_app/core/colors.dart';
import 'package:book_reader_app/core/responsive.dart';
import 'package:book_reader_app/presentation/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import '../models/new_model.dart';
import '../provider/font_size_provider.dart';
import 'custom/app_drawer.dart';


class TopicDetailScreen extends StatelessWidget {
  final Isar isar;
  final String sName;
  final String topicName;
  final int sId;
  final int topicId;
  final String topicTName;
  final List<Topic> topics;
  final int currentIndex;
  final bool pageChange;

  const TopicDetailScreen({
    super.key,
    required this.isar,
    required this.sName,
    required this.topicName,
    required this.topicId,
    required this.sId,
    required this.topics,
    required this.currentIndex,
    required this.topicTName,
    this.pageChange = false,
  });

  static const route = '/TopicDetail_screen';

  Future<List<Content>> getTopicContents(int topicId) async {
    final contents = await isar.contents.filter().tIdEqualTo(topicId).findAll();
    return contents;
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Scaffold(
      backgroundColor: lighterSecondary,
      drawerEnableOpenDragGesture: false,
      drawer: AppDrawer(isar: isar,),
      appBar: AppBar(
        title: Text(
          sName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(isar: isar,),));
              },
              icon: const Icon(Icons.settings)),

        ],
      ),
      bottomNavigationBar: Container(
        height: Platform.isIOS ? screenHeight(context) * 0.08 : screenHeight(context) * 0.065,
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 15.0 : 5.0, left: 15.0, right: 15.0),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.9),
          border: Border(
            top: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5)
          )
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("A-", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: appBlack),),
            Expanded(
              child: Slider(
                activeColor: primaryColor,
                allowedInteraction: SliderInteraction.tapAndSlide,
                min: 10,
                max: 35,
                value: fontSizeProvider.fontSize.toDouble(),
                onChanged: (val) {
                  fontSizeProvider.updateFontSize(val.toInt());
                },
              ),
            ),
            Text("A+", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: appBlack),),
          ],
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) async {
          // Swipe Right ➝ Previous Page
          if (details.primaryVelocity! > 0) {
            if (currentIndex > 0) {
              final prev = topics[currentIndex - 1];

              Navigator.pushReplacement(
                context,
                TurnPageRoute(
                  overleafColor: appWhite,
                  transitionDuration: const Duration(milliseconds: 800),
                  direction: TurnDirection.leftToRight,
                  builder: (context) => TopicDetailScreen(
                    isar: isar,
                    topicName: prev.tName,
                    topicId: prev.tId,
                    sId: sId,
                    topics: topics,
                    currentIndex: currentIndex - 1,
                    topicTName: prev.tTranslateName,
                    sName: sName,
                    pageChange: true,
                  ),
                ),
              );
            }
          }
          // Swipe Left ➝ Next Page
          else if (details.primaryVelocity! < 0) {
            if (currentIndex < topics.length - 1) {
              final next = topics[currentIndex + 1];

              Navigator.pushReplacement(
                context,
                TurnPageRoute(
                  overleafColor: appWhite,
                  transitionDuration: const Duration(milliseconds: 800),
                  builder: (context) => TopicDetailScreen(
                    isar: isar,
                    topicName: next.tName,
                    topicId: next.tId,
                    sId: sId,
                    topics: topics,
                    currentIndex: currentIndex + 1,
                    topicTName: next.tTranslateName,
                    sName: sName,
                    pageChange: true,
                  ),
                ),
              );
            }
          }
        },
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [secondaryColor.withOpacity(0.9), lighterSecondary],
                transform: const GradientRotation(180),

              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeightGap(gap: 0.015),
                Align(
                  alignment: AlignmentGeometry.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "$topicName\n",
                      style: TextStyle(
                          color: appBlack, fontWeight: FontWeight.bold, fontSize: 30),
                      children: [
                        TextSpan(
                            text: topicTName,
                            style: TextStyle(
                                color: appBlue600,
                                fontWeight: FontWeight.bold,
                                fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                const HeightGap(gap: 0.015),
                // book contents
                Expanded(
                  child: FutureBuilder<List<Content>>(
                    future: getTopicContents(topicId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final contents = snapshot.data!;

                      return ListView.builder(
                        itemCount: contents.length,
                        itemBuilder: (context, index) {
                          final item = contents[index];

                          if (item.cImage != null && item.cImage!.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Image.asset( // or Image.network
                                height: 200,
                                item.cImage!,
                                fit: BoxFit.contain,
                              ),
                            );
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            child: Text(
                              item.cText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: fontSizeProvider.fontSize.toDouble(),
                                height: fontSizeProvider.height.toDouble(),
                                fontWeight: fontSizeProvider.isBold
                                    ? FontWeight.bold
                                    : (item.cBold ? FontWeight.bold : FontWeight.normal),
                                color: appBlack,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}