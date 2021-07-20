import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:with_u/helper/sharedprefhelp.dart';
import 'package:with_u/models/theUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_u/screens/home.dart';
import 'package:with_u/services/database.dart';

class AuthServies {
  //create an instance that will allow to communicate with backend

  //property no gonna change(final) type() _ means private
  final FirebaseAuth aut = FirebaseAuth.instance;
  // create user object based on firebaseUser

  TheUser _theUserFromFirebaseuser(User user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  getCurrentUser() async {
    return aut.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);
    User userDetails = result.user;

    if (result != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails.email);
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper()
          .saveUserName(userDetails.email?.replaceFirst(RegExp(r"\.[^]*"), ""));
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL);

      Map<String, dynamic> userInfoMap = {
        "userid": userDetails.uid,
        "email": userDetails.email,
        "username": userDetails.email?.replaceFirst(RegExp(r"\.[^]*"), ""),
        "name": userDetails.displayName,
        "profileUrl": userDetails.photoURL,
      };
      DatabaseMethods().addUserinfotodb(userDetails.uid, userInfoMap).then((s) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  //auth chnage user stream
  Stream<TheUser> get user {
    return aut
        .authStateChanges()
        // .map((FirebaseUser user) => _theUserFromFirebaseuser(user));
        .map(_theUserFromFirebaseuser);
  }

  //sign in anom
  //type of thing that return future
  Future signInAnom() async {
    try {
      UserCredential result = await aut.signInAnonymously();
      User user = result.user;
      return _theUserFromFirebaseuser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in email
  Future signInEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await aut.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _theUserFromFirebaseuser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign up/ register with email password
  Future resgisterEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await aut.createUserWithEmailAndPassword(
          email: email, password: password);
      User userDetails = result.user;
      //return _theUserFromFirebaseuser(user);

      if (result != null) {
        SharedPreferenceHelper().saveUserEmail(userDetails.email);
        SharedPreferenceHelper().saveUserId(userDetails.uid);
        SharedPreferenceHelper().saveUserName(
            userDetails.email?.replaceFirst(RegExp(r"\.[^]*"), ""));
        SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL);

        Map<String, dynamic> userInfoMap = {
          "userid": userDetails.uid,
          "email": userDetails.email,
          "username": userDetails.email?.replaceFirst(RegExp(r"\.[^]*"), ""),
          "name": userDetails.email?.replaceAll("@gmail.com", ""),
          "profileUrl":
              'https://i1.wp.com/researchictafrica.net/wp/wp-content/uploads/2016/10/default-profile-pic.jpg?ssl=1',
        };
        DatabaseMethods()
            .addUserinfotodb(userDetails.uid, userInfoMap)
            .then((s) {
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => Home()));
          return _theUserFromFirebaseuser(userDetails);
        });
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      return await aut.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
