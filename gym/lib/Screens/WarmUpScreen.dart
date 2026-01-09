import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WarmUpScreen extends StatefulWidget {
  const WarmUpScreen({Key? key}) : super(key: key);

  static const String route = 'WarmUp';

  @override
  State<WarmUpScreen> createState() => _WarmUpScreenState();
}

class _WarmUpScreenState extends State<WarmUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('Warm-up'),
        elevation: 0.0,
        backgroundColor: Colors.blue.shade50,
        actions: [TextButton(onPressed: () {}, child: Text('Add'))],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onTap: () {
                    // Navigator.pushNamed(context, AllExercises.route);
                  },
                  minVerticalPadding: 15.0,
                  tileColor: Colors.white,
                  leading: Image.asset('assets/images/1.jpg'),
                  trailing: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Lunge',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('- 0:30 +')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TextButton(
        onPressed: () {},
        child: Text('Save'),
      ),
    );
  }
}
