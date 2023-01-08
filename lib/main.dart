import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/firebase_options.dart';
import 'package:firebase_test/pages/bitacora/addphoto_page.dart';
import 'package:firebase_test/pages/bitacora/bitacora_page.dart';
import 'package:firebase_test/pages/login_page.dart';
import 'package:firebase_test/pages/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'classes/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CurrentUser()),
    ], child: const MyApp()),
  );
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.pink,
        primarySwatch: Colors.pink,
        cardTheme: const CardTheme(
          color: Colors.transparent,
          elevation: 5,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/info': (context) => const UserInfoPage(),
        '/home': (context) => BitacoraPage(),
        '/photo': (context) => const PhotoPage(),
      },
    );
  }
}
