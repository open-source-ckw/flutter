import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicProviderScreen extends StatefulWidget {
  const MusicProviderScreen({Key? key}) : super(key: key);

  static const String route = 'MusicProvider';

  @override
  State<MusicProviderScreen> createState() => _MusicProviderScreenState();
}

class _MusicProviderScreenState extends State<MusicProviderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade50,
        elevation: 0.0,
        title: Text('Music Provider'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 7.0, right: 7.0),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(
                        child: Text(
                      'Select your Music Provider',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      'Listen to your favorite music while exercises. The best music streaming services include access to millions of songs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0),
                    ))
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 7.0, right: 7.0, top: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  padding: EdgeInsets.only(left: 7.0, right: 7.0),
                  child: Column(
                    children: [
                      getMusicAppContainer('Spotify', () {}),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(),
                      ),
                      getMusicAppContainer('Apple Music', () {}),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getMusicAppContainer(String name, dynamic onTap) {
    return ListTile(
      title: Row(
        children: [Expanded(child: Text(name))],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 15.0,
      ),
    );
  }
}
