// import 'package:auto_orientation/auto_orientation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:grace_fitness/Util/videoplayerpage.dart';
// // import 'package:video_ii_example/widget/basic_overlay_widget.dart';
// import 'package:video_player/video_player.dart';
// import 'package:wakelock/wakelock.dart';
// import 'package:native_device_orientation/native_device_orientation.dart';
// import '../Components/basic_overlay_widget.dart';
//
// class VideoPlayerFullscreenWidget extends StatefulWidget {
//   final VideoPlayerController controller;
//
//   const VideoPlayerFullscreenWidget({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   State<VideoPlayerFullscreenWidget> createState() =>
//       _VideoPlayerFullscreenWidgetState();
// }
//
// class _VideoPlayerFullscreenWidgetState
//     extends State<VideoPlayerFullscreenWidget> {
//
//   Orientation? target;
//
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
//   void initState() {
//     super.initState();
//
//     NativeDeviceOrientationCommunicator()
//         .onOrientationChanged(useSensor: true)
//         .listen((event) {
//       final isPortrait = event == NativeDeviceOrientation.portraitUp;
//       final isLandscape = event == NativeDeviceOrientation.landscapeLeft ||
//           event == NativeDeviceOrientation.landscapeRight;
//       final isTargetPortrait = target == Orientation.portrait;
//       final isTargetLandscape = target == Orientation.landscape;
//
//       if (isPortrait && isTargetPortrait || isLandscape && isTargetLandscape) {
//         target = null;
//         SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) => widget.controller != null &&
//           widget.controller.value.isInitialized
//       ? Container(alignment: Alignment.topCenter, child: buildVideo(context))
//       : Center(child: CircularProgressIndicator());
//
//   Widget buildVideo(context) => OrientationBuilder(builder: (context, orientation){
//     final isPortrait = orientation == Orientation.portrait;
//
//     setOrientation(isPortrait);
//     return Stack(
//       fit: isPortrait ? StackFit.loose : StackFit.expand,
//       children: <Widget>[
//
//         Material(
//           color: Colors.transparent,
//           child:  IconButton(
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//               icon: Icon(Icons.arrow_back_ios,color: Colors.red,)),
//         ),
//
//         Material(
//           child: AdvancedOverlayWidget(
//             controller: widget.controller,
//             onClickedFullScreen: () {
//               target = isPortrait
//                   ? Orientation.landscape
//                   : Orientation.portrait;
//
//               if (isPortrait) {
//                 AutoOrientation.landscapeRightMode();
//               } else {
//                 AutoOrientation.portraitUpMode();
//               }
//             },
//           ),
//         ),
//
//
//         buildVideoPlayer(),
//
//         // BasicOverlayWidget(controller: widget.controller),
//
//       ],
//     );
//   });
//
//   Widget buildVideoPlayer() => buildFullScreen(
//         child: AspectRatio(
//           aspectRatio: widget.controller.value.aspectRatio,
//           child: VideoPlayer(widget.controller),
//         ),
//       );
//
//   Widget buildFullScreen({
//     required Widget child,
//   }) {
//     final size = widget.controller.value.size;
//     final width = size.width;
//     final height = size.height;
//
//     return FittedBox(
//       fit: BoxFit.cover,
//       child: SizedBox(width: width, height: height, child: child),
//     );
//   }
// }
