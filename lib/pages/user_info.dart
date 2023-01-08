import 'package:firebase_test/auth.dart';
import 'package:firebase_test/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late CurrentUser user = CurrentUser();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '91063080524-2l7ioh0btjb8i3fvqta96oeclak0d78i.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  void _logout() async {
    await _googleSignIn.disconnect();
    // delete user info from local storage

    //go to login page
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    //user = Provider.of<CurrentUser>(context);
    // account = Provider.of<CurrentAccount>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<CurrentUser>(context);
    final u = user.currentUser;
    // user info widget
    if (u != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //user photo
              CircleAvatar(
                backgroundImage: NetworkImage(u.photoURL!),
                radius: 64,
              ),
              Text(
                'Hola! ${u.displayName!}',
                style: const TextStyle(fontSize: 20),
              ),
              //user email
              Text(
                'Correo: ${u.email!}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'UUID: ${u.uid}',
                style: const TextStyle(fontSize: 20),
              ),
              //logout button
              ElevatedButton(
                onPressed: (() => {
                      Authentication.signOutGoogle(context: context),
                      Navigator.pushNamed(context, '/login')
                    }),
                child: const Text('Cerrar Sesion'),
              )
            ],
          ),
        ),
      );
    } else {
      return const Text('No hay usuario');
    }
  }
}
