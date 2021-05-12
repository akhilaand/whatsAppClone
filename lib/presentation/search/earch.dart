import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/presentation/chatScreen/chatScreen.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  QuerySnapshot searchSnapShot;
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  TextEditingController _searchController = TextEditingController();
  Widget searchList() {
    return searchSnapShot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapShot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapShot.docs[index].get("name"),
                mail: searchSnapShot.docs[index].get("email"),
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("chatApp"),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green,
            height: 70,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(hintText: "search...."),
                    controller: _searchController,
                  )),
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        initiateSearch();
                      })
                ],
              ),
            ),
          ),
          searchList()
        ],
      ),
    );
  }

  initiateSearch() {
    return _dataBaseMethods
        .getUserByUserName(_searchController.text)
        .then((val) {
      setState(() {
        searchSnapShot = val;
      });
    });
  }
}

class SearchTile extends StatelessWidget {
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  final String userName;
  final String mail;
  SearchTile({Key key, this.userName, this.mail});
  String chatRoomId;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  mail,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                // createChatRoomAndStartConversation(
                //     userName: userName, context: context);
                chatRoomId = getChatRoomId(userName, Constants.myName);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              chatRoomId: chatRoomId,
                              userName: userName,
                            )));
              },
              child: Container(
                height: 50,
                width: 60,
                child: Center(child: Text("Message")),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            )
          ],
        ),
      ),
    );
  }

  createChatRoomAndStartConversation({String userName, context}) {
    if (userName != Constants.myName) {
      print("pressed $userName ${Constants.myName}");
      chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      _dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    } else {
      print("same name");
    }
  }

  //to get same id for two users
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
