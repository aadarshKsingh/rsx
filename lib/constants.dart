import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Constants {
  static Map<String, String> sources = {
    "XDA": "https://www.xda-developers.com/feed",
    "HackerNoon": "https://hackernoon.com/feed",
    "AndroidAuthority": "http://feed.androidauthority.com"
  }.obs;
  static Map<String, String> selected = {};
  static List savedPosts = [];
  static RxBool gemini_status = false.obs;
  static late ColorScheme dark;
  static late ColorScheme light;
}
