import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/auth.dart';
import 'package:firebase_test/classes/user.dart';
import 'package:firebase_test/pages/bitacora/bitacora_page.dart';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:auth_buttons/auth_buttons.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages

import 'calendar_page.dart';
import 'home_page.dart';
import 'info/info_page.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  serverClientId:
      '91063080524-2l7ioh0btjb8i3fvqta96oeclak0d78i.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future<void> main() async {
  runApp(
    const MaterialApp(
      home: LoginPage(),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int selectedIndex = 0;
  final widgetOptions = [
    BitacoraPage(),
    const TestPage(),
    const CalendarPage(),
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      //print(_currentUser);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody() {
    //User user = FirebaseAuth.instance.currentUser!;
    //GoogleSignInAccount? user = _currentUser;
    final formKey = GlobalKey<FormState>();
    // ignore: unnecessary_null_comparison
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      //center the children

      children: <Widget>[
        const Text(
          'Bienvenidos',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        // mail and password text fields
        // ignore: prefer_const_constructors

        //app circular logo from network
        // image from assets
        Image.asset(
          'assets/logo.png',
          height: 200,
          width: 200,
        ),
        Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // rounded text fields

              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'ejemplo@dominio.com',
                    labelText: 'Correo electronico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'El correo no puede estar vacio' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              // ignore: prefer_const_constructors
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Ingrese su contraseña',
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                validator: (value) => value!.length < 6
                    ? 'La contraseña debe tener al menos 6 caracteres'
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              // ignore: prefer_const_constructors
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // ignore: avoid_print
                    // user = _currentUser;
                  } else {
                    // ignore: avoid_print
                    print('Email is invalid');
                  }
                },
                child: const Text('Iniciar Sesion'),
              ),
            ],
          ),
        ),
        //or login with text
        const Text(
          'O inicia sesion con',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        AuthButtonGroup(
          alignment: WrapAlignment.center,
          // ignore: prefer_const_constructors
          style: AuthButtonStyle(
            iconSize: 30,
            buttonType: AuthButtonType.secondary,
          ),
          buttons: [
            GoogleAuthButton(
              onPressed: (() async {
                User? user =
                    await Authentication.signInWithGoogle(context: context);
                // pass user to provider
                // ignore: avoid_print, use_build_context_synchronously
                Provider.of<CurrentUser>(context, listen: false).currentUser =
                    user;
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
                print(user);
              }),
              text: 'Google',
            ),
            FacebookAuthButton(
              onPressed: () async {
                await FacebookAuth.instance.login();
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              text: 'Facebook',
            ),
            EmailAuthButton(
              onPressed: () {
                // FirebaseUI login
                // ignore: use_build_context_synchronously
              },
              text: 'E-mail',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: _buildBody(),
    ));
  }
}
