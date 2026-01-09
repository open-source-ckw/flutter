import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/Storage/StorageHandler.dart';

import '../Screens/ExerciseInfoScreen.dart';
import '../Util/Constants.dart';
import '../Util/ExerciseEntity.dart';

class ExerciseList extends StatelessWidget {
  List<Exercises> exercises = [];
  StorageHandler storageHandler = StorageHandler();

  ExerciseList({Key? key, required this.exercises}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: childItem(context),
        ));
  }

  childItem(context) {
    List<Widget> listofItem = [];

    for (var i = 0; i < exercises.length; i++) {
      var exerciseEntity = exercises[i];
      listofItem.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          tileColor: Theme.of(context).disabledColor.withOpacity(0.11),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ExerciseInfoScreen(exercise: exerciseEntity)));
          },
          // minVerticalPadding: 15.0,
          // tileColor: Colors.white,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FutureBuilder(
              future: storageHandler.getImageUrl(exerciseEntity.es_image),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return FancyShimmerImage(
                  shimmerBaseColor: Colors.blue.shade200,
                  shimmerHighlightColor: Colors.grey[300],
                  shimmerBackColor: Colors.black.withBlue(1),
                  imageUrl: snapshot.data != null && snapshot.data != ''
                      ? snapshot.data!
                      : Constants.loaderUrl,
                  boxFit: BoxFit.cover,
                  errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                  width: 80,
                  height: 50,
                );
              },
              initialData: Constants.loaderUrl,
            ),
          ),
          trailing: const Icon(Icons.info_outline),
          title: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  exerciseEntity.es_name,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                    "${exerciseEntity.es_duration} ${exerciseEntity.es_durationin}"),
                // Text(exerciseEntity.durationin)
              ],
            ),
          ),
        ),
      ));
    }

    return listofItem;
  }
}
