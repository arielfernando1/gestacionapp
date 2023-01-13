// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_test/classes/post.dart';
import 'package:test/test.dart';

import 'email_validator.dart';

void main() {
  // unit test for email validator
  test('EmailValidator debe retornar false para un email invalido', () {
    final result = EmailValidator.isValid('ariel.aguirre12');
    expect(result, false);
  });
}
