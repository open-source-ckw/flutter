import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHomeGrid extends StatelessWidget {
  const ShimmerHomeGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        //enabled: homeController.listNewProductData.isEmpty,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, __) =>
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.3,
                child: Stack(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ), itemCount: 5,),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (_, __) =>
            Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    //color: Colors.white,
                  ),
                ),
              ],
            ), itemCount: 10,),
    );
  }
}

class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        scrollDirection: Axis.vertical,
        itemBuilder: (_, __) =>
            Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(),
                ),
              ],
            ), itemCount: 10,),
    );
  }
}

class ShimmerSingleList extends StatelessWidget {
  const ShimmerSingleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              height: 110,
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerSingleGrid extends StatelessWidget {
  const ShimmerSingleGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerProductDetails extends StatelessWidget {
  const ShimmerProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Container(
                  height: 400,
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Card(
                        child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.greenAccent[400],
                      radius: 22,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ShimmerHomeGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
