// ignore_for_file: unreachable_switch_case, unnecessary_string_escapes

class TFirebaseException implements Exception {
  final String code;

  TFirebaseException(this.code);

  String get message {
    switch (code) {
      case "unknown":
        return "An unknown firebase error occired.Please try again.";
      case "invalid-custom-token":
        return "The custom token format is incorrect. Please chekc your custom token";
      case "custom-token-mismatch":
        return "The custom  token corresponds to a different audience";
      case "user-disabled":
        return "The user account has been disabled. Please contact support for assistance.";
      case "user-not-found":
        return "Invalid login details. User not found.";
      case "wrong-password":
        return "Incorrect password. Please check your password and try again.";
      case "invalid-verification-code":
        return "Invalid verification code. Please enter a valid code.";
      case "invalid-verification-id":
        return "Invalid verification ID. Please require a new verification code.";
      case "quote-exceeded":
        return "Quote exceeded. Please try again later.";
      case "email-already-exists":
        return "The email address already exists. Please use a different email.";
      case "provider-already-linked":
        return "The account is already linked with another provider.";
      case "require-recent-login":
        return "This operation is sensitive and requires recent authentication. Please log in again.";
      case "credential-already-in-use":
        return "The credential is already associated with a different user account.";
      case "user-mismatch":
        return "The supplied credentials do not correspond to the previously signed-in user.";
      case "account-exists-with-different-credntial":
        return "An account already exists with the smal email but different sign-in credntials.";
      case "operation-not-allowed":
        return "This operation is not allowed. Contact support for assistance.";
      case "expired-action-code":
        return "the action code has expired. Please request a new action code.";
      case "invalid-action-code":
        return "The action code is invalid. Please check the code and try again";
      case "missing-action-code":
        return "The action code is missing. Please provide a valid action codes";
      case "user-token-expired":
        return "The user\'s token has expired, and authentication is reuiqred . Please sign in again";
      case "user-not-found":
        return "No user found for the given email or UID";
      case "user-invalid-credntial":
        return "The supplied credntal is malformed or has has expired";
      default:
        return "Unknown error occurred with code: $code";
    }
  }
}
