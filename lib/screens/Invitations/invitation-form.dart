import 'package:flutter/material.dart';
import 'package:gym_project/core/presentation/res/assets.dart';
import 'package:gym_project/style/styling.dart';
import 'package:gym_project/viewmodels/invitation-view-model.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:provider/provider.dart';

class InvitationForm extends StatefulWidget {
  @override
  _InvitationFormState createState() => _InvitationFormState();
}

class _InvitationFormState extends State<InvitationForm> {
  TextEditingController nameController;
  TextEditingController numberController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = new TextEditingController();
    numberController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: new Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFFFCE2B),
                  size: 22.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Invitations",
                style: TextStyle(
                    fontFamily: "assets/fonts/Changa-Bold.ttf", fontSize: 35)),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "Invite Your Friends ",
                    style: TextStyle(color: Colors.amber, fontSize: 16)),
              ]),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child:  Image.asset(
                                'assets/images/invite.png')),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: Text(
                            "Your Friend Information",
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                    Container(
                      width: isWideScreen ? 700 : double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: TextField(
                        controller: nameController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.amber),
                            ),
                            hintText: 'Enter your friend name ',
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey)),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: isWideScreen ? 700 : double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: TextField(
                        controller: numberController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.amber),
                            ),
                            hintText: 'Enter your friend phone number ',
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey)),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      //width: double.infinity,
                      width: isWideScreen
                          ? 400
                          : MediaQuery.of(context).size.width * 0.5,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(PadRadius.radius)),
                        color: Colors.amberAccent,
                        child: Text(
                          "Send Invitation",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Provider.of<InvitationViewModel>(context,
                                  listen: false)
                              .addInvitation(
                                  nameController.text,
                                  numberController.text,
                                  Provider.of<LoginViewModel>(context,
                                          listen: false)
                                      .token);
                          final snackbar = SnackBar(
                            content: numberController.text.length >= 11
                                ? Text(
                                    'Your invitation is sent',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                : Text(
                                    'Phone number must have 11 number',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                            backgroundColor: Colors.amber,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
