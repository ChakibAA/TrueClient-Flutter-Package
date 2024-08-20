/// Represents the response received from the TrueClient API.
///
/// This class encapsulates the status, message, and optional data returned
/// by the API in response to requests such as OTP requests.
class TrueclientResponse {
  /// Indicates the success or failure of the API request.
  ///
  /// `true` if the request was successful, otherwise `false`.
  bool success;

  /// Provides a descriptive message about the result of the API request.
  ///
  /// This message can be an error description or a success confirmation.
  String message;

  /// Contains additional data returned by the API.
  ///
  /// This is an optional field and may be `null` if no data is returned.
  /// For example, it could include details such as the OTP code or other
  /// relevant information from the API response.
  Map<String, dynamic>? data;

  /// Creates an instance of `TrueclientResponse`.
  ///
  /// [message] is the message associated with the API response.
  /// [success] indicates whether the request was successful.
  /// [data] is optional and contains additional data from the API.
  TrueclientResponse({required this.message, required this.success, this.data});
}
