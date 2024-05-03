import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rsx/constants.dart';
import 'package:rsx/util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class Gemini extends StatefulWidget {
  const Gemini({super.key});

  @override
  State<Gemini> createState() => _GeminiState();
}

class _GeminiState extends State<Gemini> {
  late TextEditingController _api;
  bool geminiStatus = false;
  late var box;
  @override
  void initState() {
    box = GetStorage();
    _api = TextEditingController(text: box.read("gemini") ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Constants _const = Get.put(Constants());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gemini AI for summarization"),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _api,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                hintText: "Enter your API key"),
            textAlign: TextAlign.center,
          ),
        ),
        GestureDetector(
          child: Text(
            "How to get API key?",
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blueAccent.shade100.withOpacity(0.7)),
          ),
          onTap: () =>
              launchUrl(Uri.parse("https://aistudio.google.com/app/apikey")),
        ),
        const SizedBox(
          height: 25.0,
        ),
        ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          child: ElevatedButton(
            onPressed: () => Utility().saveAPI(_api.text),
            child: const Text("Save"),
          ),
        ),
        Expanded(
          child: ListTile(
            leading: const Text("Enable Gemini Text Summarization"),
            trailing: Obx(
              () => Switch(
                value: _const.gemini_status.value,
                onChanged: ((value) {
                  if (!_const.gemini_status.value && _api.text.isNotEmpty) {
                    _const.gemini_status.value = value;
                    Utility().setGeminiStatus(value);
                  } else {
                    _const.gemini_status.value = false;
                    Utility().setGeminiStatus(false);
                  }
                }),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
