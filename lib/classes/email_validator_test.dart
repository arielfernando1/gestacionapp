// ignore: depend_on_referenced_packages
import 'package:test/test.dart';

import 'email_validator.dart';

void main() {
  test('EmailValidator debe retornar true para un email válido', () {
    final result = EmailValidator.isValid('arielaguirre@gmail.com');
    expect(result, true);
  });
}
