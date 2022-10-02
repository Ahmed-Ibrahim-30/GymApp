import 'package:flutter/material.dart';
import 'package:gym_project/style/duration.dart';
import 'package:gym_project/viewmodels/private-session-view-model.dart';

class PrivateSessionDetailsScreen extends StatelessWidget {
  final PrivateSessionViewModel _privateSession;
  PrivateSessionDetailsScreen(this._privateSession);

  @override
  Widget build(BuildContext context) {
    //need to get coach name
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  child: Image.network(
                    "https://media.istockphoto.com/photos/kettlebell-and-medicine-ball-in-the-gym-equipment-for-functional-picture-id1153479113?k=20&m=1153479113&s=612x612&w=0&h=wLZnQE2GPjXJFYVpygKlNK5iyD8THMyPOGG4qFGr3xE=",
                    fit: BoxFit.cover,
                  ),
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                      child: Text(
                        _privateSession.title,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                        ),
                      ),
                    ),
                    Container(
                      child: Text("\$${_privateSession.price}",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 15,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          )),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "${formatDuration(_privateSession.duration)}",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber,
                      fontFamily: 'assets/fonts/Changa-Bold.ttf',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                  child: Text(
                    "Coach: ${_privateSession.coachName}",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'assets/fonts/Changa-Bold.ttf',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(
                    _privateSession.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15.0,
                      fontFamily: 'assets/fonts/ProximaNova-Regular.otf',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    "Session Link",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'assets/fonts/Changa-Bold.ttf',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    _privateSession.link,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
