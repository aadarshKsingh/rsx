import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rsx/util.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class SinglePost extends StatefulWidget {
  dynamic post;
  SinglePost({super.key, required this.post});

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                widget.post is RssItem
                    ? widget.post.content!.value
                    : widget.post.content = Utility().cutTheBS(
                        widget.post is RssItem
                            ? widget.post.content!.value.toString()
                            : widget.post.content);
                setState(() {});
              },
              icon: const Icon(IconlyBroken.star)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.title.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(widget.post is RssItem
                  ? widget.post.dc!.creator.toString()
                  : widget.post.authors.first.name.toString()),
              Text(
                widget.post is RssItem
                    ? widget.post.pubDate.toString().substring(0, 16)
                    : widget.post.updated.toString(),
              ),
              const SizedBox(
                height: 25.0,
              ),
              FutureBuilder<String>(
                  future: Utility().cutTheBS(widget.post is RssItem
                      ? widget.post.content!.value
                      : widget.post.content),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return Text(
                        snapshot.data.toString(),
                        style: const TextStyle(fontSize: 15.0),
                      );
                    }
                  }),
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
                onTap: () => launchUrlString(widget.post.link.toString()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
