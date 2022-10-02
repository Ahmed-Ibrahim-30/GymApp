import 'package:flutter/material.dart';
import 'package:gym_project/screens/coach/coach_profile.dart';
import 'package:gym_project/screens/common/login-screen.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:provider/provider.dart';

class NutritionistDrawer extends StatefulWidget {
  String name;
  String email;
  NutritionistDrawer(this.name, this.email);

  @override
  _NutritionistDrawerState createState() => _NutritionistDrawerState();
}

class _NutritionistDrawerState extends State<NutritionistDrawer> {
  void logout() {
    Provider.of<LoginViewModel>(context, listen: false)
        .fetchLogout()
        .then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }).catchError((err) {
      showErrorMessage(context, 'Failed to logout.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Container(
        color: Color(0xff181818),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Color(0xff181818),
              child: UserAccountsDrawerHeader(
                accountEmail: Text(
                  widget.name,
                  style: TextStyle(color: Colors.white),
                ),
                accountName: Text(
                  widget.email,
                  style: TextStyle(
                      color: Colors.amberAccent,
                      fontFamily: "assets/fonts/Changa-Bold.ttf"),
                ),
                currentAccountPicture: Image.asset('assets/images/blank.png'),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'About us',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, '/about-us');
              },
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: const Text(
                'logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
