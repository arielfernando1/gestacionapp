import 'package:firebase_test/pages/testpage.dart';
import 'package:firebase_test/pages/user_info.dart';
import 'package:flutter/material.dart';

import 'bitacora/bitacora_page.dart';
import 'news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late User _currentUser;
  int selectedIndex = 0;
  final widgetOptions = [
    BitacoraPage(),
    const TestPage(),
    const NewsPage(),
    const UserInfoPage(),
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    // _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Bitácora',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        onTap: onItemTapped,
      ),
    );
  }
}
