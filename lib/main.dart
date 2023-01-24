import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/classes/stick_it.dart';
import 'package:firebase_test/firebase_options.dart';
import 'package:firebase_test/pages/bitacora/add_audio_page.dart';
import 'package:firebase_test/pages/bitacora/add_photo_page.dart';
import 'package:firebase_test/pages/home_page.dart';
import 'package:firebase_test/pages/login_screen_1.dart';
import 'package:firebase_test/pages/pdf_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // set providers
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(
        clientId:
            '91063080524-2l7ioh0btjb8i3fvqta96oeclak0d78i.apps.googleusercontent.com'),
    PhoneAuthProvider(),
    FacebookProvider(clientId: '25c4b3d94da6a600734d8a5b6946070d')
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    log('MyApp: initState()');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: prefer_const_literals_to_create_immutables

      title: 'Gestación',
      theme: ThemeData(
          fontFamily: 'Chewy',
          brightness: Brightness.light,
          primaryColor: const Color.fromRGBO(255, 175, 204, 1),
          backgroundColor: const Color.fromRGBO(189, 224, 254, 1),
          errorColor: Colors.red[250],
          // ignore: prefer_const_constructors
          appBarTheme: AppBarTheme(
              color: const Color.fromRGBO(255, 175, 204, 1), centerTitle: true),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            subtitle1: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w200,
              letterSpacing: 0.8,
            ),
            button: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          )),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/signin' : '/home',
      routes: {
        '/signin': (context) {
          return SignInScreen(
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(1),
                child: Image.asset('assets/logo.png'),
              );
            },
            footerBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Al continuar, aceptas nuestros Términos de Servicio y Política de Privacidad',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              );
            },

            actions: [
              ForgotPasswordAction((context, email) => Navigator.of(context)
                  .pushNamed('/forgot-password', arguments: email)),
              AuthStateChangeAction<SignedIn>(
                (context, state) {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
              AuthStateChangeAction<UserCreated>(
                (context, action) => Navigator.of(context).pushNamed('/home'),
              ),
              VerifyPhoneAction(
                (context, verificationId) => Navigator.of(context)
                    .pushNamed('/phone', arguments: verificationId),
              ),
            ],
            // logout actions
          );
        },
        '/forgot-password': (context) => ForgotPasswordScreen(
              email: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfileScreen(),
        '/phone': (context) => PhoneInputScreen(
              actions: [
                SMSCodeRequestedAction(
                    ((context, action, flowKey, phoneNumber) =>
                        Navigator.of(context)
                            .pushReplacementNamed('/sms', arguments: {
                          'flowKey': flowKey,
                          'phoneNumber': phoneNumber,
                          'action': action,
                        }))),
              ],
            ),
        '/sms': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return SMSCodeInputScreen(actions: [
            AuthStateChangeAction<SignedIn>(
              (context, action) =>
                  Navigator.of(context).pushReplacementNamed('/home'),
            ),
          ], flowKey: args['flowKey'], action: args['action']);
        },
        '/photo': (context) => PhotoPage(),
        '/audio': (context) => AudioPage(),
        '/pdf': (context) => PdfPage(),
        '/customlogin': (context) => const CustomLogin(),
        '/edit_post': (context) => StickerPage()
      },
    );
  }
}
