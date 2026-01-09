// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Screens/CategoriesInfoList.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/Storage/StorageHandler.dart';
import '../Util/CategoryEntity.dart';
import '../Util/Constants.dart';

class CategoryCarosal extends StatefulWidget {
  List<Categories> data;

  CategoryCarosal({Key? key, required this.data}) : super(key: key);

  @override
  State<CategoryCarosal> createState() => _CategoryCarosalState();
}

class _CategoryCarosalState extends State<CategoryCarosal> {
  Reference storageRef = FirebaseStorage.instance.ref();
  StorageHandler storageHandler = StorageHandler();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          Categories categoryEntity = widget.data[index];
          var img =
              storageHandler.getImageUrl(categoryEntity.cs_image.toString());
          return Card(
            elevation: 0.0,
            // color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CategoriesInfoList(category: categoryEntity)));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 80.0,
                    padding: EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 2.0),
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.11),
                        // border: Border.all(
                        //     color: Colors.grey.withAlpha(200), width: 0.9),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //.child("folderName/file.jpg")
                        // FutureBuilder(
                        //   future: storageHandler.getImageUrl(categoryEntity.cs_image),
                        //   builder:
                        //       (BuildContext context, AsyncSnapshot<String> snapshot) {
                        //     return Container(
                        //       width: 20.0,
                        //       height: 20.0,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         image: DecorationImage(
                        //           image: CachedNetworkImageProvider(
                        //             snapshot.data.toString(),
                        //           ),
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   initialData:
                        //   'https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc',
                        // ),
                        FutureBuilder(
                          future: storageHandler
                              .getImageUrl(categoryEntity.cs_image.toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data!,
                              fit: BoxFit.cover,
                              width: 20,
                              height: 20,
                            );
                          },
                          initialData: Constants.loaderUrl,
                        ),
                        Expanded(
                          child: Text(
                            categoryEntity.cs_name,
                            style: TextStyle(
                                // color: Colors.black,
                                fontSize: 12.0,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }
}
