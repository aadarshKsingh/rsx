import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rsx/constants.dart';
import 'package:rsx/util.dart';

class Sources extends StatefulWidget {
  const Sources({super.key});

  @override
  State<Sources> createState() => _SourcesState();
}

class _SourcesState extends State<Sources> {
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
                      setState(() {
                        Map<String, String> source = {_name.text: _url.text};
                        Constants.sources.addAll(source);
                        Utility().saveSources();
                        Navigator.pop(context);
                      });
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
        itemCount: Constants.sources.length,
        itemBuilder: (context, index) {
          bool _isSelected = Constants.selected.keys
              .contains(Constants.sources.keys.elementAt(index));
          return CheckboxListTile(
            value: _isSelected,
            onChanged: (val) {
              setState(() {
                _isSelected = val ?? true;
                if (_isSelected) {
                  final source = {
                    Constants.sources.keys.elementAt(index):
                        Constants.sources.values.elementAt(index)
                  };
                  Constants.selected.addAll(source);
                  Utility().saveSelected();
                } else {
                  Constants.selected
                      .remove(Constants.sources.keys.elementAt(index));
                }
              });
            },
            title: Text(Constants.sources.keys.elementAt(index).toString()),
          );
        },
      ),
    );
  }
}
