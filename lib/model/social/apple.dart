import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../dprint.dart';

class AppleLogin {

  login(Function(String type, String id, String name, String photo) callback, Function(String) callbackError) async{

    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:

        dprint(result.credential.user); // id
        dprint(result.credential.fullName.givenName);
        dprint(result.credential.fullName.familyName);
        callback("apple", result.credential.user, "${result.credential.fullName.givenName} ${result.credential.fullName.familyName}", "");
        break;

      case AuthorizationStatus.error:
        dprint("Sign in failed: ${result.error.localizedDescription}");
        callbackError("${result.error.localizedDescription}");
        break;

      case AuthorizationStatus.cancelled:
        dprint('User cancelled');
        callbackError("login_canceled");
        break;
    }
  }
}