import 'package:flutter/material.dart';
import 'package:janin/provider/navbarprovider.dart';
import 'package:janin/theme.dart';
import 'package:janin/view/home/beranda.dart';
import 'package:janin/view/home/tips.dart';
import 'package:janin/view/profil/profil.dart';
import 'package:janin/view/riwayat.dart';
import 'package:provider/provider.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  List<dynamic> screens = [
  Beranda(),
  Tips(),
  Riwayat(),
  Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    NavbarProvider navbarProvider = Provider.of<NavbarProvider>(context);
    int currentScreenIndex = navbarProvider.fetchCurrentScreenIndex;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: pinkColor,
        selectedItemColor: navbarColor,
        elevation: 1.5,
        currentIndex: currentScreenIndex,
        showUnselectedLabels: true,
        onTap: (value) => navbarProvider.updateScreenIndex(value),
        items: [
          BottomNavigationBarItem(
            label: 'Beranda',
            icon: Icon(
                (currentScreenIndex == 0) ? Icons.home : Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Tips',
            icon: Icon((currentScreenIndex == 1)
                ? Icons.lightbulb
                : Icons.lightbulb_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Riwayat',
            icon: Icon((currentScreenIndex == 2)
                ? Icons.history
                : Icons.history_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon((currentScreenIndex == 3)
                ? Icons.person
                : Icons.person_outline),
          ),
        ],
      ),
      body: screens[currentScreenIndex],
    );
  }
}