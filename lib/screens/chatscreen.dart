import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:with_u/helper/sharedprefhelp.dart';
import 'package:with_u/services/database.dart';

class ChatScreen extends StatefulWidget {
  final String username, name;
  ChatScreen(this.username, this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = "";
  Stream msgStream;
  String myName, myProfilePic, myUserName, myEmail;
  TextEditingController msgTextEditingController = TextEditingController();

  getMyInfoFromSP() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();

    chatRoomId = getChatRoomIdbyUsernames(widget.username, myUserName);
  }

  getChatRoomIdbyUsernames(String a, String b)

  ///a b usernames
  {
    //order issue nah create kre that's y this function
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else
      return "$a\_$b";
  }

  addMessage(bool sendClicked) {
    if (msgTextEditingController.text != "") {
      String message = msgTextEditingController.text;
      var lastmsgTs = DateTime.now();
      Map<String, dynamic> msgInfoMap = {
        "message": message,
        "SendBy": myUserName,
        "ts": lastmsgTs,
        "imgUrl": myProfilePic,
      };

      //messageid
      if (messageId == "") {
        messageId = randomAlphaNumeric(12); //key genetrating for msgid
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, msgInfoMap)
          .then((value) {
        Map<String, dynamic> lastMsgInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastmsgTs,
          "lastMessageSendBy": myUserName,
        };

        DatabaseMethods().updatelastMsgSend(chatRoomId, lastMsgInfoMap);
        if (sendClicked) {
          //remove msg in text field
          msgTextEditingController.text = "";
          //make msg id blank to get regenrated on next sg send
          messageId = "";
        }
      });
    }
  }

  Widget chatMsgTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        sendByMe ? Radius.circular(24) : Radius.circular(0),
                    bottomRight:
                        sendByMe ? Radius.circular(0) : Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                  color: sendByMe ? Colors.indigo[200] : Colors.indigo[900],
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 3,
              )
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget chatmsgs() {
    return StreamBuilder(
      //jab data stream ka form mai ho toh streambuilder use karo //stream is a flow of data//how it helps is if there is change in any data for our db it will immediately notify the local so we can update that
      stream: msgStream,
      builder: (context, snapshot) {
        //snapshot is data we got form the above stream
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 65, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMsgTile(ds["message"], myUserName == ds["SendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    msgStream = await DatabaseMethods().getChatRoomMsgs(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSP();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.indigo[900],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Stack(
          //use to align 2 particular widget one above the other
          children: [
            chatmsgs(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.grey[600].withOpacity(0.8),
                    border: Border.all(
                      color: Colors.grey[600].withOpacity(0.8),
                      width: 0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(250))),
                //color: Colors.grey[600].withOpacity(0.8),
                //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: msgTextEditingController,
                      onChanged: (value) {
                        addMessage(false);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            //fontWeight: FontWeight.w500
                          )),
                    )),
                    GestureDetector(
                        onTap: () {
                          addMessage(true);
                        },
                        child: Icon(Icons.send, color: Colors.white))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
