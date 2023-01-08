import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CurrentUser with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;
  set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }
}

class CurrentAccount with ChangeNotifier {
  GoogleSignInAccount? _currentAccount;
  GoogleSignInAccount? get currentAccount => _currentAccount;
  set currentAccount(GoogleSignInAccount? account) {
    _currentAccount = account;
    notifyListeners();
  }
}
