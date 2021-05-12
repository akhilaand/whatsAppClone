import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/presentation/search/earch.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  String userName;
  String chatRoomId;
  ChatScreen({this.chatRoomId, this.userName});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream chatMessageStream;
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  SearchTile _searchTile = SearchTile();
  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index].get("message"),
                    isSendByMe: snapshot.data.docs[index].get("sendBy") ==
                        Constants.myName,
                  );
                });
          } else {
            print("data is null from snapshot from chatScreen");
            return Container();
          }
        });
  }

  sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": _messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      _dataBaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      _messageController.text = "";
    }
  }

  TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _dataBaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      if (value != null) {
        setState(() {
          print("hii");
          chatMessageStream = value;
        });
      } else {
        print("value is null from intistate on chatscreen");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("name"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: chatMessageList()),
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
                      decoration:
                          InputDecoration(hintText: "type your message"),
                      controller: _messageController,
                    )),
                    IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          sendMessage();
                          _searchTile.createChatRoomAndStartConversation(
                              context: context, userName: widget.userName);
                          print(chatMessageStream.length.toString());
                        })
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

class MessageTile extends StatelessWidget {
  final bool isSendByMe;
  final String message;
  const MessageTile({this.message, this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isSendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: isSendByMe ? Colors.grey.shade500 : Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                message,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
