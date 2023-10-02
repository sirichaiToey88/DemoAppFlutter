import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/helper/helper_function.dart';
import 'package:demo_app/model/user_login.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/project_list/build_project.dart';
import 'package:demo_app/src/project_list/project_slide.dart';
import 'package:demo_app/src/services/auth_service.dart';
import 'package:demo_app/src/services/database_service.dart';
import 'package:demo_app/utils/textFromField/text-from_field_email.dart';
import 'package:demo_app/utils/textFromField/text_from_field_text_no_validate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'register/register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool arePermissionsGranted = true;
    Locale newLocale = EasyLocalization.of(context)!.locale;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('whoIAm').tr(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const IntroductionBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          if (Localizations.localeOf(context).languageCode == 'en') {
            newLocale = const Locale('th', 'TH');
          } else {
            newLocale = const Locale('en', 'US');
          }

          EasyLocalization.of(context)!.setLocale(newLocale);
        },
        child: Localizations.localeOf(context).languageCode == 'en' ? const BuildImageLocales(imagePath: 'assets/images/locales/en.png') : const BuildImageLocales(imagePath: 'assets/images/locales/th.png'),
      ),
    );
  }
}

class BuildImageLocales extends StatelessWidget {
  final String imagePath;

  const BuildImageLocales({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: 40,
      height: 40,
    );
  }
}

class IntroductionBody extends StatefulWidget {
  const IntroductionBody({Key? key}) : super(key: key);

  @override
  _IntroductionBodyState createState() => _IntroductionBodyState();
}

class _IntroductionBodyState extends State<IntroductionBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  AuthService authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = "jiradech.saardnuam@krungsri.com";
    // _passwordController.text = "0655127426";
    _passwordController.text = "065512";
  }

  Future<bool> _arePermissionsGranted() async {
    return await Permission.camera.isGranted && await Permission.storage.isGranted;
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('การเข้าถึงสิทธิ์ถูกปฏิเสธ'),
          content: Text('โปรดเปิดใช้งานสิทธิ์กล้องและพื้นที่จัดเก็บข้อมูลเพื่อให้แอปพลิเคชันทำงานได้อย่างถูกต้อง'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: Text('ตั้งค่า'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleClickLogin() async {
    // สร้าง instance ของ UserLogin และกำหนดค่า email และ mobile
    UserLogin userLogin = UserLogin(email: _emailController.text, mobile: "0655127426");

    // สร้าง instance ของ LoginEventLogin และกำหนดค่า UserLogin เป็น payload
    context.read<LoginBloc>().add(LoginEventLogin(userLogin));

    setState(() {
      _isLoading = true;
    });

    if (Platform.isAndroid) {
      // Check if camera and storage permissions are granted
      if (!await _arePermissionsGranted()) {
        // Permissions are denied, show permission denied dialog
        _showPermissionDeniedDialog(context);

        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    final loginSuccess = await authService.loginWithEmailAndPassword(_emailController.text, _passwordController.text);

    if (loginSuccess == true) {
      QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(_emailController.text);

      //Save data  sf
      await HelperFunction.saveUserLoggedInStatus(true);
      await HelperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);
      await HelperFunction.saveUserUidKeySF(snapshot.docs[0]['uid']);
      await HelperFunction.saveUserEmailSF(_emailController.text);

      Navigator.pushReplacementNamed(context, AppRoute.homeUser); // ใช้ pushReplacementNamed เพื่อไม่ให้หน้า Login อยู่ใน stack
    } else {
      showSnackBar(context, "Login failed", Colors.red);
      setState(() {
        _isLoading = false; // หากเกิดข้อผิดพลาดในการ Login ให้กลับมาเป็น false เพื่อให้สามารถกด Login ได้ใหม่
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage('assets/images/icons/teamwork.png'),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'myName'.tr(),
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ).tr(),
                  Text(
                    'myYourJobTitle'.tr(),
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'info'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 32.0),

                  Column(
                    children: [
                      TextFromFieldEmail(
                        controller: _emailController,
                        lableText: 'email'.tr(),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return null;
                        },
                        errorMessage: _emailError,
                      ),
                      TextFromFieldNormal(
                        errorMessage: _passwordError,
                        controller: _passwordController,
                        lableText: 'password'.tr(),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                            setState(() {
                              _emailError = _emailController.text.isEmpty ? 'Please enter your email.' : null;
                              _passwordError = _passwordController.text.isEmpty ? 'Please enter your password.' : null;
                            });
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            _handleClickLogin();
                          }
                        },
                        child: const Text('login').tr(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoute.registerPage);
                    },
                    child: const Text('subScribe').tr(),
                  ),
                  const SizedBox(height: 32.0),
                  Text(
                    'projectHeads'.tr(),
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  const ProjectHeadItem('Project A', 'Description of Project A'),
                  const ProjectHeadItem('Project B', 'Description of Project B'),
                  const SizedBox(height: 16.0),

                  // Slide display section
                  SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return SlideItem(
                          image: const AssetImage('assets/images/icons/teamwork.png'),
                          title: 'project ${index + 1}'.tr(),
                          onViewDetails: () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
