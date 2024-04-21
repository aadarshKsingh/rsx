import 'package:dart_rss/dart_rss.dart';

class Constants {
  static Map<String, String> sources = {
    "XDA": "https://www.xda-developers.com/feed",
    "HackerNoon": "https://hackernoon.com/feed",
    "AndroidAuthority": "http://feed.androidauthority.com"
  };
  static Map<String, String> selected = {};
  static List<RssItem> savedPosts = [];
}
