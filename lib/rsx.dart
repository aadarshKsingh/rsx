import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rsx/Pages/home.dart';
import 'package:rsx/Pages/settings.dart';
import 'package:rsx/Pages/sources.dart';
import 'package:rsx/constants.dart';
import 'package:rsx/util.dart';

class RSX extends StatefulWidget {
  const RSX({super.key});

  @override
  State<RSX> createState() => _RSXState();
}

class _RSXState extends State<RSX> {
  static const List<Widget> pages = [Home(), Settings()];
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();

    Utility().updateRSS();
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
          IconButton(
              onPressed: () => setState(() {
                    Utility().updateRSS();
                  }),
              icon: const Icon(IconlyLight.info_circle)),
          PopupMenuButton<String>(
            popUpAnimationStyle: AnimationStyle(
                curve: Curves.decelerate,
                duration: const Duration(milliseconds: 200)),
            onSelected: (value) {
              switch (value) {
                case 'Sources':
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Sources()));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Sources'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: [
                      const Icon(
                        IconlyBroken.filter,
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
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() {
                _selectedIndex = index;
              }),
          destinations: const [
            NavigationDestination(icon: Icon(IconlyLight.home), label: "Home"),
            NavigationDestination(
                icon: Icon(IconlyLight.setting), label: "Settings")
          ]),
      body: pages[_selectedIndex],
    );
  }
}
