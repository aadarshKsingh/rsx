import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './util.dart';

class Constants extends GetxController {
  RxMap<String, String> sources = <String, String>{
    "XDA": "https://www.xda-developers.com/feed",
    "HackerNoon": "https://hackernoon.com/feed",
    "AndroidAuthority": "http://feed.androidauthority.com"
  }.obs;
  RxMap<String, String> selected = <String, String>{}.obs;
  RxList<Post> savedPosts = <Post>[].obs;
  RxBool gemini_status = false.obs;
  static late ColorScheme dark;
  static late ColorScheme light;
}
