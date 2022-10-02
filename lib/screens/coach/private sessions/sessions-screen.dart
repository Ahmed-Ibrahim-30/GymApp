import 'package:flutter/material.dart';

import 'package:gym_project/screens/coach/private%20sessions/view-booked-sessions.dart';
import 'package:gym_project/screens/coach/private%20sessions/view-my-private-sessions.dart';

class SessionsScreen extends StatelessWidget {
  final TabController _controller;

  SessionsScreen(this._controller);

  @override
  Widget build(BuildContext context) {
    return new TabBarView(
      controller: _controller,
      children: <Widget>[
        ViewMyPrivateSessionsScreen(),
        ViewBookedSessionsScreen(),
      ],
    );
  }
}
