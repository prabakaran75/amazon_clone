import 'dart:convert';
import 'package:amazon_clone/common/bottomBar/gv_bottom_nav_bar.dart';
import 'package:amazon_clone/constant/erro_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth-name";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService authService = AuthService();
  Auth _auth = Auth.signin;
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final _signupKey = GlobalKey<FormState>();
  final _signinKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void signUp() async {
    final msg = await authService.signUpUser(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );
    if (!mounted) return;
    if (msg == null) {
      showSnackBar(
        context,
        "Account has been created, Log In with same Credentials!",
      );
    } else {
      showSnackBar(context, msg);
    }
  }

  void signIn() async {
    final res = await authService.signInUser(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    if (!mounted) return;

    final msg = errorHandling(res);
    if (msg != null) {
      showSnackBar(context, msg);
      return;
    }

    final data = jsonDecode(res.body);

    Provider.of<UserProvider>(context, listen: false).setUser(res.body);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("x-auth-token", data['token']);

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      GvBottomNavBar.routeName,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wd = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: ht * 0.01,
            horizontal: wd * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              RadioGroup(
                groupValue: _auth,
                onChanged: (Auth? val) {
                  setState(() {
                    _auth = val!;
                  });
                },
                child: Column(
                  children: [
                    RadioListTile.adaptive(
                      tileColor: _auth == Auth.signup
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundCOlor,
                      activeColor: GlobalVariables.secondaryColor,
                      value: Auth.signup,
                      title: Text(
                        "Create account.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (_auth == Auth.signup)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: wd * 0.05,
                          vertical: ht * 0.03,
                        ),
                        decoration: BoxDecoration(
                          color: GlobalVariables.backgroundColor,
                          // borderRadius: BorderRadius.circular(5),
                        ),
                        child: Form(
                          key: _signupKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: "UserName",
                                controller: nameCtrl,
                              ),
                              SizedBox(height: ht * 0.01),
                              CustomTextField(
                                hintText: "Email",
                                controller: emailCtrl,
                              ),
                              SizedBox(height: ht * 0.01),
                              CustomTextField(
                                hintText: "Password",
                                controller: passCtrl,
                                obscure: true,
                              ),
                              SizedBox(height: ht * 0.02),
                              CustomButton(
                                text: "Sign up",
                                onpress: () {
                                  if (_signupKey.currentState!.validate()) {
                                    signUp();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    RadioListTile.adaptive(
                      tileColor: _auth == Auth.signin
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundCOlor,
                      activeColor: GlobalVariables.secondaryColor,
                      value: Auth.signin,
                      title: Text(
                        "Sign in.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (_auth == Auth.signin)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: wd * 0.05,
                          vertical: ht * 0.03,
                        ),
                        decoration: BoxDecoration(
                          color: GlobalVariables.backgroundColor,
                          // borderRadius: BorderRadius.circular(5),
                        ),
                        child: Form(
                          key: _signinKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: "Email",
                                controller: emailCtrl,
                              ),
                              SizedBox(height: ht * 0.01),
                              CustomTextField(
                                hintText: "Password",
                                controller: passCtrl,
                                obscure: true,
                              ),
                              SizedBox(height: ht * 0.02),
                              CustomButton(
                                text: "Sign in",
                                onpress: () {
                                  if (_signinKey.currentState!.validate()) {
                                    signIn();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
