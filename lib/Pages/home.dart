import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsx/Pages/singlePost.dart';
import 'package:rsx/util.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
      body: FutureBuilder<List<RssItem>>(
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
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data![index].title.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0),
                            ),
                            Text(
                              snapshot.data![index].pubDate
                                  .toString()
                                  .substring(0, 25),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12.0),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              Bidi.stripHtmlIfNeeded(
                                      snapshot.data![index].content!.value)
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
                            builder: (context) =>
                                SinglePost(post: snapshot.data![index]))),
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
