import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:rsx/Pages/singlePost.dart';
import 'package:rsx/constants.dart';
import 'package:rsx/util.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RefreshController _refreshContr =
      RefreshController(initialRefresh: false);
  Utility util = Get.put(Utility());
  @override
  void initState() {
    super.initState();
    util.fetchRSS();
  }

  @override
  Widget build(BuildContext context) {
    Utility util = Get.put(Utility());
    return Scaffold(
      body: Obx(
        () => SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshContr,
          onRefresh: () {
            util.fetchRSS();
            _refreshContr.refreshCompleted();
          },
          child: ListView.builder(
            itemCount: util.rssFeedItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: SwipeableTile.swipeToTriggerCard(
                    direction: SwipeDirection.startToEnd,
                    shadow: const BoxShadow(),
                    color: Constants.dark.inverseSurface.withAlpha(50),
                    verticalPadding: 5.0,
                    horizontalPadding: 5.0,
                    onSwiped: (direction) {
                      util.savePost(util.rssFeedItems[index]);
                      util.saveSaved();
                      const savedSnack = SnackBar(content: Text("Post Saved"));
                      ScaffoldMessenger.of(context).showSnackBar(savedSnack);
                    },
                    key: ValueKey(util.rssFeedItems[index].title),
                    backgroundBuilder: (context, direction, controller) {
                      if (direction == SwipeDirection.startToEnd) {
                        return Container(
                          padding: const EdgeInsets.only(left: 30.0),
                          alignment: Alignment.centerLeft,
                          child: const Row(
                            children: [
                              Icon(IconlyLight.arrow_down),
                              Text("Save Post"),
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
                          HtmlWidget(
                            util.rssFeedItems[index].title.toString(),
                            textStyle: const TextStyle(
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ),
                          Text(
                            util.rssFeedItems[index].date,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12.0),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            Bidi.stripHtmlIfNeeded(
                                    util.rssFeedItems[index].description)
                                .trim(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )),
                onTap: () => Get.to(
                  SinglePost(
                    post: util.rssFeedItems[index],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
