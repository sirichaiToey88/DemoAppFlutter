import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //reference for collention
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");

  //Update use data
  Future savingUserData(String fullname, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullname,
      "email": email,
      "groups": [],
      "profile": "",
      "uid": uid,
    });
  }

  //getting User data

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get User groups
  getUserGroup() async {
    return userCollection.doc(uid).snapshots();
  }

  //create group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "gropIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion([
        "${uid}_$userName"
      ]),
      "groupId": groupDocumentReference.id,
    });
    DocumentReference userDocomentReference = userCollection.doc(uid);
    return await userDocomentReference.update({
      "groups": FieldValue.arrayUnion([
        "${groupDocumentReference.id}"
      ])
    });
  }

  //getting the chats
  getChatsList(String groupId) async {
    return groupCollection.doc(groupId).collection("messages").orderBy("time", descending: true).snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  //getting group member
  getMembersOfTheGroup(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  //searchByName(String groupName) {
  // return groupCollection.where("groupName", isGreaterThan: groupName).get();
  //}
  Future<QuerySnapshot<Map<String, dynamic>>> searchByName(String groupName) async {
    return await groupCollection.where("groupName", isGreaterThan: groupName).get() as QuerySnapshot<Map<String, dynamic>>;
  }

  Future<Map<String, bool>> getJoinedGroups(String userName) async {
    QuerySnapshot<Object?> snapshot = await groupCollection.get();
    Map<String, bool> joinedGroups = {};
    for (var doc in snapshot.docs) {
      String groupId = doc.id;
      bool isJoined = await DatabaseService(uid: uid).isUserJoined(doc['groupName'], groupId, userName);
      joinedGroups[groupId] = isJoined;
    }
    return joinedGroups;
  }

  // function -> bool
  Future<bool> isUserJoined(String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future<bool> toggleGroupJoin(String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove([
          "${groupId}_$groupName"
        ])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove([
          "${uid}_$userName"
        ])
      });
      return false; // ออกจากกลุ่ม
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion([
          "${groupId}_$groupName"
        ])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion([
          "${uid}_$userName"
        ])
      });
      return true; // เข้าร่วมกลุ่ม
    }
  }

// สร้างฟังก์ชัน async ที่ query ข้อมูลของ Admin จาก collection ที่เก็บข้อมูล Admins
  Future<String> getAdminName(String adminId) async {
    List<String> parts = adminId.split('_');
    String result = '';
    if (parts.length > 1) {
      result = parts[0];
      //print(result); // แสดงผลข้อความก่อน _
    }

    final adminDoc = await FirebaseFirestore.instance.collection('users').doc(result).get();
    if (adminDoc.exists) {
      final adminData = adminDoc.data() as Map<String, dynamic>;
      final adminName = adminData['fullName'] ?? '';
      return adminName;
    }
    return ''; // หรือให้คืนค่าอื่นที่ต้องการเมื่อไม่พบข้อมูล Admin
  }

  Future<bool> isUserMemberOfGroup(String groupId, String uidKey) async {
    // print("fadafd ${uidKey}");
    DocumentSnapshot<Map<String, dynamic>> groupSnapshot = await FirebaseFirestore.instance.collection('groups').doc(groupId).get();
    if (groupSnapshot.exists) {
      Map<String, dynamic>? groupData = groupSnapshot.data();
      List<String> members = groupData?['members'] != null ? List<String>.from(groupData?['members']) : [];
      // print("members.contains(uid) ${members.contains(uid)}");
      return members.contains(uidKey);
    }
    return false;
  }

  Future _toggleGroupJoin(String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove([
          "${groupId}_$groupName"
        ])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove([
          "${uid}_$userName"
        ])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion([
          "${groupId}_$groupName"
        ])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion([
          "${uid}_$userName"
        ])
      });
    }
  }

  //send Messages
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString()
    });
  }

  Future joinGroup(String groupId, String userName, String groupName) async {
    // อัปเดตข้อมูลในฐานข้อมูลของผู้ใช้
    await userCollection.doc(uid).update({
      "groups": FieldValue.arrayUnion([
        "${groupId}_$groupName"
      ])
    });

    // อัปเดตข้อมูลในฐานข้อมูลของกลุ่ม
    await groupCollection.doc(groupId).update({
      "members": FieldValue.arrayUnion([
        "${uid}_$userName"
      ])
    });
  }

  Future leaveGroup(String groupId, String userName, String groupName) async {
    // อัปเดตข้อมูลในฐานข้อมูลของผู้ใช้
    await userCollection.doc(uid).update({
      "groups": FieldValue.arrayRemove([
        "${groupId}_$groupName"
      ])
    });

    // อัปเดตข้อมูลในฐานข้อมูลของกลุ่ม
    await groupCollection.doc(groupId).update({
      "members": FieldValue.arrayRemove([
        "${uid}_$userName"
      ])
    });
  }
}
