import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/TrainingInfoScreen.dart';
import '../firebase/DB/Models/Trainings.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Repo/TrainingRepository.dart';
import '../firebase/DB/Repo/User_FavRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../Util/Constants.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../local/localization/language_constants.dart';

class TrainingScreen extends StatefulWidget {
  List<Trainings> trainings = [];

  TrainingScreen({Key? key, required this.trainings}) : super(key: key);

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  StorageHandler storageHandler = StorageHandler();

  List selectedTraining = [];

  // List<Trainings> trainings = [];

  TrainingsRepository trainingsRepository = TrainingsRepository();
  UserRepository userRepository = UserRepository();
  User_FavRepository user_favRepository = User_FavRepository();

  UserMaster? userMaster;

  bool isFavorite = false;

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    // print(user);
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
      context.loaderOverlay.hide();
      setState(() {});
    }
  }

  Future<void> loadFavorite() async {
    await loadUser();
    int index = 0;
    List tempFavs = await user_favRepository.getAllFavoriteByRefId(
        spId: widget.trainings.elementAt(index).TS_ID,
        userId: userMaster!.UM_ID);
    if (tempFavs.isNotEmpty) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  List categoryTraining = ['All', 'Beginner', 'Advance', 'Irregular Training'];

  Future<void> loadTraining() async {
    widget.trainings.clear();
    List<Trainings> tempTraining = await trainingsRepository.getAllTrainings();
    List<String> allTrainingLevels = [];
    for (int i = 0; i < tempTraining.length; i++) {
      Trainings t = tempTraining.elementAt(i);
      // String csId = t.ws_level.toLowerCase();
      // Categories eCat = await categoryRepository.getCategoryFromId(uid: csId);
      //
      // String catType = eCat.cs_name.toString().trim().toLowerCase();
      allTrainingLevels.add(t.ts_level);
    }
    tempTraining.map((e) {}).toList();
    // List<String> newFilters = filters;
    // newFilters.removeAt(0);
    if (selectedTraining.isEmpty || selectedTraining.contains(0)) {
      widget.trainings = tempTraining;
    } else {
      for (var selectedLevel in selectedTraining) {
        for (int i = 0; i < allTrainingLevels.length; i++) {
          String trainingLevels = allTrainingLevels[i];

          if (trainingLevels.toLowerCase() ==
              categoryTraining.elementAt(selectedLevel).toLowerCase()) {
            Trainings tempTrainings = tempTraining.elementAt(i);

            if (!widget.trainings.contains(tempTrainings)) {
              widget.trainings.add(tempTrainings);
            }
          }
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    loadTraining();

    ///loadFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.blue.shade50.withOpacity(0.9),
      useDefaultLoading: false,
      closeOnBackButton: false,
      overlayWholeScreen: true,
      overlayWidget: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/loader3-unscreen.gif'))),
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Text(
            '${getTranslated(context, 'training')}s',
            textAlign: TextAlign.left,
            style: TextStyle(
                // fontSize: 36,
                color: Theme.of(context).textTheme.headline5!.color),
          ),
        ),
        // backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right: 7.0, bottom: 20.0, top: 10),
                    child: Row(
                      children: [
                        Container(
                          // color: Colors.white,
                          height: 35.0,
                          width: MediaQuery.of(context).size.width - 15.0,
                          child: ListView.builder(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 7.0, right: 7.0),
                                child: InkWell(
                                  onTap: () async {
                                    if (selectedTraining.contains(index)) {
                                      selectedTraining.remove(index);
                                    } else {
                                      selectedTraining.add(index);
                                    }
                                    await loadTraining();
                                    // await l();
                                  },
                                  child: Container(
                                      height: 5.0,
                                      width: 85.0,
                                      padding: const EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                        color: selectedTraining.contains(index)
                                            ? Colors.blue.shade900
                                            : Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.14),
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        border: Border.all(
                                            width: 1, color: Colors.grey),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        categoryTraining[index],
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color:
                                              selectedTraining.contains(index)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(0.6),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                ),
                              );
                            },
                            itemCount: categoryTraining.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.79,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0.0,
                            childAspectRatio: 0.9),
                    itemBuilder: (context, index) {
                      Trainings training = widget.trainings.elementAt(index);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TrainingInfoScreen(trainings: training)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 7.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  // FutureBuilder(
                                  //   future: storageHandler
                                  //       .getImageUrl(training.ts_image),
                                  //   builder: (BuildContext context,
                                  //       AsyncSnapshot<String> snapshot) {
                                  //     return Container(
                                  //       width:
                                  //           MediaQuery.of(context).size.width *
                                  //               0.5,
                                  //       height:
                                  //           MediaQuery.of(context).size.height *
                                  //               0.15,
                                  //       decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(10),
                                  //         image: DecorationImage(
                                  //           image: CachedNetworkImageProvider(
                                  //             snapshot.data != null &&
                                  //                     snapshot.data != ''
                                  //                 ? snapshot.data!
                                  //                 : loaderUrl2,
                                  //           ),
                                  //           fit: BoxFit.cover,
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  //   initialData:
                                  //       'https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc',
                                  // ),

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      child: FutureBuilder(
                                        future: storageHandler
                                            .getImageUrl(training.ts_image),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          return FancyShimmerImage(
                                              shimmerBaseColor:
                                                  Colors.blue.shade100,
                                              shimmerHighlightColor:
                                                  Colors.grey[300],
                                              shimmerBackColor:
                                                  Colors.black.withBlue(1),
                                              imageUrl: snapshot.data != null &&
                                                      snapshot.data != ''
                                                  ? snapshot.data!
                                                  : Constants.loaderUrl,
                                              boxFit: BoxFit.cover,
                                            errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                                          );
                                        },
                                        initialData: Constants.loaderUrl,
                                      ),
                                    ),
                                  ),

                                  /*Positioned(
                                      top: -2.0,
                                      right: -2.0,
                                      child: IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: Colors.red,
                                          size: 25.0,
                                        ),
                                        onPressed: () async {
                                          context.loaderOverlay.show();

                                          if (isFavorite) {
                                            List<User_Fav> userFav =
                                                await user_favRepository
                                                    .getAllFavoriteByRefId(
                                                        spId: training.TS_ID,
                                                        userId:
                                                            userMaster!.UM_ID);
                                            final result =
                                                await user_favRepository.delete(
                                                    favId:
                                                        userFav.first.FAV_ID);
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(result
                                                        ? 'Fav Removed'
                                                        : 'Error')));
                                          } else {
                                            User? user = FirebaseAuth
                                                .instance.currentUser;
                                            User_Fav userFav = User_Fav(
                                                FAV_ID: '',
                                                UM_ID: user!.uid,
                                                REF_ID: training.TS_ID,
                                                REF_Type: 'training');
                                            await user_favRepository.save(
                                                user_Fav: userFav);
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Colors.green.shade500,
                                                    content: Text('Success')));
                                          }
                                          setState(() {
                                            isFavorite = !isFavorite;
                                          });
                                          if (context.loaderOverlay.visible) {
                                            context.loaderOverlay.hide();
                                          }
                                        },
                                      )),*/
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0),
                                child: Text(
                                  training.ts_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    training.ts_level,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.6),
                                        // color: Colors.blue.shade900,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0),
                                  )),
                                  Text(
                                    '${training.ts_duration} ${training.ts_durationin}',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.6),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: widget.trainings.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*  void showFilters(context) {
    showBottomSheet(
        elevation: 100,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        backgroundColor: Colors.white,
        // barrierColor: Colors.blue.withOpacity(0.1),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Filters',
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                          )),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel_outlined),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Category',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.w500)),
                          ))
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          runSpacing: 10.0,
                          children: [
                            getFilterContainer(
                                text: 'Stretch', onTap: () {}, isSelected: true),
                            getFilterContainer(
                                text: 'Legs', onTap: () {}, isSelected: false),
                            getFilterContainer(
                                text: 'Arms', onTap: () {}, isSelected: false),
                            getFilterContainer(
                                text: 'Yoga', onTap: () {}, isSelected: true),
                            getFilterContainer(
                                text: 'Boxing', onTap: () {}, isSelected: false),
                            getFilterContainer(
                                text: 'Running', onTap: () {}, isSelected: false),
                            getFilterContainer(
                                text: 'Personal', onTap: () {}, isSelected: true),
                          ],
                        ),
                      ),
                      Row(
                        children: const [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Price',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.w500)),
                          ))
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            getFilterContainer(
                                text: 'Free', onTap: () {}, isSelected: true),
                            getFilterContainer(
                                text: 'Premium', onTap: () {}, isSelected: false),
                          ],
                        ),
                      ),
                      Row(
                        children: const [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Level',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.w500)),
                          ))
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            getFilterContainer(
                                text: 'Beginner', onTap: () {}, isSelected: true),
                            getFilterContainer(
                                text: 'Medium', onTap: () {}, isSelected: false),
                            getFilterContainer(
                                text: 'Advanced', onTap: () {}, isSelected: false),
                          ],
                        ),
                      ),
                      Row(
                        children: const [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Duration',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.w500)),
                          ))
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            getFilterContainer(
                                text: '15-20 min', onTap: () {}, isSelected: true),
                            getFilterContainer(
                                text: '20-30 min', onTap: () {}, isSelected: false),
                            getFilterContainer(
                                text: '30-40 min', onTap: () {}, isSelected: false),
                          ],
                        ),
                      ),
                      Row(
                        children: const [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Equipment',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.w500)),
                          ))
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            getFilterContainer(
                                text: 'Kettlebell', onTap: () {}, isSelected: true),
                            getFilterContainer(
                                text: 'Kettlebell',
                                onTap: () {},
                                isSelected: false),
                            getFilterContainer(
                                text: 'Kettlebell',
                                onTap: () {},
                                isSelected: false),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getSubmitButtons(
                              context: context,
                              text: 'Reset',
                              onTap: () {},
                              isSelected: false),
                          getSubmitButtons(
                              context: context,
                              text: 'Apply',
                              onTap: () {},
                              isSelected: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });

    // showModalBottomSheet(
    //   barrierColor: Colors.blue.withOpacity(0.1),
    //     shape:  RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(25),
    //         topRight: Radius.circular(25),
    //       )
    //     ),
    //     context: context,
    //     builder: (context) {
    //       return SizedBox(
    //         height: MediaQuery.of(context).size.height * 9,
    //         child: SingleChildScrollView(
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
    //             child: Column(
    //               children: [
    //
    //                 Row(
    //                   children: [
    //                     Expanded(child: Padding(
    //                       padding: const EdgeInsets.all(10.0),
    //                       child: Text('Filters',style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),
    //                     )),
    //                     IconButton(
    //                       onPressed: () {
    //                         Navigator.pop(context);
    //                       },
    //                       icon: Icon(Icons.cancel_outlined),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(child: Padding(
    //                       padding: const EdgeInsets.all(10.0),
    //                       child: Text('Category',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500)),
    //                     ))
    //                   ],
    //                 ),
    //                 Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Wrap(
    //
    //                     runSpacing: 10.0,
    //                     children: [
    //                       getFilterContainer(text: 'Stretch', onTap: (){},isSelected: true),
    //                       getFilterContainer(text: 'Legs', onTap: (){},isSelected: false),
    //                       getFilterContainer(text: 'Arms', onTap: (){},isSelected: false),
    //                       getFilterContainer(text: 'Yoga', onTap: (){},isSelected: true),
    //                       getFilterContainer(text: 'Boxing', onTap: (){},isSelected: false),
    //                       getFilterContainer(text: 'Running', onTap: (){},isSelected: false),
    //                       getFilterContainer(text: 'Personal', onTap: (){},isSelected: true),
    //
    //                     ],
    //                   ),
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(child: Padding(
    //                       padding: const EdgeInsets.all(10.0),
    //                       child: Text('Price',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500)),
    //                     ))
    //                   ],
    //                 ),
    //                 Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Wrap(
    //                     children: [
    //                       getFilterContainer(text: 'Free', onTap: (){},isSelected: true),
    //                       getFilterContainer(text: 'Premium', onTap: (){},isSelected: false),
    //                     ],
    //                   ),
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(child: Padding(
    //                       padding: const EdgeInsets.all(10.0),
    //                       child: Text('Level',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500)),
    //                     ))
    //                   ],
    //                 ),
    //                 Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Wrap(
    //                     children: [
    //                       getFilterContainer(text: 'Beginner', onTap: (){},isSelected: true),
    //                       getFilterContainer(text: 'Medium', onTap: (){},isSelected: false),
    //                       getFilterContainer(text: 'Advanced', onTap: (){},isSelected: false),
    //                     ],
    //                   ),
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(child: Padding(
    //                       padding: const EdgeInsets.all(10.0),
    //                       child: Text('Duration',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500)),
    //                     ))
    //                   ],
    //                 ),
    //                 Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Wrap(
    //                     children: [
    //                       getFilterContainer(text: '15-20 min', onTap: (){},isSelected: true),
    //                       getFilterContainer(text: '20-30 min', onTap: (){},isSelected: false),
    //                       getFilterContainer(text: '30-40 min', onTap: (){},isSelected: false),
    //                     ],
    //                   ),
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(child: Padding(
    //                       padding: const EdgeInsets.all(10.0),
    //                       child: Text('Equipment',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500)),
    //                     ))
    //                   ],
    //                 ),
    //                 Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Wrap(
    //                     children: [
    //                       getFilterContainer(text: 'Kettlebell', onTap: (){},isSelected: true),
    //                       getFilterContainer(text: 'Kettlebell', onTap: (){},isSelected: false),
    //                       getFilterContainer(text: 'Kettlebell', onTap: (){},isSelected: false),
    //                     ],
    //                   ),
    //                 ),
    //
    //                 SizedBox(height: 10,),
    //
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     getSubmitButtons(context: context,text: 'Reset', onTap: (){},isSelected: false),
    //                     getSubmitButtons(context: context,text: 'Apply', onTap: (){},isSelected: true),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }*/

  Widget getFilterContainer(
      {required String text, required dynamic onTap, bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(20.0),
            color: isSelected ? Colors.blue.shade900 : Colors.white),
        child: TextButton(
          onPressed: () {
            onTap();
          },
          child: Text(
            text,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.blue.shade900),
          ),
        ),
      ),
    );
  }

  Widget getSubmitButtons(
      {required context,
      required String text,
      required dynamic onTap,
      bool isSelected = false}) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 10.0),
      child: Container(
        height: 42.0,
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(20.0),
            color: isSelected ? Colors.blue.shade900 : Colors.white),
        child: TextButton(
          onPressed: () {
            onTap();
          },
          child: Text(
            text,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.blue.shade900),
          ),
        ),
      ),
    );
  }
}
