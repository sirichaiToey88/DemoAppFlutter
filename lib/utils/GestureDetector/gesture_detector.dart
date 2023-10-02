import 'package:demo_app/src/booking/main_screen/screen_booking_main_page.dart';
import 'package:demo_app/src/live_chat/list_groups.dart';
import 'package:demo_app/src/product/main_product.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/src/pages/login/login_page.dart';

class Category {
  final String title;
  final IconData iconData;
  final Widget pageRoute;

  Category(this.title, this.iconData, this.pageRoute);
}

List<Category> getCategoryList(String token, String userId) {
  return [
    Category('products'.tr(), Icons.shopping_bag, const ListProduct()),
    Category(
        'booking'.tr(),
        Icons.stadium_outlined,
        MainScreenBooking(
          token: token,
          userId: userId,
        )),
    Category('aboutUs'.tr(), Icons.info, const LoginPage()),
    Category('chat'.tr(), Icons.chat, const GroupsScreen()),
    Category('logOut'.tr(), Icons.logout, const LoginPage()),
    // เพิ่ม Category อื่นๆ ตามต้องการ
  ];
}

Widget buildCategoryTile(BuildContext context, Category category) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => category.pageRoute),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              category.iconData,
              size: 40,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            category.title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    ),
  );
}

// ใน Widget build หรือ ที่ต้องการนำไปใช้งาน
ListView buildListView(String token, String userId) {
  List<Category> categories = getCategoryList(token, userId);

  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: categories.length,
    itemBuilder: (context, index) {
      return buildCategoryTile(context, categories[index]);
    },
  );
}
