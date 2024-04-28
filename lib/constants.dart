import 'package:flutter/material.dart';

class Constants {
  static Map<String, String> sources = {
    "XDA": "https://www.xda-developers.com/feed",
    "HackerNoon": "https://hackernoon.com/feed",
    "AndroidAuthority": "http://feed.androidauthority.com"
  };
  static Map<String, String> selected = {};
  static List savedPosts = [];
  static bool gemini_status = false;
  static late ColorScheme dark;
  static late ColorScheme light;
}
