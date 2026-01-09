import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'controller/photo_gallery_controller.dart';

class PhotoGalleryView extends StatefulWidget {
  List<dynamic> imgList;
  dynamic initialIndex;

  PhotoGalleryView({
    Key? key,
    required this.imgList,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<PhotoGalleryView> createState() => _PhotoGalleryViewState();
}

class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  final photoGalleryController = Get.put(PhotoGalleryController());

  @override
  void initState() {
    super.initState();
    photoGalleryController.currentIndex.value = widget.initialIndex;
    photoGalleryController.pageController =
        PageController(initialPage: photoGalleryController.currentIndex.value);
  }

  @override
  Widget build(BuildContext context) {
    var deviceOrientation = MediaQuery.of(context).orientation;
    return Stack(
      //alignment: Alignment.bottomRight,
      children: <Widget>[
        PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.imgList[index]),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              //minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 1.1,
              heroAttributes: const PhotoViewHeroAttributes(tag: 'idd'),
            );
          },
          itemCount: widget.imgList.length,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          pageController: photoGalleryController.pageController,
          onPageChanged: (int index) {
            photoGalleryController.currentIndex.value = index;
            photoGalleryController.controller.animateToPage(index);
          },
        ),
        Positioned(
          top: kToolbarHeight,
          left: 10.0,
          child: SizedBox(
            height: 40,
            width: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Close',
              child: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
            ),
          ),
        ),
        (deviceOrientation == Orientation.portrait)
            ? Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: _buildImageCarousel(),
              )
            : Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: MediaQuery.of(context).size.width / 8,
                  margin: const EdgeInsets.only(right: 50),
                  child: _buildImageCarousel(),
                ),
              )
      ],
    );
  }

  Widget _buildImageCarousel() {
    var deviceOrientation = MediaQuery.of(context).orientation;
    return CarouselSlider.builder(
      options: CarouselOptions(
          scrollDirection: deviceOrientation == Orientation.portrait
              ? Axis.horizontal
              : Axis.vertical,
          height: deviceOrientation == Orientation.portrait ? 100.0 : 900,
          enlargeCenterPage: true,
          viewportFraction: 0.21,
          enableInfiniteScroll: false,
          initialPage: photoGalleryController.currentIndex.value,
          onPageChanged: (index, reason) {
            photoGalleryController.pageController?.jumpToPage(index);
          }),
      carouselController: photoGalleryController.controller,
      itemCount: widget.imgList.length,
      itemBuilder: (BuildContext context, int index, int data) {
        return PortfolioGalleryImageWidget(
          imagePath: widget.imgList[index],
          onImageTap: () {
            photoGalleryController.pageController?.jumpToPage(index);
            photoGalleryController.controller.animateToPage(index);
          },
        );
      },
    );
  }
}

class PortfolioGalleryImageWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onImageTap;

  const PortfolioGalleryImageWidget(
      {Key? key, required this.imagePath, required this.onImageTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceOrientation = MediaQuery.of(context).orientation;
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(2, 2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: NetworkImage(imagePath),
            fit: deviceOrientation == Orientation.portrait
                ? BoxFit.cover
                : deviceOrientation == Orientation.landscape
                    ? BoxFit.cover
                    : BoxFit.fitHeight,
            child: InkWell(onTap: onImageTap),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FullScreenImage extends StatefulWidget {
  FullScreenImage(this.imgList, this.initialIndex, {Key? key})
      : super(key: key);
  List<dynamic> imgList;
  dynamic initialIndex;

  @override
  _FullScreenImageState createState() =>
      // ignore: no_logic_in_create_state
      _FullScreenImageState(imgList, initialIndex);
}

class _FullScreenImageState extends State<FullScreenImage> {
  List<dynamic> imgList;
  dynamic initialIndex;

  _FullScreenImageState(this.imgList, this.initialIndex);

  int initFullViewPhoto = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    var deviceOrientation = MediaQuery.of(context).orientation;
    return Stack(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1.0,
            height: 600,
            initialPage: initFullViewPhoto,
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal,
            autoPlayCurve: Curves.fastLinearToSlowEaseIn,
            onPageChanged: (index, reason) {
              initFullViewPhoto = index;
            },
          ),
          carouselController: _controller,
          items: imgList.map((item) {
            return PhotoView(
              imageProvider: NetworkImage(
                item,
              ),
              maxScale: PhotoViewComputedScale.contained * 2,
              minScale: PhotoViewComputedScale.contained,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
              heroAttributes: PhotoViewHeroAttributes(tag: initialIndex),
            );
          }).toList(),
        ),
        (deviceOrientation == Orientation.portrait)
            ? Positioned(
                bottom: 0,
                child: SizedBox(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    itemCount: imgList.length,
                    itemBuilder: (context, int index) {
                      return Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _controller.animateToPage(index);
                            },
                            child: Image.network(imgList[index]),
                          ),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                      );
                    },
                  ),
                ),
              )
            : Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  margin: const EdgeInsets.only(right: 75),
                  width: 90,
                  alignment: Alignment.topLeft,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    scrollDirection: Axis.vertical,
                    itemCount: imgList.length,
                    itemBuilder: (context, int index) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _controller.animateToPage(index);
                              },
                              child: Image.network(
                                imgList[index],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
        Positioned(
          top: kToolbarHeight,
          left: 20,
          child: SizedBox(
            height: 40,
            width: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Back',
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
