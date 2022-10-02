import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/admin/util-screen.dart';
import 'package:gym_project/screens/coach/coach-tabs-screen.dart';
import 'package:gym_project/splach_screen/splach_screen.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:gym_project/widget/global.dart';
import 'package:provider/provider.dart';
import '../../style/styling.dart';
import '../../widget/button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();

  void postLogin(String email, String password) {
    Provider.of<LoginViewModel>(context, listen: false)
        .fetchLogin(email, password)
        .then((value) {
          if(loadingStatus==LoadingStatus.Completed){
            loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
            Global.setEmail(email);
            // WHEN A USER LOGS IN, TOKEN IS SET NOT ADMIN TOKEN
            Global.set_token(loginViewModel.token);
            Global.set_userId(loginViewModel.id);
            Global.setUserName(loginViewModel.username);
            Global.setRole(loginViewModel.role);
            Global.setRoleId(loginViewModel.roleID??0);
            print('username is ${loginViewModel.username}');
            print('email is $email');
            print('username is ${Global.username}');
            print("role = ${Global.role}");
            print("role id= ${Global.roleID}");
            goToAnotherScreenPush(context, SplachScreen());

            // if (Global.role == 'admin') {
            //   goToAnotherScreenPush(context, SplachScreen());
            //   //goToAnotherScreenPushReplacement(context, AdminUtil());
            // } else if (Global.role == 'coach') {
            //   goToAnotherScreenPushReplacement(context, CoachTabsScreen());
            // } else if (Global.role == 'nutritionist') {
            //   Navigator.pushReplacementNamed(context, '/admin/util');
            // } else if (Global.role == 'member') {
            //   Navigator.pushReplacementNamed(context, '/member/util');
            // }
          }
          else{
            setState((){});
          }
    }).catchError((err) {
      print('error found $err');
    });
  }

  @override
  void initState() {
    super.initState();
    // autoLogin();

    _emailNode.addListener(() {
      scrollToEnd();
    });
    _passwordNode.addListener(() {
      scrollToEnd();
    });
  }

  LoginViewModel loginViewModel;

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  var formKey=GlobalKey<FormState>();

  var scrollController = ScrollController();
  void scrollToEnd() async {
    // wait till keyboard appears
    await Future.delayed(Duration(milliseconds: 500));
    scrollController.jumpTo(
      scrollController.position.maxScrollExtent - 250,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("loading = ${loadingStatus}");
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                      width: deviceSize.width,
                      height: deviceSize.height * 0.8,
                      child: deviceSize.width < 450
                          ? Image.asset(
                              'assets/images/details.png',
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/web-background.jpg',
                              fit: BoxFit.cover,
                            )),
                  Image.asset(
                    'assets/images/Rectangle.png',
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeatX,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: PadRadius.horizontal - 15),
                        child: Column(
                          children: [
                            SizedBox(height: 130),
                            Expanded(
                              flex: 5,
                              child: Image.asset('assets/images/logo.png'),
                            ),
                            Spacer(), //SizedBox(height: deviceSize.height * 0.05),
                            Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: deviceSize.width > 500
                                            ? 500
                                            : deviceSize.width * 0.85,
                                        child: _textField(
                                          controller: emailController,
                                          labelText: 'Email',
                                          node: _emailNode,
                                          errorText: "Email must not be empty",
                                          keyBoardType: TextInputType.emailAddress
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Center(
                                      child: Container(
                                        width: deviceSize.width > 500
                                            ? 500
                                            : deviceSize.width * 0.85,
                                        child: _textField(
                                          controller: passwordController,
                                          labelText: 'Password',
                                          obscure: true,
                                          node: _passwordNode,
                                          errorText: "Password must not be empty"
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: deviceSize.height * 0.01),
                                    //Center(child: Text('Forgot your password?')),
                                  ],
                                )),
                            Expanded(
                              flex: 5,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: deviceSize.height * 0.009,
                                  ),
                                  Container(
                                    width: deviceSize.width > 450
                                        ? deviceSize.width * 0.4
                                        : deviceSize.width * 0.8,
                                    child: ConditionalBuilder(
                                      condition: loadingStatus!=LoadingStatus.Searching,
                                      builder:(context){
                                        return Button(
                                            border: false,
                                            btnTxt: 'Login',
                                            roundedBorder: true,
                                            onTap: () {
                                              if(formKey.currentState.validate()){
                                                setState(() {
                                                  postLogin(emailController.text,
                                                      passwordController.text);
                                                });
                                              }
                                            });
                                      },
                                      fallback: (context){
                                        print("ahmed");
                                        return Center(child: CircularProgressIndicator(),);
                                      },
                                    )
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _textField(
      {String labelText,
      final node,
      bool obscure = false,
      String errorText,
      TextInputType keyBoardType=TextInputType.text,
      TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      focusNode: node,
      obscureText: obscure,
      keyboardType: keyBoardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        labelStyle: TextStyle(
          color: node.hasFocus ? Color(0xFFFFCE2B) : Colors.white,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFFFCE2B),
            width: 2.0,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      validator: (value){
        if(value!=null && value.isEmpty){
          return errorText;
        }
        return null;
      },

    );
  }
}
