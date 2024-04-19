import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;
import 'package:rsx/constants.dart';

class Utility {
  List<RssItem> feedItems = [];

  Future<void> fetchRSS(String url) async {
    final client = http.Client();
    final response = await client.get(Uri.parse(url)); // Await the response
    final body = await response.body; // Await the body
    final channel = RssFeed.parse(body);
    feedItems.addAll(channel.items);
  }

  Future<void> updateRSS() async {
    for (var url in Constants.sources.values) {
      await fetchRSS(url); // Await each fetchRSS call
    }
  }

  Future<List<RssItem>> getRSS() async {
    await updateRSS(); // Ensure data is fetched before returning
    return feedItems;
  }
}
