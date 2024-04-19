import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:rsx/util.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching data'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
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
                            fontWeight: FontWeight.w300, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    ));
  }
}
