import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;
import 'package:rsx/constants.dart';

class Utility {
  static List<RssItem> feedItems = [];
  void fetchRSS(String url) {
    final client = http.Client();
    client.get(Uri.parse(url)).then((response) {
      return response.body;
    }).then((body) {
      final channel = RssFeed.parse(body);
      feedItems.addAll(channel.items);
    });
  }

  void sendRSS() {
    for (var url in Constants.sources.values) {
      fetchRSS(url);
    }
  }
}
