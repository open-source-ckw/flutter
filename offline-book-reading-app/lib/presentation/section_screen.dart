import 'package:book_reader_app/core/responsive.dart';
import 'package:book_reader_app/models/new_model.dart';
import 'package:book_reader_app/presentation/topic_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import '../core/colors.dart';
import '../provider/image_slider_provider.dart';
import 'custom/app_drawer.dart';

class SectionScreen extends StatefulWidget {
  final Isar isar;
  const SectionScreen({super.key, required this.isar});

  static const route = '/Section_screen';

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ImageProviderData>(context, listen: false).loadImages());
  }



  @override
  Widget build(BuildContext context) {
    final images = context.watch<ImageProviderData>().images;

    if (images.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      drawer: AppDrawer(isar: widget.isar,),
      appBar: AppBar(
          title: const Text("देवपूजा - Dev Pooja", style: TextStyle(fontWeight: FontWeight.w700),),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, lighterSecondary],
            transform: const GradientRotation(10),

          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Slider Images
              CarouselSlider(
                options: CarouselOptions(
                  height: screenHeight(context) * 0.35,
                  viewportFraction: 1.0,
                    autoPlay: true,        // Auto slide
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  ),
                items: images.map((path) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      path,
                      fit: ( _currentIndex == 0 || _currentIndex == 3 ) ? BoxFit.fill : BoxFit.contain, // keeps full height without stretch
                    ),
                  );
                }).toList(),
              ),
              const HeightGap(gap: 0.005),
              // ✅ Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.asMap().entries.map((entry) {
                  bool isActive = _currentIndex == entry.key;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: isActive ? 10 : 7,
                    width: isActive ? 10 : 7,
                    decoration: BoxDecoration(
                      color: isActive ? primaryColor : appGrey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
              ),
              const HeightGap(gap: 0.01),
              FutureBuilder<List<Section>>(
                future: widget.isar.sections.where().findAll(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final sections = snapshot.data!;

                  return GridView.builder(
                    shrinkWrap: true, // ✅ Makes GridView fit content
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.68,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            TurnPageRoute(
                              overleafColor: appWhite,
                              transitionDuration: const Duration(milliseconds: 700),
                              builder: (context) => TopicsScreen(isar: widget.isar, sectionSubTitle: section.sSubTitle, sectionId : section.sId),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          margin: EdgeInsets.only(
                            right: index.isEven ? 5.0 : 0.0,
                            left: index.isOdd ? 5.0 : 0.0,
                            bottom: 5.0,
                            top: index >= 2 ? 5.0 : 0.0, // add spacing like your original
                          ),
                          decoration: BoxDecoration(
                            // border: Border.all(color: primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              colors: [secondaryColor, lighterSecondary],
                              transform: const GradientRotation(45),
                              tileMode: TileMode.mirror,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.5),
                                blurRadius: 3,
                                spreadRadius: 2,
                                offset: const Offset(1, 2)
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             Container(
                                  height: 145.0,
                                  width: 145.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100.0),
                                      border: Border.all(color: appWhite.withOpacity(0.5), width: 5)
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    height: 115.0,
                                    width: 115.0,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: BoxDecoration(
                                      color: appWhite.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(100.0),
                                      border: Border.all(color: primaryColor.withOpacity(0.7), width: 3),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadiusGeometry.circular(100.0),
                                        child: Image.asset(section.sImage, height: 85, width: 85, fit: BoxFit.contain)),
                                  ),
                                ),
                              const HeightGap(gap: 0.005),
                              Text(
                                section.sTitle,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                height: 45,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  section.sSubTitle,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: primaryColor,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
