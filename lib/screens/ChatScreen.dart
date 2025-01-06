import 'package:chatapp/controllers/FirebaseController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/textWidgets/CustomTextWidget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final argument = Get.arguments;
  List<Map<String, dynamic>> chatList = [];
  bool isLoading = false;
  final TextEditingController _chatController = TextEditingController();
  late String chatUid;

  @override
  initState()  {
    super.initState();
    getChats();
  }

  Future<void> getChats() async {

    if ((argument['id'] as String).compareTo(auth.currentUser!.uid) < 0) {
      chatUid = (argument['id'] as String) + auth.currentUser!.uid;
    } else {
      chatUid = auth.currentUser!.uid + (argument['id'] as String);
    }

    setState(() {
      isLoading = true;
    });
    chatList = await fetchChat(chatUid);

    addToChatList(auth.currentUser!.uid, argument['id'], argument['name']);

    setState(() {
      isLoading = false;
      chatList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person, // Short icon
                size: 35, // Icon size
                color: Colors.indigoAccent,
              ),
            ),
            const SizedBox(width: 8), // Space between icon and title
            Text(
              "${argument['name'].substring(0, argument['name'].indexOf("@"))}",
              style: subHeading1(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          chatLayout(),
          SizedBox(height: 5,),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintStyle: subHeading2(color: Colors.grey.shade700),
                      hintText: 'Type a message',
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    style: subHeading1(),
                  ),
                ),
              ),
              SizedBox(width: 6,),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(onPressed: () async {
                  if(_chatController.text.trim() == "") return;
                  sendChat(_chatController.text.trim(), chatUid);
                  chatList = await fetchChat(chatUid);
                  _chatController.text = "";
                  setState(() {
                    chatList;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Send", style: subHeading2(color: Colors.white),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget chatLayout(){
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Align(
              alignment: chatList[index]['uid'] == auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft, // Align chat bubble to right
              child: Container(
                // width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                decoration: chatList[index]['uid'] == auth.currentUser!.uid ? BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ) : BoxDecoration(
                  color: Colors.blueGrey, // Chat bubble color
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  chatList[index]["message"],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
