import 'package:dart_rss/dart_rss.dart';
import 'package:gemini_flutter/models/geminiTextResponseModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rsx/constants.dart';
import 'package:gemini_flutter/gemini_flutter.dart';
import 'package:get_storage/get_storage.dart';

class Post {
  final String title;
  final String author;
  final String date;
  final String description;
  final String link;
  const Post(
      {required this.title,
      required,
      required this.author,
      required this.date,
      required this.description,
      required this.link});
}

class Utility extends GetxController {
  final GetStorage box = GetStorage();
  final _const = Get.put(Constants());
  // ignore: prefer_typing_uninitialized_variables
  var feedItems = <String, List<Post>>{}.obs;
  var rssFeedItems = [].obs;
  dynamic channel;

  void updateGS() {
    if (box.read('sources') != null) {
      _const.sources.value = box.read('sources');
    }
    if (box.read('selected') != null) {
      _const.selected.value = box.read('selected').cast<String, String>();
    }
    if (box.read('saved') != null) {
      _const.savedPosts.value = box.read('saved');
    }
    if (box.read('gemini_status') != null) {
      _const.gemini_status.value =
          box.read("gemini_status").cast<bool>() ?? false;
    }
  }

  void fetchRSS() async {
    final client = http.Client();
    _const.selected.forEach((key, value) async {
      final response = await client.get(Uri.parse(value));
      final body = await response.body;

      try {
        channel = RssFeed.parse(body);
        List<Post> singleFeedItems = [];
        for (var item in channel.items) {
          singleFeedItems.add(Post(
              title: item.title,
              author: item.dc.creator,
              date: item.pubDate,
              description: item.content.value,
              link: item.link));
        }
        feedItems.addAll({key: singleFeedItems});
      } catch (e) {
        try {
          channel = AtomFeed.parse(body);
          List<Post> singleFeedItems = [];
          for (var item in channel.items) {
            singleFeedItems.add(Post(
                title: item.title,
                author: item.author.first.name,
                date: item.updated,
                description: item.content,
                link: item.link));
          }
          feedItems.addAll({key: singleFeedItems});
        } catch (e) {}
      }
    });

    feedItems.forEach((key, value) {
      rssFeedItems.addAll(value);
    });
  }

  void savePost(Post item) {
    bool exists = _const.savedPosts.any((post) => post.title == item.title);
    if (!exists) {
      _const.savedPosts.add(item);
    }
  }

  void removePost(dynamic item) {
    _const.savedPosts.remove(item);
  }

  void saveSources() async {
    box.write("sources", _const.sources.value);
  }

  void saveSelected() async {
    box.write("selected", _const.selected.value);
  }

  void saveSaved() async {
    box.write("saved", _const.savedPosts.value);
  }

  void saveAPI(String key) async {
    box.write("gemini", key);
  }

  Future<String> cutTheBS(String content) async {
    if (box.read("gemini_status") == false || box.read("gemini") == null) {
      return content;
    }
    GeminiHandler().initialize(
      apiKey: box.read("gemini").toString(),
      topK: 50,
      topP: 0.8,
      outputLength: 1024,
    );
    final summarized =
        await GeminiHandler().geminiPro(text: "Summarize $content");
    List<Parts>? parts =
        summarized!.candidates!.first.content!.parts as List<Parts>;
    String text = "";
    for (var part in parts) {
      text += part.text.toString();
    }

    // ignore: unnecessary_null_comparison
    if (summarized != null) {
      return text.toString();
    } else {
      return content;
    }
  }

  void setGeminiStatus(bool value) async {
    box.write("gemini_status", value);
  }
}
