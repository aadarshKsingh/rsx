import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rsx/Pages/home.dart';
import 'package:rsx/Pages/settings.dart';

class RSX extends StatefulWidget {
  const RSX({super.key});

  @override
  State<RSX> createState() => _RSXState();
}

class _RSXState extends State<RSX> {
  static const List<Widget> pages = [Home(), Settings()];
  int _selectedIndex = 0;
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
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() {
                _selectedIndex = index;
              }),
          destinations: const [
            NavigationDestination(icon: Icon(IconlyBold.home), label: "Home"),
            NavigationDestination(
                icon: Icon(IconlyBold.setting), label: "Settings")
          ]),
      body: pages[_selectedIndex],
    );
  }
}
