import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeightTrackingScreen extends StatefulWidget {
  const WeightTrackingScreen({Key? key}) : super(key: key);

  static const String route = 'WeightTracker';

  @override
  State<WeightTrackingScreen> createState() => _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends State<WeightTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Weight Tracking'),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'Add',
              ))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 7.0, right: 7.0),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
              getWeightContainer(DateTime.now(), 25, 'kg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget getWeightContainer(DateTime dateTime, double weight, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 60.0,
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.pink.shade50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Today'), Text('52.7 KG')],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('7:02'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('+0.1 kg'),
                    Icon(Icons.arrow_circle_up_outlined)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
