import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_project/screens/admin/memberships/membership_details.dart';
import 'package:gym_project/screens/admin/memberships/memberships_list.dart';
import 'package:gym_project/style/styling.dart';

class MemberMembershipDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('My Membership'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.amber,
      ),
      body: Center(
        child: Container(
          width: isWideScreen ? 900 : double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/images/membership.jfif',
                      fit: BoxFit.cover,
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                    child: Text(
                      "Gold Membership",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'assets/fonts/Changa-Bold.ttf',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                    child: Text(
                      "Maadi Branch",
                      style: TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Card(
                            color: Colors.white12,
                            child: ListTile(
                              title: Text(
                                "Available classes",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                "30",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 10.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                      Flexible(
                        child: Card(
                            color: Colors.white12,
                            child: ListTile(
                              title: Text(
                                "Freeze",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                "10 days",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 10.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                      Flexible(
                        child: Card(
                            color: Colors.white12,
                            child: ListTile(
                              title: Text(
                                "Duration",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                "2 months",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 10.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Card(
                            color: Colors.white12,
                            child: ListTile(
                              title: Text(
                                "Starts At",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                "01-9-2021",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 10.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                      Flexible(
                        child: Card(
                            color: Colors.white12,
                            child: ListTile(
                              title: Text(
                                "Ends At",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                "01-11-2021",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 10.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 75,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (_) => MembershipDetails(),
                              //   ),
                              // );
                              ///TODO
                            },
                            child: Text(
                              'View membership details',
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Renew membership',
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MembershipsList(),
                                ),
                              );
                            },
                            child: Text(
                              'Change Membership',
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
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
}
