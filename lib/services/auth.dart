import 'package:chat_app/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  UserDetails _userFromFirebase(User user) {
    return user != null ? UserDetails(userId: user.uid) : null;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User _firebaseUser = result.user;
      return _userFromFirebase(_firebaseUser);
    } catch (e) {
      print("error from auth ${e}");
    }
  }

  Future signUpWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User _firebaseUser = result.user;
      return _userFromFirebase(_firebaseUser);
    } catch (e) {
      print("error from ${e}");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
