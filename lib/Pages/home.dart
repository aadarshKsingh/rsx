import 'package:flutter/material.dart';
import 'package:rsx/util.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: Utility.feedItems.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(Utility.feedItems[index].title.toString()),
        ),
      ),
    );
    // return Scaffold(
    //     body: Center(
    //   child: ElevatedButton(
    //       onPressed: () => Utility().sendRSS(),
    //       child: Text(
    //         "Print rss",
    //         style: TextStyle(fontSize: 50.0),
    //       )),
    // ));
    ;
  }
}
