import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';

import '../constants/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../services/assets_manager.dart';
import 'text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bubble/bubble.dart';

class ChatWidget extends StatefulWidget {
  ChatWidget({
    super.key,
    required this.msg,
    required this.chatIndex,
    required this.isSelected,
    /*required this.user*/
  });

  final String msg;
  final int chatIndex;
  bool isSelected;
  // final User user;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  File? imageFile;
  User? user = FirebaseAuth.instance.currentUser;

/*  void shareData(BuildContext context) {
    Share.share(widget.msg).then((value) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Share Compeleted")));
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: /* widget.chatIndex == 0
            ?*/
            Bubble(
          // margin: const BubbleEdges.only(top: 10),
          padding: const BubbleEdges.symmetric(horizontal: 15, vertical: 10),
          radius: const Radius.circular(20.0),
          alignment:
              widget.chatIndex == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: widget.chatIndex == 0
              ? BubbleNip.leftBottom
              : BubbleNip.rightBottom,
          elevation: 5,
          style: BubbleStyle(
              color: widget.chatIndex == 0 ? Colors.white : cardColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                widget.msg,
                style: TextStyle(
                  color: widget.chatIndex == 0 ? Colors.black : Colors.white,
                  // fontWeight: FontWeight.w700,
                  fontSize: 18, /*fontFamily: "Comici"*/
                ),
              )),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
        )
        /*Align(
        alignment: widget.chatIndex == 0
            ? Alignment.bottomLeft
            : Alignment.bottomRight,
        child: Container(
          width: widget.chatIndex == 0
              ? MediaQuery.of(context).size.width * 0.8
              : MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: widget.chatIndex == 0
                  ? const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))
                  : const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
              color: widget.chatIndex == 0
                  ? cardColor.withOpacity(0.7)
                  : cardColor),

          // Colors.lightBlueAccent.shade100
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: */ /*widget.chatIndex == 0
                      ? TextWidget(
                          label: widget.msg,
                        )
                      : TextWidget(
                          label: widget.msg
                              .trim()),*/ /*
                        DefaultTextStyle(
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                  child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      repeatForever: false,
                      displayFullTextOnTap: true,
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText(
                          widget.msg.trim(),
                        ),
                      ]),
                )
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.chatIndex == 0
                        ? AssetsManager.userImage
                        : AssetsManager.botImage,
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),*/
        );
  }

  Widget bubbleContainer() {
    return Bubble(
      // margin: const BubbleEdges.only(top: 10),
      padding: const BubbleEdges.symmetric(horizontal: 15, vertical: 10),
      radius: const Radius.circular(20.0),
      alignment: widget.chatIndex == 0 ? Alignment.topLeft : Alignment.topRight,
      nip: widget.chatIndex == 0 ? BubbleNip.leftBottom : BubbleNip.rightBottom,
      elevation: 5,
      style:
          BubbleStyle(color: widget.chatIndex == 0 ? Colors.white : cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
            widget.msg,
            style: TextStyle(
                color: widget.chatIndex == 0 ? Colors.black : Colors.white,
                // fontWeight: FontWeight.w700,
                fontSize: 18),
          )),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.chatIndex == 0
                  ? AssetsManager.userImage
                  : AssetsManager.botImage,
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
    );
  }
}
