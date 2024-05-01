import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rsx/constants.dart';
import 'package:rsx/util.dart';
import 'package:get/get.dart';

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
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text("Name:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints.tightFor(width: 300.0),
                            child: TextField(
                              controller: _name,
                              decoration: InputDecoration(
                                hintText: 'Enter name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 19.0),
                          child: Text("URL:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints.tightFor(width: 300),
                            child: TextField(
                              controller: _url,
                              decoration: InputDecoration(
                                hintText: 'Enter URL',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Map<String, String> source = {_name.text: _url.text};
                      Constants.sources.addAll(source);
                      Utility().saveSources();
                      Get.back();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: Constants.sources.length,
          itemBuilder: (context, index) {
            bool _isSelected = Constants.selected.keys
                .contains(Constants.sources.keys.elementAt(index));
            return ListTile(
              leading: Checkbox(
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
                      Utility().saveSelected();
                    }
                  });
                },
              ),
              title: Text(Constants.sources.keys.elementAt(index).toString()),
              trailing: IconButton(
                  icon: const Icon(IconlyLight.delete),
                  onPressed: () {
                    Constants.sources
                        .remove(Constants.sources.keys.elementAt(index));
                    Utility().saveSources();
                  }),
            );
          },
        ),
      ),
    );
  }
}
