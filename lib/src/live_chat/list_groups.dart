import 'package:demo_app/helper/helper_function.dart';
import 'package:demo_app/src/live_chat/chat_page.dart';
import 'package:demo_app/src/live_chat/search_page.dart';
import 'package:demo_app/src/pages/login/register/register.dart';
import 'package:demo_app/src/services/database_service.dart';
import 'package:demo_app/utils/textFromField/text_from_field_text_no_validate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  bool _isloding = false;
  final _groupNameController = TextEditingController();
  String? _groupNameError;
  String username = "";
  String uidKey = "";
  String uidKeyName = "";
  User? user;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunction.getUserNameSF().then((value) {
      setState(() {
        username = value!;
      });
    });

    await HelperFunction.getUserIdSF().then((value) {
      setState(() {
        uidKey = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('List of Groups'),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 8),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('groups').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final groups = snapshot.data!.docs;
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final groupData = groups[index].data() as Map<String, dynamic>;
                // final userName = username;
                final groupId = groupData['groupId'] ?? '';
                final groupName = groupData['groupName'] ?? '';
                final adminId = groupData['admin'] ?? '';
                String adminName = '';
                List<String> parts = adminId.split('_');

                if (parts.length > 1) {
                  adminName = parts[1];
                }
                return FutureBuilder<bool>(
                  future: DatabaseService().isUserMemberOfGroup(groupId, '${uidKey}_$username'),
                  builder: (context, snapshot) {
                    bool isJoin = snapshot.data ?? false;
                    return GroupListItem(
                      userName: username,
                      groupId: groupId,
                      groupName: groupName,
                      admin: adminName,
                      isJoin: isJoin,
                      user: user!.uid,
                    );
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return CircularProgressIndicator(); // หรือให้แสดงอะไรก็ได้ในช่วงรอ
                    // } else if (snapshot.hasError) {
                    //   return Text('Error loading admin data');
                    // } else {
                    //   bool isJoin = snapshot.data ?? false;
                    //   return GroupListItem(
                    //     userName: username,
                    //     groupId: groupId,
                    //     groupName: groupName,
                    //     admin: adminName,
                    //     isJoin: isJoin,
                    //   );
                    // }
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // แสดง Alert ฟอร์มกรองข้อมูลกลุ่ม
          _showFilterDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Groups'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFromFieldNormal(
                  errorMessage: _groupNameError,
                  controller: _groupNameController,
                  lableText: 'Group Name',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return null;
                  },
                ),
              ]),
              actions: [
                TextButton(
                  onPressed: () {
                    // ปิด Alert
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_groupNameController.text.isEmpty) {
                      setState(() {
                        _groupNameError = 'Please enter your group name.';
                      });
                    } else {
                      setState(() {
                        _isloding = true;
                      });

                      // ทำการสร้างกลุ่ม และตรวจสอบเงื่อนไขสำหรับการจัดการ Loading
                      try {
                        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(username, FirebaseAuth.instance.currentUser!.uid, _groupNameController.text);
                        setState(() {
                          _isloding = false;
                          _groupNameController.clear();
                        });
                      } catch (e) {
                        // กรณีเกิดข้อผิดพลาดในการสร้างกลุ่ม
                        setState(() {
                          _isloding = false;
                          _groupNameError = 'Error: Failed to create group.';
                        });
                      }

                      Navigator.of(context).pop();
                    }
                  },
                  child: _isloding ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class GroupListItem extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final String admin;
  final bool isJoin;
  final String user;

  const GroupListItem({
    super.key,
    required this.userName,
    required this.groupId,
    required this.groupName,
    required this.admin,
    required this.isJoin,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Text(
            groupName.substring(0, 1).toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 30),
          ),
        ),
        title: Text(
          groupName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Admin: ${admin}',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14.0,
          ),
        ),
        trailing: !isJoin
            ? ElevatedButton(
                onPressed: () async {
                  // ระบบ Join กลุ่ม
                  bool isJoining = await DatabaseService(uid: user).toggleGroupJoin(groupId, userName, groupName);
                  if (isJoining) {
                    showSnackBar(context, "Successfully joined the group", Colors.green);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupsScreen(),
                      ),
                    );
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ChatPage(
                  //       groupId: groupId,
                  //       groupName: groupName,
                  //       userName: userName,
                  //     ),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Join',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  // ระบบ Join กลุ่ม
                  // เพิ่มโค้ดตามความต้องการ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        groupId: groupId,
                        groupName: groupName,
                        userName: userName,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
      ),
    );
  }
}
