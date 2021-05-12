import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  getUserByUserName(String userName) async {
    return await _firestore
        .collection("users")
        .where("name", isEqualTo: userName)
        .get();
  }

  getUserByEmail(String email) async {
    return await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserInfo(userMap) {
    _firestore.collection("users").add(userMap);
  }

  createChatRoom(
    String chatRoomId,
    chatRoomMap,
  ) {
    _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((onError) {
      print("from createChatRoom ${onError.toString()}");
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap);
  }

  getConversationMessages(String chatRoomId) async {
    return await _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time")
        .snapshots();
  }

  getChatRoom(String userName) async {
    return await _firestore
        .collection("chatRoom")
        .orderBy("time", descending: true)
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
