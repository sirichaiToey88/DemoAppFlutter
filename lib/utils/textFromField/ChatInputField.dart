import 'package:demo_app/src/services/database_service.dart';
import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatInputField({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> with SingleTickerProviderStateMixin {
  bool _isTyping = false;
  TextEditingController messageController = TextEditingController();
  late AnimationController _animationController;
  String _typingText = '';
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // ปิดคีย์บอร์ดเมื่อแตะที่พื้นที่นอก TextFormField
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          height: _isTyping ? 80 : 80, // กำหนดความสูงตามการพิมพ์ข้อความ
          color: Colors.grey[700],
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: TextFormField(
                    maxLines: null,
                    controller: messageController,
                    onChanged: (text) {
                      setState(() {
                        _isTyping = text.isNotEmpty;
                        if (_isTyping) {
                          _dotCount++;
                          if (_dotCount > 3) {
                            _dotCount = 0;
                          }
                          _typingText = '.' * _dotCount;
                        } else {
                          _typingText = '';
                          _dotCount = 0;
                        }
                      });
                    },
                    onFieldSubmitted: (_) {
                      setState(() {
                        _isTyping = false;
                        _typingText = '';
                        _dotCount = 0;
                      });
                      sendMessage();
                    },
                    onEditingComplete: () {
                      setState(() {
                        _isTyping = false;
                        _typingText = '';
                        _dotCount = 0;
                      });
                      sendMessage();
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      suffixIcon: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 5),
                            child: Text(
                              _typingText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  sendMessage();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
        _isTyping = false;
        _typingText = '';
        _dotCount = 0;
      });
    }
  }
}
