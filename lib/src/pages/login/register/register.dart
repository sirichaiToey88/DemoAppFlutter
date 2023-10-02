import 'package:demo_app/helper/helper_function.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/services/auth_service.dart';
import 'package:demo_app/utils/textFromField/text-from_field_email.dart';
import 'package:demo_app/utils/textFromField/text_from_field_number.dart';
import 'package:demo_app/utils/textFromField/text_from_field_text_no_validate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _fullNameError;
  String? _passwordError;
  String? _emailError;
  String? _phoneError;
  String? _companyNameError;

  bool _isLoading = false;

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('register'.tr()),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFromFieldNormal(
                        errorMessage: _fullNameError,
                        controller: _fullNameController,
                        lableText: 'fullName'.tr(),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return null;
                        },
                      ),
                      TextFromFieldNumber(
                        errorMessage: _phoneError,
                        controller: _phoneNumberController,
                        lableText: 'phoneNumber'.tr(),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        validator: (value) {
                          return null;
                        },
                      ),
                      TextFromFieldEmail(
                        errorMessage: _emailError,
                        controller: _emailController,
                        lableText: 'email'.tr(),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return null;
                        },
                      ),
                      TextFromFieldNormal(
                        errorMessage: _companyNameError,
                        controller: _companyNameController,
                        lableText: 'companyName'.tr(),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return null;
                        },
                      ),
                      TextFromFieldNumber(
                        errorMessage: _passwordError,
                        controller: _passwordController,
                        lableText: 'password'.tr(),
                        keyboardType: TextInputType.text,
                        maxLength: 6,
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _phoneNumberController.text.isEmpty || _fullNameController.text.isEmpty) {
                            setState(() {
                              _emailError = _emailController.text.isEmpty ? 'pleaseEnterYourEmail'.tr() : null;
                              _passwordError = _passwordController.text.isEmpty ? 'pleaseEnterYourPassword'.tr() : null;
                              _fullNameError = _fullNameController.text.isEmpty ? 'pleaseEnterYouFullName'.tr() : null;
                              _phoneError = _phoneNumberController.text.isEmpty ? 'pleaseEnterYouMobilePhone'.tr() : null;
                            });
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            final registrationSuccess = await authService.registerUserWithEmailAndPassword(_fullNameController.text, _emailController.text, _passwordController.text);
                            setState(() {
                              _isLoading = false;
                            });

                            if (registrationSuccess == true) {
                              await HelperFunction.saveUserLoggedInStatus(true);
                              await HelperFunction.saveUserNameSF(_fullNameController.text);
                              await HelperFunction.saveUserEmailSF(_emailController.text);
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context, AppRoute.listProduct);
                            } else {
                              // ignore: use_build_context_synchronously
                              showSnackBar(context, 'registrationFailed'.tr(), Colors.red);
                            }
                          }
                        },
                        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Subscribe'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

void showSnackBar(context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: "confirm".tr(),
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}
