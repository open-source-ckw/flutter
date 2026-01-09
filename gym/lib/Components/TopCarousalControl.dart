// ignore_for_file: prefer_const_constructors

import '../Colors.dart';
import 'package:provider/provider.dart';

import '../Provider/ThemeProvider.dart';
import '../Util/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../firebase/DB/Models/Banner.dart';
import '../firebase/DB/Models/Toning_Exercises.dart';
import '../firebase/Storage/StorageHandler.dart';

import '../Screens/BannerWorkoutsScreen.dart';

class TopCarousalControl extends StatefulWidget {
  List<TonningWorkoutsModel> toningWorkout;

  TopCarousalControl({Key? key, required this.toningWorkout}) : super(key: key);

  @override
  State<TopCarousalControl> createState() => _TopCarousalControlState();
}

class _TopCarousalControlState extends State<TopCarousalControl> {
  StorageHandler storageHandler = StorageHandler();

  ToningExercises? toningExercises;

  // late ThemeProvider themeProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    // themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // final themeProvider = Provider.of<DarkThemeProvider>(context);

    return CarouselSlider(
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.2,
          enlargeCenterPage: true,
          viewportFraction: 1.0),
      items: widget.toningWorkout.map((tonningWorkoutModel) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BannerWorkoutsScreen(
                          tonningWorkoutsModel: tonningWorkoutModel,
                        )));
          },
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.11),

                // image: DecorationImage(image: AssetImage('assets/images/toningBgImage.jpg'),fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                tonningWorkoutModel.tWs_name,
                                style: TextStyle(
                                    // color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0),
                              ))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text(
                                tonningWorkoutModel.tWs_description,
                                style: TextStyle(
                                    // color: Colors.black,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1.0),
                              ))
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 15.0),
                      //     child: InkWell(
                      //       onTap: () {
                      //          // Navigator.push(context, MaterialPageRoute(builder: (context) => BannerWorkoutsScreen(tonningWorkoutsModel: tonningWorkoutModel,)));
                      //       },
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height*0.025,
                      //         width: MediaQuery.of(context).size.width*0.45,
                      //         decoration: BoxDecoration(
                      //             color: Colors.lightBlue[900],
                      //             border: Border.all(),
                      //             borderRadius: BorderRadius.circular(40.0)),
                      //         child: const Text(
                      //           'Continue',
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 10.0,
                      //               letterSpacing: 1.0,
                      //               fontWeight: FontWeight.bold),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       ),
                      //     )),
                    ],
                  ),
                ),
                //
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: FutureBuilder(
                      future: storageHandler
                          .getImageUrl(tonningWorkoutModel.tWs_image),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return CachedNetworkImage(
                            // useOldImageOnUrlChange: true,
                            imageUrl: snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return Center(
                              child: Image.network(Constants.loaderUrl));
                        }
                        // return CachedNetworkImage(
                        //   imageUrl: snapshot.data!,
                        //   fit: BoxFit.cover,
                        // );
                        return CircularProgressIndicator();
                      },
                      initialData: Constants.loaderUrl,
                    ),
                  ),

                  // FutureBuilder(
                  //   future: storageHandler.getImageUrl(tonningWorkoutModel.tWs_image),
                  //   builder:
                  //       (BuildContext context, AsyncSnapshot<String> snapshot) {
                  //     return Container(
                  //       // width: 80.0,
                  //         height: MediaQuery.of(context).size.height * 0.20,
                  //
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
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
