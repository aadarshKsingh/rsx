import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rsx/Pages/gemini.dart';
import 'package:rsx/Pages/home.dart';
import 'package:rsx/Pages/saved.dart';
import 'package:rsx/Pages/sources.dart';
import 'package:rsx/util.dart';
import 'package:get/get.dart';

class RSX extends StatefulWidget {
  const RSX({super.key});

  @override
  State<RSX> createState() => _RSXState();
}

class _RSXState extends State<RSX> {
  static const List<Widget> pages = [Home(), Saved()];
  RxInt _selectedIndex = 0.obs;
  @override
  void initState() {
    super.initState();

    Utility().fetchRSS();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "RSX",
          style: TextStyle(
              fontFamily: 'Gotham',
              fontWeight: FontWeight.bold,
              letterSpacing: 15),
        ),
        actions: [
          PopupMenuButton<String>(
            popUpAnimationStyle: AnimationStyle(
                curve: Curves.decelerate,
                duration: const Duration(milliseconds: 200)),
            onSelected: (value) {
              switch (value) {
                case 'Sources':
                  Get.to(const Sources());
                  break;
                case 'Gemini':
                  Get.to(const Gemini());
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Sources', 'Gemini'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: [
                      Icon(
                        choice == 'Sources'
                            ? IconlyBroken.filter
                            : IconlyBroken.edit,
                        size: 20.0,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(choice),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex.value,
          onDestinationSelected: (index) => setState(() {
                _selectedIndex.value = index;
              }),
          destinations: const [
            NavigationDestination(icon: Icon(IconlyLight.home), label: "Home"),
            NavigationDestination(
                icon: Icon(IconlyLight.arrow_down), label: "Saved")
          ]),
      body: Obx(() => pages.elementAt(_selectedIndex.value)),
    );
  }
}
