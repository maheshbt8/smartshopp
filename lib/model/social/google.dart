import 'package:google_sign_in/google_sign_in.dart';
import '../dprint.dart';

class GoogleLogin {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  login(Function(String type, String id, String name, String photo) callback, Function(String) callbackError) async{
    try {
      dprint("Google Login Start...");
      await _googleSignIn.signIn();
      if (_googleSignIn.currentUser == null){
        callbackError("login_canceled");
        return;
      }
      dprint("${_googleSignIn.currentUser.email}");
      dprint("${_googleSignIn.currentUser.displayName}");
      dprint("${_googleSignIn.currentUser.photoUrl}");

      callback("google", _googleSignIn.currentUser.id, _googleSignIn.currentUser.displayName, _googleSignIn.currentUser.photoUrl);
    } catch (error) {
      dprint(error.toString());
      callbackError("$error");
    }
  }
}