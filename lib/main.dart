import 'package:firebase_core/firebase_core.dart';
import 'package:with_u/models/theUser.dart';
import 'package:with_u/screens/authentication/authentication.dart';
import 'package:with_u/screens/authentication/signIn.dart';
import 'package:with_u/screens/home.dart';
import 'package:with_u/screens/wrapper.dart';
import 'package:with_u/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  // Widget build(BuildContext context) {
  //    return MaterialApp(
  //     title: "WithU",
  //     home: FutureBuilder(
  //         future: AuthServies().getCurrentUser(),
  //         builder: (context,
  //                 AsyncSnapshot<dynamic>
  //                     snapshot) //async snapshot is data which we got from future: function;
  //             {
  //           if (snapshot.hasData)
  //             return Home();
  //           else
  //             return SignIn();
  //         }),
  //   );
  // }

  Widget build(BuildContext context) {
    var streamProvider = StreamProvider<TheUser>.value(
      catchError: (_, __) => null,
      value: AuthServies().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
    return streamProvider;
  }
}
