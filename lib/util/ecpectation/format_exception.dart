// ignore_for_file: unreachable_switch_case, unnecessary_string_escapes

class TFormatException implements Exception {
  final String message;

  TFormatException(
      [this.message =
          "An unexpected fromat error occurred. Please check your input."]);
  factory TFormatException.fromMessage(String message) {
    return TFormatException();
  }

  String get formattedMessage => message;
  factory TFormatException.fromCode(String code) {
    switch (code) {
      case "invalide-email-format":
        return TFormatException(
            "the email address format is invalid.Please enter a valid email.");
      case "invalide-phone-number-format":
        return TFormatException(
            "the provided phone nmber format is invalid. Please enter valid number.");
      case "invalide-date-format":
        return TFormatException(
            "the date format is invalid.Please enter a valid date.");
      case "invalide-url-format":
        return TFormatException(
            "the date url is invalid.Please enter a valid url.");
      case "invalide-credit-card-format":
        return TFormatException(
            "the credit card format is invalid please enter a valid credit card number");
      case "invalide-numeric-format":
        return TFormatException("the input should be a valid numeric format");
      default:
        return TFormatException("please check all the failed it should error ");
    }
  }
}
