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
  @override
  void initState() {
    super.initState();
    Utility().updateRSS();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Post>>(
        future: Utility().getRSS(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return SmartRefresher(
              enablePullDown: true,
              controller: _refreshContr,
              onRefresh: () => setState(() {
                Utility().updateRSS();
              }),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: SwipeableTile.swipeToTriggerCard(
                        direction: SwipeDirection.startToEnd,
                        shadow: const BoxShadow(),
                        color: Constants.dark.inverseSurface.withAlpha(50),
                        verticalPadding: 5.0,
                        horizontalPadding: 5.0,
                        onSwiped: (direction) {
                          Utility().savePost(snapshot.data![index]);
                          Utility().saveSaved();
                          const savedSnack =
                              SnackBar(content: Text("Post Saved"));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(savedSnack);
                        },
                        key: ValueKey(snapshot.data![index].title),
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
                                snapshot.data![index].title.toString(),
                                textStyle: const TextStyle(
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                              Text(
                                snapshot.data![index].date,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.0),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                Bidi.stripHtmlIfNeeded(
                                        snapshot.data![index].description)
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
                        post: snapshot.data![index],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
