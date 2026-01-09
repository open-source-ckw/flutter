import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Util/SummaryHeartRate.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  static const String route = "SummaryScreen";

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Summary'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(
                          child: Text(
                        'Workout',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ))
                    ],
                  ),
                  ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/1.jpg',
                          height: 100.0,
                          width: 100.0,
                        )),
                    title: Row(
                      children: [Expanded(child: Text('Bodyweight Stretch'))],
                    ),
                    subtitle: Row(
                      children: [Expanded(child: Text('08:30 - 09:15'))],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.pink.shade50,
                        height: 100.0,
                        width: (MediaQuery.of(context).size.width / 2) - 25.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('00:45:15'),
                            Text('Total time'),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.pink.shade50,
                        height: 100.0,
                        width: (MediaQuery.of(context).size.width / 2) - 25.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('164 bpm'),
                            Text('Average Heart Rate'),
                          ],
                        ),
                      )
                      /*
                      */
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.pink.shade50,
                          height: 100.0,
                          width: (MediaQuery.of(context).size.width / 2) - 25.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('617 Kcal'),
                              Text('Active Calories')
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.pink.shade50,
                          height: 100.0,
                          width: (MediaQuery.of(context).size.width / 2) - 25.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('640 Kcal'),
                              Text('Total Calories')
                            ],
                          ),
                        )
                        /*
                        */
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Column(
                      children: [
                        Row(
                          children: [Expanded(child: Text('Heart Rate'))],
                        ),
                        const SummaryHeartRate()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25.0,
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 30.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.lightBlue[900],
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(40.0)),
                    child: const Text(
                      'Save Workout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
