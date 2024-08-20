import 'package:flutter_test/flutter_test.dart';
import 'package:trueclient/trueclient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late Trueclient trueclient;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    trueclient = Trueclient(
      token: '',
      saveOTPCodeInLocal: true,
    );

    // Initialize mock shared preferences
    mockSharedPreferences = MockSharedPreferences();
    when(mockSharedPreferences.getString('TrueClient_Last_OTP_Code'))
        .thenReturn(null);
  });

  group('Trueclient API Tests', () {
    test('should validate phone number format', () {
      // Act & Assert: Check various phone number formats
      expect(trueclient.validatePhone('0612345678'),
          isTrue); // Valid format should return true
      expect(trueclient.validatePhone('0812345678'),
          isFalse); // Invalid format should return false
    });
  });
}
