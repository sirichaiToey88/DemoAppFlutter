import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/helper/helper_function.dart';
import 'package:demo_app/src/services/auth_service.dart';
import 'package:demo_app/src/services/database_service.dart';
import 'package:demo_app/utils/GestureDetector/gesture_detector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsernameProvider extends InheritedWidget {
  final String username;
  final Widget child;

  const UsernameProvider({super.key, required this.username, required this.child}) : super(child: child);

  static UsernameProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UsernameProvider>();
  }

  @override
  bool updateShouldNotify(covariant UsernameProvider oldWidget) {
    return username != oldWidget.username;
  }
}

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  @override
  void dispose() {
    if (mounted) {
      gettingUserData();
    }
    super.dispose();
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailSF().then((value) {
      if (mounted) {
        setState(() {
          email = value!;
        });
      }
    });
    await HelperFunction.getUserNameSF().then((value) {
      if (mounted) {
        setState(() {
          userName = value!;
        });
      }
    });

    if (mounted) {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return UsernameProvider(
      username: userName,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('homePage'.tr()),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final dataUser = state.user;
            final token = state.token;
            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/icons/teamwork.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(UsernameProvider.of(context)!.username),
                        Text(email)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Slide display section
                SizedBox(
                  height: 200.0,
                  child: buildListView(token, dataUser[0].userId),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Prower : By Sirichai',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryTile(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
