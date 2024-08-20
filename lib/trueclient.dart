library trueclient;

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trueclient/models/trueclient_response.dart';

export 'package:trueclient/models/trueclient_response.dart';

/// A Dart library that provides functionality to request OTPs and store them locally using [trueclientdz.com](https://trueclientdz.com).
///
/// The `Trueclient` class allows you to send an OTP request to a given phone number,
/// validate the phone number format, and optionally save the OTP code locally for later use.
///
/// To obtain your API token, please visit [trueclientdz.com/dashboard](https://trueclientdz.com/dashboard).
class Trueclient {
  /// Creates an instance of `Trueclient`.
  ///
  /// [token] is required for authentication in API requests. You can find your token in the
  /// [TrueClient Dashboard](https://trueclientdz.com/dashboard).
  /// [saveOTPCodeInLocal] determines whether the OTP code should be stored locally using `SharedPreferences`.
  Trueclient({required this.token, this.saveOTPCodeInLocal = true});

  /// The authentication token used for API requests.
  /// Obtain this token from the [TrueClient Dashboard](https://trueclientdz.com/dashboard).
  String token;

  /// A flag to indicate whether the OTP code should be saved locally.
  bool saveOTPCodeInLocal;

  /// Retrieves the last OTP code saved locally.
  ///
  /// Returns the OTP code as a `String`, or `null` if no code is saved.
  Future<String?> get lastCodeOTP async => await _getCodeInLocal();

  /// A `Dio` instance configured with base options for making HTTP requests.
  final Dio _dio = Dio(BaseOptions(responseType: ResponseType.json));

  /// Sends a request to obtain an OTP for the given [phone] number.
  ///
  /// Optionally, a [lang] parameter can be provided to specify the language of the response.
  /// Validates the phone number format before making the request.
  ///
  /// Returns a `TrueclientResponse` indicating the success or failure of the request.
  Future<TrueclientResponse> requestOTP(
      {required String phone, String? lang}) async {
    try {
      TrueclientResponse? trueclientResponse;

      // Validate phone number format
      if (!validatePhone(phone)) {
        // Return error response if the phone number format is invalid
        trueclientResponse = TrueclientResponse(
            message:
                'Phone number format is invalid. Check the documentation at https://trueclientdz.com/documentation',
            success: false);

        return trueclientResponse;
      }

      // Prepare query parameters for the request
      Map<String, String?> queryParameters = {
        'phone': phone,
        'lang': lang,
      };

      // Set request options, including headers for authorization
      Options options = Options(
        contentType: 'application/json',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
      );

      // Make the POST request to the /api/request endpoint
      final Response response = await _dio.post(
        'https://trueclientdz.com/api/request',
        queryParameters: queryParameters,
        options: options,
      );

      // Handle the response based on the status code
      if (response.statusCode == 200) {
        // Request was successful
        trueclientResponse = TrueclientResponse(
            message: 'OTP request successfully completed',
            success: true,
            data: response.data);

        // Save OTP code locally if the flag is set
        if (saveOTPCodeInLocal) {
          await _saveCodeInLocal(response.data['code']);
        }

        return trueclientResponse;
      }

      // Request failed, return the error message
      Map<String, dynamic> data = response.data;
      trueclientResponse =
          TrueclientResponse(message: data['message'], success: false);

      return trueclientResponse;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      if (e.response != null) {
        // print(e.response!.data);
        // print(e.response!.headers);
        // print(e.response!.requestOptions);

        return TrueclientResponse(
            message: e.response!.data['message'], success: false);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // print(e.requestOptions);
        // print(e.message);
        return TrueclientResponse(message: e.message ?? '', success: false);
      }
    }
  }

  /// Saves the given [codeOTP] locally using `SharedPreferences`.
  ///
  /// The OTP code is stored under the key 'TrueClient_Last_OTP_Code'.
  Future<void> _saveCodeInLocal(String codeOTP) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('TrueClient_Last_OTP_Code', codeOTP);
  }

  /// Retrieves the OTP code saved locally using `SharedPreferences`.
  ///
  /// Returns the OTP code as a `String`, or `null` if no code is saved.
  Future<String?> _getCodeInLocal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? codeOTP = sharedPreferences.getString('TrueClient_Last_OTP_Code');

    return codeOTP;
  }

  /// Validates the format of the given [phone] number.
  ///
  /// The phone number must start with 05, 06, or 07, followed by 8 digits.
  /// Returns `true` if the phone number is valid, otherwise `false`.
  bool validatePhone(String phone) {
    final phoneRegex = RegExp(r'^(05|06|07)\d{8}$');

    if (phoneRegex.hasMatch(phone)) {
      // Phone number is valid
      return true;
    } else {
      // Phone number is invalid
      return false;
    }
  }
}
