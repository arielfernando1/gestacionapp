import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/firebase_options.dart';
import 'package:firebase_test/pages/bitacora/add_audio_page.dart';
import 'package:firebase_test/pages/bitacora/add_photo_page.dart';
import 'package:firebase_test/pages/home_page.dart';
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
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: prefer_const_literals_to_create_immutables

      title: 'Gestación',
      theme: ThemeData(
        primaryColor: Colors.pink,
        primarySwatch: Colors.pink,
        // cardTheme: const CardTheme(
        //   color: Colors.transparent,
        //   elevation: 5,
        // ),
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sigin' : '/profile',
      routes: {
        '/sigin': (context) {
          return SignInScreen(
            actions: [
              ForgotPasswordAction(((context, email) =>
                  Navigator.of(context).pushNamed('/reset', arguments: email))),
              AuthStateChangeAction<SignedIn>(
                (context, action) => Navigator.of(context).pushNamed('/home'),
              ),
              AuthStateChangeAction<UserCreated>(
                (context, action) => Navigator.of(context).pushNamed('/home'),
              ),
              VerifyPhoneAction(
                (context, verificationId) => Navigator.of(context)
                    .pushNamed('/phone', arguments: verificationId),
              ),
            ],
          );
        },
        '/home': (context) => const HomePage(),
        '/profile': (context) => ProfileScreen(
              actions: [
                SignedOutAction((context) {
                  Navigator.of(context).pushReplacementNamed('/sigin');
                }),
              ],
            ),
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
        '/photo': (context) => const PhotoPage(),
        '/audio': (context) => AudioPage(),
      },
    );
  }
}
