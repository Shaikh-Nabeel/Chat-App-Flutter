import 'dart:async';

import 'package:chatapp/screens/ChatScreen.dart';
import 'package:chatapp/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/FirebaseController.dart';
import '../widgets/textWidgets/CustomTextWidget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with WidgetsBindingObserver {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> usersList = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _searchController.addListener(() {

      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () async {
        if (_searchController.text.isNotEmpty) {

          var list = await getSearchList(_searchController.text);
          usersList.clear();
          usersList.addAll(list);
          usersList.removeWhere((user) => user['email'] == FirebaseAuth.instance.currentUser!.email);

          setState(() {
            usersList;
          });

        }
      });
    });

    getUserChatList();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getUserChatList();
      print("on reumeeeeeeeeeeeeeeeeeeeeeeee");
    }
    print("on reumeeeeeeeeeeeeeeeeeeeeeeee out side bro");
  }

  void getUserChatList() async {
    usersList = await getChatList();
    setState(() {
      usersList;
    });
    print("here againnnn negga");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Chat",
            style: headingStyle1(color: Colors.white),
          ),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white,),
              onPressed: () async {
                await auth.signOut();
                Get.off(const LoginScreen());
              },
            ),
          ],
        ),
        body: GestureDetector(
          onTap: (){
            _focusNode.unfocus();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(
                      color: Colors.grey[400]!,
                      blurRadius: 3,
                      spreadRadius: 1
                    )]
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.grey[500]),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15)),
                    style: subHeading2(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          child: Icon(Icons.person, color: Colors.white,),
                        ),
                        title: Text(usersList[index]['email']),
                        titleTextStyle: headingStyle3(),
                        onTap: () async {
                          _searchController.text = "";
                          _focusNode.unfocus();
                          String name = usersList[index]['email'] as String;
                          await Get.to(
                            const ChatScreen(),
                            arguments: {
                              'id': usersList[index]['uid'],
                              'name': name
                            }
                          );
                          getUserChatList();
                        },
                      ),
                    );
                  }, itemCount: usersList.length,),
                ),
              ],
            ),
          ),
        ));
  }
}
