import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../firebase/DB/Models/Equipments.dart';
import '../firebase/Storage/StorageHandler.dart';
import '../Screens/AllCategories.dart';
import '../Util/Equipment.dart';

class EquipmentCarousel extends StatelessWidget {
  List<Equipments> equipments;

  EquipmentCarousel({Key? key, required this.equipments}) : super(key: key);
  StorageHandler storageHandler = StorageHandler();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.0,
      alignment: Alignment.center,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: equipments.length,
        itemBuilder: (context, index) {
          Equipments equipment = equipments[index];
          return Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.shade50,
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(4, 4)),
                  BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(-4, -4)),
                ]),
            padding: const EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
            child: InkWell(
              onTap: () {},
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child: FutureBuilder(
                      future: storageHandler.getImageUrl(equipment.eq_image),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data!,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 50,
                        );
                      },
                      initialData:
                          'https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc',
                    ),
                  ),
                  Text(getCamelCaseWord(equipment.eq_name))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String getCamelCaseWord(String input) {
    String output = '';
    output = input.characters.first.toString().toUpperCase();
    output = output + input.substring(1);
    return output;
  }
}
