import 'package:dart_rss/dart_rss.dart';
import 'package:gemini_flutter/models/geminiTextResponseModel.dart';
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

class Utility {
  List<Post> rssFeedItems = [];
  final GetStorage box = GetStorage();
  // ignore: prefer_typing_uninitialized_variables
  dynamic channel;
  fetchRSS(String url) async {
    final client = http.Client();
    final response = await client.get(Uri.parse(url));
    final body = await response.body;
    try {
      channel = RssFeed.parse(body);
      for (var item in channel.items) {
        rssFeedItems.add(Post(
            title: item.title,
            author: item.dc.creator,
            date: item.pubDate,
            description: item.content.value,
            link: item.link));
      }
    } catch (e) {
      try {
        channel = AtomFeed.parse(body);
        for (var item in channel.items) {
          rssFeedItems.add(Post(
              title: item.title,
              author: item.author.first.name,
              date: item.updated,
              description: item.content,
              link: item.link));
        }
      } catch (e) {}
    }
  }

  Future<void> updateRSS() async {
    if (box.read('sources') != null) {
      Constants.sources = box.read('sources').cast<String, String>();
    }
    if (box.read('selected') != null) {
      Constants.selected = box.read('selected').cast<String, String>();
    }
    if (box.read('saved') != null) {
      Constants.savedPosts = box.read('saved');
    }
    if (box.read('gemini_status') != null) {
      Constants.gemini_status.value = box.read("gemini_status") ?? false;
    }
    for (var url in Constants.selected.values) {
      await fetchRSS(url);
    }
  }

  Future<List<Post>> getRSS() async {
    await updateRSS();
    return rssFeedItems;
  }

  void savePost(Post item) {
    bool exists = Constants.savedPosts.any((post) => post.title == item.title);
    if (!exists) {
      Constants.savedPosts.add(item);
    }
  }

  void removePost(dynamic item) {
    Constants.savedPosts.remove(item);
  }

  void saveSources() async {
    box.write("sources", Constants.sources);
  }

  void saveSelected() async {
    box.write("selected", Constants.selected);
  }

  void saveSaved() async {
    box.write("saved", Constants.savedPosts);
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
