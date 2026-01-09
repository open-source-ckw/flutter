import 'package:book_reader_app/presentation/custom/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import '../core/colors.dart';
import '../core/responsive.dart';
import '../models/new_model.dart';
import 'book_page.dart';
import 'bottom_bar.dart';

class TopicsScreen extends StatefulWidget {
  final Isar isar;
  final String sectionSubTitle;
  final int sectionId;
  final bool fromDrawer;

  const TopicsScreen({super.key, required this.isar, required this.sectionSubTitle, required this.sectionId, this.fromDrawer = false});

  static const route = '/Topic_screen';

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  TextEditingController search = TextEditingController();

  String query = '';
  List<Topic> searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadAllTopics();
  }

  Future<List<Topic>> getTopicsBySection(Isar isar, int sectionId) async {
    return await isar.topics.filter().sIdEqualTo(sectionId).findAll();
  }


  Future<void> _loadAllTopics() async {
    final topics = await getTopicsBySection(widget.isar, widget.sectionId);
    setState(() {
      searchResults = topics;
    });
  }

  Future<void> _searchTopics(String input) async {
    if (input.isEmpty) {
      _loadAllTopics(); // reset full list when cleared
      return;
    }

    final results = await widget.isar.topics
        .filter()
        .tTranslateNameContains(input, caseSensitive: false)
        .findAll();

    setState(() {
      searchResults = results;
    });
  }

  /*
  Future<void> _searchTopics(String input) async {
  if (input.trim().isEmpty) {
    _loadAllTopics();
    return;
  }

  final results = await widget.isar.topics
      .filter()
      .group((q) => q
          .tTranslateNameContains(input, caseSensitive: false)
          .or()
          .tNameContains(input, caseSensitive: false))
      .findAll();

  setState(() {
    searchResults = results;
  });
}

   */

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromDrawer) {
          // ✅ If opened from splash, go to BottomBar
          Navigator.pushReplacement(
            context,
            TurnPageRoute(
                overleafColor: appWhite,
                transitionDuration: const Duration(milliseconds: 800),
                direction: TurnDirection.leftToRight,
                builder: (_) => BottomBar(isar: widget.isar)),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: AppDrawer(isar: widget.isar,),
        appBar: AppBar(
          title: Text(
            widget.sectionSubTitle,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,),
        ),
        body: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [secondaryColor, lighterSecondary],
              transform: const GradientRotation(180),

            ),
          ),
          child: Column(
            children: [
              // 🔍 Search Box
              TextFormField(
                controller: search,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Search from below list.",
                  hintStyle: const TextStyle(fontSize: 14),
                  filled: true,
                  fillColor: appWhite,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, size: 25,),
                    onPressed: () {
                      search.clear();
                      query = '';
                      _loadAllTopics();
                    },
                  )
                      : const Icon(Icons.search, size: 25,),
                ),
                onChanged: (value) {
                  query = value;
                  _searchTopics(query);
                },
              ),
              const HeightGap(gap: 0.01),

              // 📚 List of Topics
              Expanded(
                child: searchResults.isEmpty
                    ? Center(child: Text("No topics found", style: TextStyle(color: appBlack, fontSize: 18),))
                    : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final topic = searchResults[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          horizontalTitleGap: 10,
                          leading: CircleAvatar(
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontSize: 13,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            topic.tName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            topic.tTranslateName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              TurnPageRoute(
                                overleafColor: appWhite,
                                transitionDuration: const Duration(milliseconds: 700),
                                builder: (context) => TopicDetailScreen(
                                  isar: widget.isar,
                                  sName: widget.sectionSubTitle,
                                  sId: widget.sectionId,
                                  topicName: topic.tName,
                                  topicId: topic.tId,
                                  topicTName : topic.tTranslateName,
                                  topics: searchResults,
                                  currentIndex: index,
                                ),
                              ),
                            );

                          },
                        ),
                        if (index < searchResults.length - 1)
                          Divider(color: appGray600.withOpacity(0.6), thickness: 1.5,),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

