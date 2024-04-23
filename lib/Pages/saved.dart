import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:rsx/constants.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import '../util.dart';
import 'singlePost.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SettingsState();
}

class _SettingsState extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: Constants.savedPosts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: SwipeableTile.card(
              direction: SwipeDirection.startToEnd,
              shadow: const BoxShadow(),
              color: Colors.deepPurple.shade200.withOpacity(0.2),
              verticalPadding: 5.0,
              horizontalPadding: 5.0,
              onSwiped: (direction) {
                Utility().removePost(Constants.savedPosts[index]);
                Utility().saveSaved();
              },
              key: ValueKey(Constants.savedPosts[index].title),
              backgroundBuilder: (context, direction, controller) {
                if (direction == SwipeDirection.startToEnd) {
                  return Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.centerLeft,
                    child: const Row(
                      children: [
                        Icon(IconlyLight.delete),
                        Text("Remove Post"),
                      ],
                    ),
                  );
                } else {
                  return const Text("");
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Constants.savedPosts[index].title.toString(),
                      style: const TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ),
                    Text(
                      Constants.savedPosts[index] is RssItem
                          ? Constants.savedPosts[index].pubDate
                              .toString()
                              .substring(0, 25)
                          : Constants.savedPosts[index].updated.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 12.0),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      Bidi.stripHtmlIfNeeded(Constants.savedPosts[index]
                                  is RssItem
                              ? Constants.savedPosts[index].content!.value
                              : Constants.savedPosts[index].content.toString())
                          .trim(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SinglePost(
                  post: Constants.savedPosts[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
