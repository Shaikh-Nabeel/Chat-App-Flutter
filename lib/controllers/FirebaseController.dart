import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Future<void> insertUser(
    String email, String? username, String? displayUrl) async {
  await _firebaseFirestore.collection("users").doc(auth.currentUser?.uid).set({
    "email": email,
    "username": username,
    "displayUrl": displayUrl,
    "status": "unavailable"
  });
}

Future<List<Map<String, dynamic>>> getSearchList(String search) async {
  List<Map<String, dynamic>> userList = [];
  await _firebaseFirestore
      .collection("users")
      .where("email", isGreaterThanOrEqualTo: search)
      .where("email", isLessThanOrEqualTo: '$search\uf8ff')
      .get()
      .then((value) {
    userList = value.docs.map((doc) => {'uid': doc.id, ...doc.data()}).toList();
  });

  return userList;
}

Future<List<Map<String, dynamic>>> fetchChat(String chatUid) async {
  List<Map<String, dynamic>> listOfMaps = [];

  QuerySnapshot userChatSnapshot = await _firebaseFirestore
      .collection("chats")
      .doc(chatUid)
      .collection("userChat")
      .orderBy("timeStamp", descending: true)
      .get();

  listOfMaps = userChatSnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();

  return listOfMaps;
}

Future<void> sendChat(String chat, String chatUid) async {
  // DateTime.now().millisecondsSinceEpoch;
  List<Map<String, dynamic>> chatList = [];
  await _firebaseFirestore
      .collection("chats")
      .doc(chatUid)
      .collection("userChat")
      .doc()
      .set({
    "uid": auth.currentUser!.uid,
    "message": chat,
    "timeStamp": DateTime.now().millisecondsSinceEpoch
  });
}

Future<void> addToChatList(
    String currentUserId, String otherUserId, String otherUserEmail) async {
  final chatListRef = _firebaseFirestore
      .collection('users')
      .doc(currentUserId)
      .collection('chatList')
      .doc(otherUserId);

  final chatListRef2 = _firebaseFirestore
      .collection('users')
      .doc(otherUserId)
      .collection('chatList')
      .doc(currentUserId);

  await chatListRef.set({
    'uid': otherUserId,
    'email': otherUserEmail,
    'lastUpdated': FieldValue.serverTimestamp(),
    // Optional: for ordering by recency
  });

  await chatListRef2.set({
    'uid': currentUserId,
    'email': auth.currentUser!.email,
    'lastUpdated': FieldValue.serverTimestamp(),
    // Optional: for ordering by recency
  });
}

Future<List<Map<String, dynamic>>> getChatList() async {
  return _firebaseFirestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('chatList')
      .orderBy('lastUpdated', descending: true)
      .get()
      .then((value) {
    return value.docs.map((doc) => doc.data()).toList();
  });
}
