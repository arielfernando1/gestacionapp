import 'dart:developer';

import 'package:firebase_test/pages/info/info_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'bitacora/bitacora_page.dart';
import 'calendar_page.dart';

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
    const CalendarPage(),
    ProfileScreen(
      actions: [
        SignedOutAction((context) {
          Navigator.pushReplacementNamed(context, '/signin');
        }),
        // AuthStateChangeAction<CredentialLinked>((context, state) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text("Provider sucessfully linked!"),
        //     ),
        //   );
        // }),
      ],
    )
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
    log('HomePage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedIndex: selectedIndex,
        // ignore: prefer_const_literals_to_create_immutables
        destinations: <Widget>[
          const NavigationDestination(icon: Icon(Icons.book), label: 'Album'),
          const NavigationDestination(
              icon: Icon(Icons.info), label: 'Informate'),
          const NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Recordatorios'),
          const NavigationDestination(
              icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onDestinationSelected: (index) {
          onItemTapped(index);
        },
      ),
      // bottomNavigationBar:
      // BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.book),
      //       label: 'Album',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.info),
      //       label: 'Informate',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_month),
      //       label: 'Recordatorios',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Perfil',
      //     ),
      //   ],
      //   currentIndex: selectedIndex,
      //   selectedItemColor: Colors.pinkAccent,
      //   onTap: onItemTapped,
      // ),
    );
  }
}
