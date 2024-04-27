import 'dart:convert';

import 'package:dart_rss/dart_rss.dart';
import 'package:gemini_flutter/models/geminiTextResponseModel.dart';
import 'package:http/http.dart' as http;
import 'package:rsx/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gemini_flutter/gemini_flutter.dart';

class Utility {
  List rssFeedItems = [];
  late final SharedPreferences prefs;
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
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('sources') != null) {
      Map<String, dynamic> test =
          jsonDecode((prefs.getString('sources').toString()));
      Constants.sources = test.cast<String, String>();
    }
    if (prefs.getString('selected') != null) {
      Map<String, dynamic> selected =
          jsonDecode((prefs.getString('selected').toString()));
      Constants.selected = selected.cast<String, String>();
    }
    if (prefs.getString('saved') != null) {
      Constants.savedPosts =
          jsonDecode((prefs.getString('saved').toString())) as List;
    }
    if (prefs.getBool('gemini_status') != null) {
      Constants.gemini_status = prefs.getBool("gemini_status") ?? false;
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
    prefs = await SharedPreferences.getInstance();
    prefs.setString("sources", jsonEncode(Constants.sources));
  }

  void saveSelected() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("selected", jsonEncode(Constants.selected));
  }

  void saveSaved() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("saved", jsonEncode(Constants.savedPosts));
  }

  void saveAPI(String key) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("gemini", key);
  }

  Future<String> cutTheBS(String content) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("gemini_status") == false ||
        prefs.getString("gemini") == null) {
      return content;
    }
    GeminiHandler().initialize(
      apiKey: prefs.getString("gemini").toString(),
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
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("gemini_status", value);
  }

  Future<String> getAPI() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("gemini").toString();
  }
}
