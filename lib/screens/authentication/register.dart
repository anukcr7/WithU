import 'package:flutter/material.dart';
import 'package:with_u/services/auth.dart';
import 'package:with_u/shared/constant.dart';
import 'package:with_u/shared/loading.dart';

class Register extends StatefulWidget {
  //neeche nhi kiya because it's a constructor for sate widget;
  //we are passing value inside the widget itself no the state object
  final Function tv;
  Register({this.tv});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServies _aut = AuthServies();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Sign up to WithU'),
              backgroundColor: Colors.indigo[900],
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //this. nhi use krnge since it refers to state objetc instead use widget mtlb upar jo tv widget jijsmai bnya usko refer kr rhe hai;
                    widget.tv();
                  },
                  label: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              //    decoration: BoxDecoration(
              //    gradient: LinearGradient(
              //    begin: Alignment.topRight,
              //  end: Alignment.bottomLeft,
              //colors: [
              //Colors.black,
              // Colors.red[600],
              // ],
              // ),
              // ),
              //  child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey, //trace state of our farm n help validate it
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Image(
                            image: AssetImage("assets/images/front.png")), //
                      ),
                      // SizedBox(height: 20.0),
                      TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enetr an email id' : null,
                          onChanged: (val) {
                            setState(() {
                              return (email = val);
                            });
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) => val.length < 6
                              ? 'Enter a password with minimun 6 characters'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              return (password = val);
                            });
                          }),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        color: Colors.indigo[900],
                        child: Text('Register',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _aut
                                .resgisterEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please enter a valid email';
                                return error;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
