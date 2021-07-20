import 'package:with_u/screens/authentication/register.dart';
import 'package:with_u/screens/authentication/signIn.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      return (showSignIn = !showSignIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == true)
      return SignIn(tv: toggleView);
    else
      return Register(tv: toggleView);
  }
}
