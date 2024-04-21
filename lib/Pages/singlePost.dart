import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class SinglePost extends StatelessWidget {
  RssItem post;
  SinglePost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(post.dc!.creator.toString()),
              Text(
                post.pubDate.toString().substring(0, 16),
              ),
              const SizedBox(
                height: 25.0,
              ),
              HtmlWidget(
                post.content!.value.toString(),
                textStyle: const TextStyle(fontSize: 15.0),
              ),
              const SizedBox(
                height: 25.0,
              ),
              GestureDetector(
                child: const Text(
                  "Original Post",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.lightBlueAccent),
                ),
                onTap: () => launchUrlString(post.link.toString()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
