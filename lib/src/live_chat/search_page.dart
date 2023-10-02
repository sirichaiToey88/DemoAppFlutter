import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/helper/helper_function.dart';
import 'package:demo_app/src/live_chat/chat_page.dart';
import 'package:demo_app/src/pages/login/register/register.dart';
import 'package:demo_app/src/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  bool isAlreadyJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunction.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(border: InputBorder.none, hintText: "Search groups....", hintStyle: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearchMethod();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(40)),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                  )
                : groupList(),
          ],
        ),
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchByName(searchController.text).then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
          isAlreadyJoined = false;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              if (searchSnapshot!.docs[index]['groupName'] == userName) {}
              return groupTile(userName, searchSnapshot!.docs[index]['groupId'], searchSnapshot!.docs[index]['groupName'], searchSnapshot!.docs[index]['admin']);
            },
          )
        : Container();
  }

  // joinedOrNot(String userName, String groupId, String groupname, String admin) async {
  //   await DatabaseService(uid: user!.uid).isUserJoined(groupname, groupId, "jiradech saardnuam").then((value) {
  //     setState(() {
  //       isJoined = value;
  //     });
  //     print("isJoined => ${isJoined}");
  //   });
  // }

  Future<bool> joinedOrNot(String userName, String groupId, String groupname, String admin) async {
    bool isJoined = await DatabaseService(uid: user!.uid).isUserJoined(groupname, groupId, userName);
    // print("isJoined => $isJoined");
    return isJoined;
  }

  Widget groupTile(String userName, String groupId, String groupName, String admin) {
    return FutureBuilder<bool>(
      future: joinedOrNot(userName, groupId, groupName, admin),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // กรณีกำลังโหลดข้อมูล
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // กรณีเกิดข้อผิดพลาดในการโหลดข้อมูล
          return Text("Error: ${snapshot.error}");
        } else {
          // ตรวจสอบว่าผู้ใช้งานเข้าร่วมกลุ่มหรือไม่
          bool isJoined = snapshot.data ?? false;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                groupName.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text("Admin: ${getName(admin)}"),
            trailing: InkWell(
              onTap: () async {
                bool isJoining = await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
                if (isJoining) {
                  showSnackBar(context, "Successfully joined the group", Colors.green);
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(groupId: groupId, groupName: groupName, userName: userName),
                      ),
                    );
                  });
                } else {
                  setState(() {
                    showSnackBar(context, "Left the group $groupName", Colors.red);
                  });
                }
              },
              child: isJoined
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: const Text(
                        "Joined",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: const Text("Join Now", style: TextStyle(color: Colors.white)),
                    ),
            ),
          );
        }
      },
    );
  }

  Widget _groupTile(String userName, String groupId, String groupName, String admin, bool isAlreadyJoined) {
    // function to check whether user already exists in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            // showSnackBar(context, "Successfully joined he group", Colors.green);
            Future.delayed(const Duration(seconds: 2), () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Successfully joined the group"),
                backgroundColor: Colors.green,
              ));
            });

            Future.delayed(const Duration(seconds: 2), () {
              MaterialPageRoute(
                builder: (context) => ChatPage(groupId: groupId, groupName: groupName, userName: userName),
              );
            });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ChatPage(groupId: groupId, groupName: groupName, userName: userName),
            //   ),
            // );
          } else {
            setState(() {
              // isJoined = false;
              showSnackBar(context, "Left the group $groupName", Colors.red);
            });
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text("Join Now", style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }
}
