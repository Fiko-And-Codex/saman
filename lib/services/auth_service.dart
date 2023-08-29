import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saman/utilities/firebase.dart';

class AuthService {
  User getCurrentUser() {
    User user = auth.currentUser!;

    return user;
  }

  Future<bool> loginUser({String? email, String? password}) async {
    var res = await auth.signInWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );

    if (res.user != null) {

      return true;
    } else {

      return false;
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    var res = await usersRef.where('username', isEqualTo: username).get();

    if (res.docs.isEmpty) {

      return false;
    } else {

      return true;
    }
  }


  Future<bool> createUser({String? email, String? password, String? username, String? country, User? user}) async {
    var res = await auth.createUserWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );
    if (res.user != null) {
      await saveUserToFirestore(username!, res.user!, email!, country!);

      return true;
    } else {

      return false;
    }
  }



  saveUserToFirestore(String username, User user, String email, String country) async {
    await usersRef.doc(user.uid).set({
      'id': user.uid,
      'username': username,
      'email': email,
      'country': country,
      'photoUrl': user.photoURL ?? '',
      'bio': '',
      'followers': 0,
      'following': 0,
      'posts': 0,
      'favorites': 0,
      'createdAt': Timestamp.now(),
      'gender': '',
      'type': 'public',
      'saved': 0,
      'hashtags': {'nature' : 10, 'city' : 10},
      'verified': false,
      'profession': '',
      'link': '',
      'name': '',
    });
  }

  forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  logOut() async {
    await auth.signOut();
  }

  Future<bool> checkUsername(String username) async {
    var res = await usersRef.where('username', isEqualTo: username).get();

    if (res.docs.isEmpty) {

      return true;
    } else {

      return false;
    }
  }

  String handleFirebaseAuthError(String e) {
    if (e.contains("ERROR_WEAK_PASSWORD")) {

      return "Şifre çok zayıf.";
    } else if (e.contains("invalid-email")) {

      return "Geçersiz e-posta.";
    } else if (e.contains("ERROR_EMAIL_ALREADY_IN_USE") ||
        e.contains('email-already-in-use')) {

      return "E-posta adresi zaten başka bir hesap tarafından kullanılıyor.";
    } else if (e.contains("ERROR_NETWORK_REQUEST_FAILED")) {

      return "Ağ hatası oluştu!";
    } else if (e.contains("ERROR_USER_NOT_FOUND") ||
        e.contains('firebase_auth/user-not-found')) {

      return "Geçersiz Giriş bilgileri.";
    } else if (e.contains("ERROR_WRONG_PASSWORD") ||
        e.contains('wrong-password')) {

      return "Geçersiz Giriş bilgileri.";
    } else if (e.contains('firebase_auth/requires-recent-login')) {

      return 'Bu işlem hassastır ve güncel GİRİŞ doğrulaması gerektirir.'
          ' Bu isteği tekrar denemeden önce tekrar giriş yapın.';
    } else {

      return e;
    }
  }

}
