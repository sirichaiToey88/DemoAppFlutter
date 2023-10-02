import 'package:flutter/material.dart';

class MessageTitle extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  const MessageTitle({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
  }) : super(key: key);

  @override
  State<MessageTitle> createState() => _MessageTitleState();
}

class _MessageTitleState extends State<MessageTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sentByMe ? 0 : 24,
        right: widget.sentByMe ? 24 : 0,
      ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        margin: widget.sentByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          color: widget.sentByMe ? Theme.of(context).primaryColor : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
