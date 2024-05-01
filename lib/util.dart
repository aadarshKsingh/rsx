import 'package:dart_rss/dart_rss.dart';
import 'package:gemini_flutter/models/geminiTextResponseModel.dart';
import 'package:http/http.dart' as http;
import 'package:rsx/constants.dart';
import 'package:gemini_flutter/gemini_flutter.dart';
import 'package:get_storage/get_storage.dart';

class Utility {
  List rssFeedItems = [];
  late final GetStorage box;
  // ignore: prefer_typing_uninitialized_variables
  dynamic channel;
  Future<void> fetchRSS(String url) async {
    final client = http.Client();
    final response = await client.get(Uri.parse(url));
    final body = await response.body;
    try {
      channel = RssFeed.parse(body);
      rssFeedItems.addAll(channel.items);
    } catch (e) {
      try {
        channel = AtomFeed.parse(body);
        rssFeedItems.addAll(channel.items);
      } catch (e) {}
    }
  }

  Future<void> updateRSS() async {
    box = GetStorage();
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

  Future<List> getRSS() async {
    await updateRSS();
    return rssFeedItems;
  }

  void savePost(dynamic item) {
    bool exists =
        Constants.savedPosts.any((post) => post["title"] == item.title);
    if (item is RssItem && !exists) {
      Map<String, String> rssPost = {
        "post": "rss",
        "title": item.title.toString(),
        "date": item.pubDate.toString(),
        "author": item.dc!.creator.toString(),
        "content": item.content!.value,
        "link": item.link.toString()
      };
      Constants.savedPosts.add(rssPost);
    } else if (item is AtomItem && !exists) {
      Map<String, String> atomPost = {
        "post": "atom",
        "title": item.title.toString(),
        "date": item.updated.toString(),
        "author": item.authors.first.name.toString(),
        "content": item.content.toString(),
        "link": item.links.first.toString()
      };
      Constants.savedPosts.add(atomPost);
    }
  }

  void removePost(dynamic item) {
    Constants.savedPosts.remove(item);
  }

  void saveSources() async {
    box = GetStorage();
    box.write("sources", Constants.sources);
  }

  void saveSelected() async {
    box = GetStorage();
    box.write("selected", Constants.selected);
  }

  void saveSaved() async {
    box = GetStorage();
    box.write("saved", Constants.savedPosts);
  }

  void saveAPI(String key) async {
    box = GetStorage();
    box.write("gemini", key);
  }

  Future<String> cutTheBS(String content) async {
    box = GetStorage();
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
    box = GetStorage();
    box.write("gemini_status", value);
  }
}
