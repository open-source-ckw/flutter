// import 'package:auto_orientation/auto_orientation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
// import 'package:wakelock/wakelock.dart';
//
// class AdvancedOverlayWidget extends StatelessWidget {
//   final VideoPlayerController controller;
//   final VoidCallback onClickedFullScreen;
//   final bool isPortrait;
//   Orientation? target;
//
//   static const allSpeeds = <double>[0.25, 0.5, 1, 1.5, 2, 3, 5, 10];
//
//   AdvancedOverlayWidget({
//     Key? key,
//     required this.controller,
//     required this.onClickedFullScreen,
//     required this.isPortrait,
//     required this.target
//   }) : super(key: key);
//
//   String getPosition() {
//     final duration = Duration(
//         milliseconds: controller.value.position.inMilliseconds.round());
//
//     return [duration.inMinutes, duration.inSeconds]
//         .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
//         .join(':');
//   }
//
//   void setOrientation(bool isPortrait) {
//     if (isPortrait) {
//       Wakelock.disable();
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//           overlays: SystemUiOverlay.values);
//     } else {
//       Wakelock.enable();
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) => OrientationBuilder(builder: (context, orientation) {
//     final isPortrait = orientation == Orientation.portrait;
//
//     setOrientation(isPortrait);
//
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () =>
//       controller.value.isPlaying ? controller.pause() : controller.play(),
//       child: Stack(
//         children: <Widget>[
//
//           buildPlay(),
//
//
//           Material(
//             color: Colors.transparent,
//             child:  Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//               child: IconButton(
//                   onPressed: (){
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(Icons.arrow_back_ios,color: Colors.red,)),
//             ),
//           ),
//
//           // buildSpeed(),
//           // Positioned(
//           //   left: 8,
//           //   bottom: 28,
//           //   child: Text(getPosition()),
//           // ),
//
//           buildVideoPlayer(),
//
//
//           Positioned(
//               bottom: 4,
//               left: 0,
//               right: 0,
//               child: Row(
//                 children: [
//                   Expanded(child: buildIndicator()),
//                   const SizedBox(width: 12),
//                   GestureDetector(
//                     child: Icon(
//                       Icons.fullscreen,
//                       color: Colors.white,
//                       size: 28,
//                     ),
//                     onTap: (){
//                       target = isPortrait
//                           ? Orientation.landscape
//                           : Orientation.portrait;
//
//                       if (isPortrait) {
//                         AutoOrientation
//                             .landscapeRightMode();
//                       } else {
//                         AutoOrientation
//                             .portraitUpMode();
//                       }
//                     },
//                   ),
//                   const SizedBox(width: 8),
//                 ],
//               )),
//
//
//         ],
//       ),
//     );
//
//   });
//   Widget buildFullScreen({
//     required Widget child,
//   }) {
//     final size = controller.value.size;
//     final width = size.width;
//     final height = size.height;
//
//     return FittedBox(
//       fit: BoxFit.cover,
//       child: SizedBox(width: width, height: height, child: child),
//     );
//   }
//
//   Widget buildVideoPlayer() => buildFullScreen(
//     child: AspectRatio(
//       aspectRatio: controller.value.aspectRatio,
//       child: VideoPlayer(controller),
//     ),
//   );
//
//   Widget buildIndicator() => Container(
//         margin: EdgeInsets.all(8).copyWith(right: 0),
//         height: 16,
//         child: VideoProgressIndicator(
//           controller,
//           allowScrubbing: true,
//         ),
//       );
//
//   // Widget buildSpeed() => Align(
//   //       alignment: Alignment.topRight,
//   //       child: PopupMenuButton<double>(
//   //         initialValue: controller.value.playbackSpeed,
//   //         tooltip: 'Playback speed',
//   //         onSelected: controller.setPlaybackSpeed,
//   //         itemBuilder: (context) => allSpeeds
//   //             .map<PopupMenuEntry<double>>((speed) => PopupMenuItem(
//   //                   value: speed,
//   //                   child: Text('${speed}x'),
//   //                 ))
//   //             .toList(),
//   //         child: Container(
//   //           color: Colors.white38,
//   //           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//   //           child: Text('${controller.value.playbackSpeed}x'),
//   //         ),
//   //       ),
//   //     );
//
//   Widget buildPlay() => controller.value.isPlaying
//       ? Container()
//       : Container(
//           color: Colors.black26,
//           child: Center(
//             child: Icon(
//               controller.value.isPlaying
//                   ? Icons.pause
//                   : Icons.play_arrow,
//               color: Colors.white,
//               size: 70,
//             ),
//           ),
//         );
// }
