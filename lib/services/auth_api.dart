import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/user_api.dart';

class AuthApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream Auth changes (Only has uid)
  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => _toUser(user));
  }

  User _toUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // Google Sign-in
  Future<void> signInGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;

      // Create a document in the User collection if doesn't exists.
      if (!await UserApi(uid: user.uid).userExists()) {
        await UserApi(uid: user.uid)
            .setUserData(user.email, null, user.displayName, user.photoUrl, "1");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  // Sign-in
  Future<void> signInEmail(email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      return Future.error(e);
    }
  }

  // Register
  Future<void> registerEmail(email, password, name, profilePhoto, userType) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await UserApi(uid: user.uid)
          .setUserData(email, password, name, profilePhoto, userType);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      return Future.error(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return Future.error(e);
    }
  }
}
