import 'package:with_u/models/theUser.dart';
import 'package:with_u/screens/authentication/authentication.dart';
import 'package:with_u/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theuser = Provider.of<TheUser>(context);
    if (theuser == null)
      return Authentication();
    else
      return Home();
  }
}
