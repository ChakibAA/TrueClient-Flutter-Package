# TrueClient Package

A Flutter package that provides functionality to request OTPs for the Algerian Market [TrueClientDZ.com](https://trueclientdz.com). This package enables you to send an OTP request to a given phone number, validate the phone number format, and optionally save the OTP code locally for later use.

## Features

- Send OTP requests to algerian phone number.
- Validate phone number formats.
- Optionally save OTP codes locally using `SharedPreferences`.

## Getting Started

Before using this package, you need to sign up on the [TrueclientDZ](https://trueclientdz.com) website and obtain your API token. This token is required for authenticating API requests.

- Visit TrueclientDZ and sign up.
- After signing up, go to your dashboard and generate an API token.
- Use this token in your application to authenticate OTP requests.

## Installation

Add `trueclient` to your `pubspec.yaml`:

```yaml
dependencies:
  trueclient: ^1.0.0
```

then run

```bash
flutter pub get
```

## Usage

```dart
import 'package:trueclient/trueclient.dart';
```

### Initialization

To use Trueclient, first, you need to create an instance of the Trueclient class. You will need an API token, which can be obtained from the [TrueClient Dashboard](https://trueclientdz.com/dashboard).

```dart
// Here add your token
Trueclient trueclient = Trueclient(token: '');
```

### Requesting an OTP

You can request an OTP for a specific phone number by calling the requestOTP method:

```dart
TrueclientResponse response = await trueclient.requestOTP(phone: '05555555');
```

### Retrieving the Last Saved OTP

If saveOTPCodeInLocal is set to true, you can retrieve the last saved OTP code:

```dart
String lastOtpCode = await trueclient.lastCodeOTP;
```

### Validating Phone Numbers

You can validate phone numbers to ensure they meet the required format:

```dart
bool isValid = trueclient.validatePhone(phone);
```

## API Documentation

If you prefer not to use this package or want to integrate the API directly, detailed documentation is available on the [Trueclient documentation](https://trueclientdz.com/documentation). The documentation provides information on how to interact with the API, including how to send OTP requests, handle responses, and other functionalities provided by TrueclientDZ.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

This project is licensed under the The 3-Clause BSD License

## Support

For support, please contact [support@trueclientdz.com](mailto:support@trueclientdz.com).
