import 'package:with_u/services/crud.dart';
import 'package:with_u/screens/upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_u/services/database.dart';

class HomeBlog extends StatefulWidget {
  @override
  _HomeBlogState createState() => _HomeBlogState();
}

class _HomeBlogState extends State<HomeBlog> {
  CrudMethods crudMethods = new CrudMethods();
  Stream blogsroom;

  @override
  void initState() {
    crudMethods.getData().then((result) {
      querySnapshot = result;
      setState(() {});
    });
    super.initState();
  }

  QuerySnapshot querySnapshot;

  Widget _showDrivers() {
    //check if querysnapshot is null
    if (querySnapshot != null) {
      return ListView.builder(
        primary: false,
        itemCount: querySnapshot.docs.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, i) {
          return BlogTile(
            author: querySnapshot.docs[i]["author"],
            desc: querySnapshot.docs[i]["desc"],
            imgUrl: querySnapshot.docs[i]["imgUrl"],
            title: querySnapshot.docs[i]["title"],
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: querySnapshot != null
              ? _showDrivers()
              : Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[900],
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBlog()));
        },
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imgUrl, title, desc, author;
  BlogTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.desc,
      @required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      //color: Colors.grey[300],
      margin: EdgeInsets.only(bottom: 5, right: 5, left: 5, top: 5),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                height: 400,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 4),
          Text(
            '$desc ~$author',
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
