import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String? userId;
  final String appId;

  const ChatPage({super.key, this.userId, required this.appId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Add a variable to store the channel URL
  final String channelUrl = 'https://api-D94E93FF-DA40-4058-8496-BC2030FCD342.sendbird.com/v3/open_channels';

  @override
  void initState() {
    super.initState();
    // Initialize the SendbirdChat SDK with your Application ID.
    SendbirdChat.init(appId: 'D94E93FF-DA40-4058-8496-BC2030FCD342');

    // Connect to the Sendbird server with a User ID.
    SendbirdChat.connect("sendbird_desk_agent_id_37a11775-c2fb-4a87-9735-dcc62e97f25c", accessToken: "abd07f17e0b906e7d5077b12e8b75697ee267fcc");

    // Call the function to enter the Open Channel
    // enterOpenChannel();
  }

  // Function to enter the Open Channel
  void getListChannel() async {
    try {
      final query = GroupChannelListQuery()
        ..limit = 1
        ..userIdsIncludeFilter = "Sirichai" as List<String>;
      List<GroupChannel> channels = (await query.next()).cast<GroupChannel>();
      if (channels.isEmpty) {
      } else {}

      //get message

      //set the data
      setState(() {});
      print('Entered Open Channel successfully!');
    } catch (e) {
      print('Error entering Open Channel: $e');
    }
  }

  // Function to enter the Open Channel
  void enterOpenChannel() async {
    try {
      final openChannel = await OpenChannel.createChannel(OpenChannelCreateParams()..name = "test");
      await openChannel.enter();
      print('Entered Open Channel successfully!');
    } catch (e) {
      print('Error entering Open Channel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: Center(
        child: Text('This is the chat page for user: ${widget.userId}'),
      ),
    );
  }
}
