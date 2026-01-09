import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:flutter/material.dart';
import '../Screens/WorkoutScreen.dart';

import '../firebase/DB/Models/Workouts.dart';

import '../firebase/Storage/StorageHandler.dart';

import '../Util/Constants.dart';

class PopularWorkouts extends StatefulWidget {
  // List<TopCarousalEntity> data;
  List<Workouts> workouts;

  PopularWorkouts({Key? key, required this.workouts}) : super(key: key);

  @override
  State<PopularWorkouts> createState() => _PopularWorkoutsState();
}

class _PopularWorkoutsState extends State<PopularWorkouts> {
  StorageHandler storageHandler = StorageHandler();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.26,
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: ListView.builder(
            // physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: widget.workouts.length,
            itemBuilder: (BuildContext context, int index) {
              Workouts workout = widget.workouts.elementAt(index);
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WorkoutScreen(workout: workout),
                      ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FutureBuilder(
                      //   future: storageHandler.getImageUrl(workout.ws_image),
                      //   builder:
                      //       (BuildContext context, AsyncSnapshot<String> snapshot) {
                      //     return Container(
                      //         height: MediaQuery.of(context).size.height * 0.17,
                      //         width: MediaQuery.of(context).size.width * 0.65,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         image: DecorationImage(
                      //           image: CachedNetworkImageProvider(
                      //               snapshot.data != null && snapshot.data != ''
                      //                             ? snapshot.data!
                      //                             : loaderUrl2,
                      //           ),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   initialData:
                      //   'https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc',
                      // ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FutureBuilder(
                            future:
                                storageHandler.getImageUrl(workout.ws_image),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              return FancyShimmerImage(
                                  shimmerBaseColor: Colors.blue.shade200,
                                  shimmerHighlightColor: Colors.grey[300],
                                  shimmerBackColor: Colors.black.withBlue(1),
                                  imageUrl: snapshot.data != null &&
                                          snapshot.data != ''
                                      ? snapshot.data!
                                      : Constants.loaderUrl,
                                  errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                                  boxFit: BoxFit.cover);
                            },
                            initialData: Constants.loaderUrl,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          workout.ws_name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            workout.ws_level,
                            style: TextStyle(
                                // color: Colors.blue.shade900,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0),
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(horizontal: 5),
                          //   width: 5,
                          //   height: 5,
                          //   decoration: BoxDecoration(
                          //       color: Colors.black, shape: BoxShape.circle),
                          // ),
                          // Text(
                          //   "${workout.ws_duration} ${workout.ws_durationin}",
                          //   style: TextStyle(
                          //       color: Colors.blue.shade900,
                          //       fontWeight: FontWeight.w400,
                          //       fontSize: 12.0),
                          // )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 190.0,
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: widget.workouts.length,
            itemBuilder: (context, index) {
              Workouts workout = widget.workouts.elementAt(index);

              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WorkoutScreen(workout: workout)));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 135,
                            width: MediaQuery.of(context).size.width * 0.65,
                            padding: EdgeInsets.all(25.0),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: SizedBox(
                              height: 140,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: FutureBuilder(
                                  future: storageHandler
                                      .getImageUrl(workout.ws_image),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    return CachedNetworkImage(
                                        imageUrl: snapshot.data != null &&
                                                snapshot.data != ''
                                            ? snapshot.data!
                                            : loaderUrl2,
                                        fit: BoxFit.cover);
                                  },
                                  initialData:
                                      'https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                              workout.ws_name,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5),
                            ))
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            workout.ws_level,
                            style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                          ),
                          Text(
                            "${workout.ws_duration} ${workout.ws_durationin}",
                            style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }*/
}
