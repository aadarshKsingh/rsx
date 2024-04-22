import 'dart:convert';

import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;
import 'package:rsx/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  List<RssItem> feedItems = [];
  late final SharedPreferences prefs;
  Future<void> fetchRSS(String url) async {
    final client = http.Client();
    final response = await client.get(Uri.parse(url)); // Await the response
    final body = await response.body; // Await the body
    final channel = RssFeed.parse(body);
    feedItems.addAll(channel.items);
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
      Constants.savedPosts = jsonDecode((prefs.getString('saved').toString()));
    }
    for (var url in Constants.selected.values) {
      await fetchRSS(url);
    }
  }

  Future<List<RssItem>> getRSS() async {
    await updateRSS();
    return feedItems;
  }

  void savePost(RssItem item) {
    if (!Constants.savedPosts.contains(item)) {
      Constants.savedPosts.add(item);
    }
  }

  void removePost(RssItem item) {
    if (!Constants.savedPosts.contains(item)) {
      Constants.savedPosts.remove(item);
    }
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
}
