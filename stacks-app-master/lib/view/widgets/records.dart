import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stacks/view/widgets/record_card.dart';
import 'package:stacks/view/widgets/record_card_text.dart';
import 'package:stacks/view/widgets/record_list.dart';
import 'package:stacks/view/widgets/record_list_text.dart';

class CardsListViewSliver extends StatelessWidget {
  const CardsListViewSliver({
    Key? key,
    required this.links,
  }) : super(key: key);

  final List links;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 10, right: 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if (links[index]['target_url'].contains('://')) {
            if (links[index]['image_url'] == null ||
                links[index]['image_url']?.contains("data:") ||
                links[index]['image_url']?.contains('http://')) {
              return RecordListText(
                id: links[index]['id'],
                title: links[index]['title'] != null ? links[index]['title'] : "-NA-",
                //date: DateTime.utc(2021, DateTime.february, 22),
                //rating: new Random().nextInt(4) + 1,
                date: links[index]['updated_at'],
                rating: links[index]['rating'] != null ? links[index]['rating']['average_rating'] : 0.0,
                content: links[index]['description'],
                link: links[index]['target_url'],
                faviconUrl: links[index]['favicon_url'] != null ? links[index]['favicon_url'] : '',
              );
            }
            return RecordList(
              id: links[index]['id'],
              title: links[index]['title'] != null ? links[index]['title'] : "-NA-",
              //date: DateTime.utc(2021, DateTime.february, 22),
              //rating: new Random().nextInt(4) + 1,
              date: links[index]['updated_at'],
              rating: links[index]['rating'] != null ? links[index]['rating']['average_rating'] : 0.0,
              link: links[index]['target_url'],
              imageUrl: links[index]['image_url'],
              faviconUrl: links[index]['favicon_url'] != null ? links[index]['favicon_url'] : '',
              //title: "Test Developer",
              //imageUrl: "https://www.foodbusinessnews.net/ext/resources/2020/4/CoupleAtRestaurant_Lead.jpg?t=1587991293&width=1080",
            );
          } else {
            return Container();
          }
        }, childCount: links.length),
      ),
    );
  }
}

class CardsGridViewSliver extends StatelessWidget {
  final bool onPage;
  const CardsGridViewSliver({
    Key? key,
    required this.links,
    this.onPage = true,
  }) : super(key: key);

  final List links;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 15, right: 15),
      sliver: SliverStaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        staggeredTiles: links.map((e) => StaggeredTile.fit(1)).toList(),
        children: links.map((e) {
          if (e['target_url'].contains('://')) {
            if (e['image_url'] == null || e['image_url']?.contains("data:")) {
              return RecordCardText(
                id: e['id'],
                title: e['title'] != null ? e['title'] : "-NA-",
                //date: DateTime.utc(2021, DateTime.february, 22),
                //rating: new Random().nextInt(4) + 1,
                date: e['updated_at'],
                rating: e['rating'] != null ? e['rating']['average_rating'] : 0.0,
                content: e['description'],
                link: e['target_url'],
                faviconUrl: e['favicon_url'] != null ? e['favicon_url'] : '',
                onPage: onPage,
              );
            }

            return RecordCard(
              id: e['id'],
              title: e['title'] != null ? e['title'] : "-NA-",
              //title: "Test Developer",
              //date: DateTime.utc(2021, DateTime.february, 22),
              date: e['updated_at'],
              //rating: new Random().nextInt(4) + 1,
              rating: e['rating'] != null ? e['rating']['average_rating'] : 0.0,
              link: e['target_url'],
              imageUrl: e['image_url'],
              faviconUrl:  e['favicon_url'] != null ? e['favicon_url'] : '',
              onPage: onPage,
              //imageUrl: "https://www.foodbusinessnews.net/ext/resources/2020/4/CoupleAtRestaurant_Lead.jpg?t=1587991293&width=1080",
            );
          } else {
            return Container();
          }
        }).toList(),
      ),
    );
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}

class CardsSliderViewSliver extends StatelessWidget {
  const CardsSliderViewSliver({
    Key? key,
    required this.links,
  }) : super(key: key);

  final List links;

  @override
  Widget build(BuildContext context) {
    return new StaggeredGridView.countBuilder(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 3,
      itemCount: links.length,
      itemBuilder: (BuildContext context, int e) {
         if (links[e]['link']['target_url'].contains('://')) {
          if (links[e]['link']['image_url'] == null || links[e]['link']['image_url']?.contains("data:")) {
            return RecordCardText(
              id: links[e]['link']['id'],
              title: links[e]['link']['title'] != null ? links[e]['link']['title'] : "-NA-",
              //date: DateTime.utc(2021, DateTime.february, 22),
              //rating: new Random().nextInt(4) + 1,
              date: links[e]['link']['updated_at'],
              rating: links[e]['link']['rating'] != null ? links[e]['link']['rating']['average_rating'] : 0.0,
              content: links[e]['link']['description'],
              link: links[e]['link']['target_url'],
              faviconUrl: links[e]['link']['favicon_url'] != null ? links[e]['link']['favicon_url'] : '',
            );
          }
          return RecordCard(
            id: links[e]['link']['id'],
            title: links[e]['link']['title'] != null ? links[e]['link']['title'] : "-NA-",
            //title: "Test Developer",
            //date: DateTime.utc(2021, DateTime.february, 22),
            //rating: new Random().nextInt(4) + 1,
            date: links[e]['link']['updated_at'],
            rating: links[e]['link']['rating'] != null ? links[e]['link']['rating']['average_rating'] : 0.0,
            link: links[e]['link']['target_url'],
            imageUrl: links[e]['link']['image_url'],
            faviconUrl:  links[e]['link']['favicon_url'] != null ? links[e]['link']['favicon_url'] : '',
            //imageUrl: "https://www.foodbusinessnews.net/ext/resources/2020/4/CoupleAtRestaurant_Lead.jpg?t=1587991293&width=1080",
          );
        } else {
          return Container();
        }
      },
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}


