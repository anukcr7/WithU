import 'package:with_u/screens/authentication/signIn.dart';
import 'package:with_u/screens/homechat.dart';
import 'package:with_u/screens/viewblog.dart';
import 'package:with_u/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _pages = <Widget>[
    SOSscreen(),
    HomeBlog(),
    HomeChat(),
  ];

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedIconTheme: IconThemeData(color: Colors.indigo[900], size: 40),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // this will be set when a new tab is tapped
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alert',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Message',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTapTapped,
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          'WithU',
          style: TextStyle(color: Colors.deepPurple[50]),
        ),
        actions: [
          InkWell(
            onTap: () {
              AuthServies().logout().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.deepPurple[50],
                )),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pur7.png"), // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: _pages.elementAt(_currentIndex),
        ),
      ),
    );
  }
}

class SOSscreen extends StatefulWidget {
  @override
  _SOSscreenState createState() => _SOSscreenState();
}

class _SOSscreenState extends State<SOSscreen> {
  @override
  Widget build(BuildContext context) {
    final AuthServies aut = AuthServies();
    return Container(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    // Text(
                    //   'ALERT BUTTON',
                    //   style: TextStyle(color: Colors.indigoAccent[100]),
                    // ),
                    SizedBox(
                      height: 100,
                    ),
                    Builder(
                      builder: (context) => InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Alert SMS sent'),
                          ));
                        },
                        child: Center(
                          child: Image(
                              image: AssetImage("assets/images/soslo.png")), //
                        ),
                      ),
                    ),

                    // Center(
                    //   child: RawMaterialButton(
                    //     onPressed: () {},
                    //     elevation: 10.0,
                    //     fillColor: Colors.red,
                    //     padding: EdgeInsets.all(150.0),
                    //     shape: CircleBorder(),
                    //   ),
                    // ),
                    SizedBox(
                      height: 40,
                    ),

                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.indigo[50], shape: StadiumBorder()),
                        onPressed: () {},
                        icon: Icon(
                          Icons.person,
                          color: Colors.indigo[900],
                        ),
                        label: Text(
                          'Edit Contact',
                          style: TextStyle(color: Colors.indigo[900]),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
