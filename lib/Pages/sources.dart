import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class Sources extends StatefulWidget {
  const Sources({super.key});

  @override
  State<Sources> createState() => _SourcesState();
}

class _SourcesState extends State<Sources> {
  Map<String, String> sources = {
    "YCombinator": "https://news.ycombinator.com/rss",
    "HackerNoon": "https://hackernoon.com/feed",
    "AndroidAuthority": "http://feed.androidauthority.com"
  };
  Map<String, String> selected = {};
  late TextEditingController _name;
  late TextEditingController _url;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _url = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Select your sources",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.plus),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Enter source details"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Name:"),
                    TextField(
                      controller: _name,
                    ),
                    const Text("URL:"),
                    TextField(
                      controller: _url,
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Map<String, String> source = {_name.text: _url.text};
                      sources.addAll(source);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: sources.length,
        itemBuilder: (context, index) {
          bool _isSelected =
              selected.keys.contains(sources.keys.elementAt(index));
          return CheckboxListTile(
            value: _isSelected,
            onChanged: (val) {
              setState(() {
                _isSelected = val ?? false;
                if (_isSelected) {
                  final source = {
                    sources.keys.elementAt(index):
                        sources.values.elementAt(index)
                  };
                  selected.addAll(source);
                } else {
                  selected.remove(sources.keys.elementAt(index));
                }
              });
            },
            title: Text(sources.keys.elementAt(index).toString()),
          );
        },
      ),
    );
  }
}
