import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/src/live_chat/group_info.dart';
import 'package:demo_app/src/live_chat/messages_title.dart';
import 'package:demo_app/src/services/database_service.dart';
import 'package:demo_app/utils/textFromField/ChatInputField.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({super.key, required this.groupId, required this.groupName, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String adminName = "";
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getChatAndAdmin();
  }

  getChatAndAdmin() {
    DatabaseService().getChatsList(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        adminName = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(widget.groupName),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: adminName,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // ปิดคีย์บอร์ดเมื่อแตะที่พื้นที่นอก TextFormField
        },
        child: Column(
          children: [
            Expanded(
              child: chatMessage(),
            ),
            ChatInputField(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ),
          ],
        ),
      ),
    );
  }

  chatMessage() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) {
                  return MessageTitle(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe: widget.userName == snapshot.data.docs[index]['sender'],
                  );
                }),
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
