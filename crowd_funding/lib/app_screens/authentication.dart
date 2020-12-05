import 'package:crowd_funding/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as auths;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

auths.FirebaseAuth auth = auths.FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

// a simple sialog to be visible everytime some error occurs
showErrDialog(BuildContext context, String err) {
  // to hide the keyboard, if it is still p
  FocusScope.of(context).requestFocus(new FocusNode());
  return showDialog(
    context: context,
    child: AlertDialog(
      title: Text("Error"),
      content: Text(err),
      actions: <Widget>[
        OutlineButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
    ),
  );
}

// many unhandled google error exist
// will push them soon
Future<auths.User> googleSignIn() async {
  GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    auths.AuthCredential credential = auths.GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    auths.UserCredential result = await auth.signInWithCredential(credential);

    auths.User user = await auth.currentUser;
    

    return Future.value(user);
  }
}

// instead of returning true or false
// returning user to directly access UserID
Future<auths.User> signin(
    String email, String password, BuildContext context) async {
  try {
    auths.UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    auths.User user = result.user;
    // return Future.value(true);
    return Future.value(user);
  } catch (e) {
    // simply passing error code as a message
    print(e.code);
    switch (e.code) {
      case "user-not-found":
        showErrDialog(context, e.code);
        break;
      case 'wrong-password':
        showErrDialog(context, e.code);
        break;
      
    }
    // since we are not actually continuing after displaying errors
    // the false value will not be returned
    // hence we don't have to check the valur returned in from the signin function
    // whenever we call it anywhere
    return Future.value(null);
  }
}

// change to Future<FirebaseUser> for returning a user
Future<auths.User> signUp(
    String email, String password, BuildContext context) async {
  try {
    auths.UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    auths.User user = result.user;
    return Future.value(user);
    // return Future.value(true);
  } catch (error) {
    switch (error.code) {
      case 'email-already-in-use':
        showErrDialog(context, "Email Already Exists");
        break;
    }
    return Future.value(null);
  }
}

Future<bool> signOutUser() async {
  auths.User user = await auth.currentUser;
  print(user.providerData[0].providerId);
  if (user.providerData[0].providerId == 'google.com') {
    await gooleSignIn.disconnect();
  }
  await auth.signOut();
  return Future.value(true);
}