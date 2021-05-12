import 'dart:ui';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/presentation/chatScreen/chatScreen.dart';
import 'package:chat_app/presentation/login/login.dart';
import 'package:chat_app/presentation/search/earch.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthMethods _authMethods = AuthMethods();
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  Stream chatRoomStream;
  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomListTile(
                    username: snapshot.data.docs[index]
                        .get("chatRoomId")
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoom: snapshot.data.docs[index].get("chatRoomId"),
                  );
                });
          } else {
            return Container();
          }
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    callFunctions();
    print("from init satte${Constants.myName}");

    super.initState();
  }

  callFunctions() async {
    await getUserInfo();
    getMessageStream();
  }

  getMessageStream() {
    _dataBaseMethods.getChatRoom(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _authMethods.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              })
        ],
      ),
      body: Column(
        children: [chatRoomList()],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print(Constants.myName);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchPage()));
      }),
    );
  }
}

class ChatRoomListTile extends StatelessWidget {
  final String username;
  final String chatRoom;
  ChatRoomListTile({this.username, this.chatRoom});
  SearchTile _searchTile = SearchTile();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      chatRoomId: chatRoom,
                      userName: username,
                    )));
      },
      child: Container(
        height: 60,
        color: Colors.red,
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Center(
                child: Text(
                  "${username.substring(0, 1)}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(username)
          ],
        ),
      ),
    );
  }
}
