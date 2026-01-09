import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/introduction_controller.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({Key? key}) : super(key: key);
  static const route = '/introduction_view';

  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> with TickerProviderStateMixin {
  final introductionController = Get.put(IntroductionController());
  final PageController _pageController = PageController(initialPage: 0);
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller!);

    _controller?.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appInto(),
      bottomNavigationBar: Builder(builder: (context) {
        return Obx(() => ElevatedButton(
            onPressed: () {
              if (introductionController.currentPage.toInt() == introductionController.imageArr.length - 1) {
                introductionController.navigateLoginPage();
              } else {
                goToNextPage();
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              backgroundColor: Colors.white,
              minimumSize: Size(MediaQuery.of(context).size.width, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Text((introductionController.currentPage.toInt() == introductionController.imageArr.length - 1) ? 'Get Started' : 'Next', style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
            ),
        ),
        );
      }),
    );
  }

  Widget appInto() {
    return Obx(() => Stack(children: <Widget>[
      FadeTransition(
        opacity: _animation!,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(introductionController.imageArr[introductionController.currentPage.toInt()]),
                  fit: BoxFit.cover
              ),
            ),
          ),
        ),
      ),
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0, 1.6, 1.1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
              Colors.black54,
            ],
          ),
        ),
      ),
      PageView(
        dragStartBehavior: DragStartBehavior.down,
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int page) {
          introductionController.currentPage.value = page;
          _controller?.reset();
          _controller?.forward();
        },
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FadeTransition(
              opacity: _animation!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    introductionController.title[introductionController.currentPage.toInt()],
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'CM Sans Serif',
                      fontSize: 26.0,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20,),
                  Wrap(
                    children: _buildPageIndicator(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FadeTransition(
              opacity: _animation!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    introductionController.title[introductionController.currentPage.toInt()],
                    maxLines: null,
                    softWrap: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'CM Sans Serif',
                      fontSize: 26.0,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20,),
                  Wrap(
                    children: _buildPageIndicator(),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FadeTransition(
              opacity: _animation!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(introductionController.title[introductionController.currentPage.toInt()],
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'CM Sans Serif',
                      fontSize: 26.0,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20,),
                  Wrap(
                    children: _buildPageIndicator(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ]));
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < introductionController.imageArr.length; i++) {
      list.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 3.0),
        height: 6,
        width: 28,
        decoration: BoxDecoration(
          color: introductionController.currentPage.toInt() == i ? Colors.white : Colors.white30,
          borderRadius: BorderRadius.circular(3),
        ),
      ),);
    }
    return list;
  }

  goToNextPage() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }
}

