import 'package:conditional_builder/conditional_builder.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/constants.dart';

import 'package:gym_project/screens/coach/private%20sessions/edit-private-session.dart';
import 'package:gym_project/screens/common/view-private-session-details.dart';
import 'package:gym_project/style/duration.dart';
import 'package:gym_project/viewmodels/private-session-list-view-model.dart';
import 'package:gym_project/viewmodels/private-session-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';

class ViewBookedSessionsScreen extends StatefulWidget {
  @override
  _ViewBookedSessionsScreenState createState() =>
      _ViewBookedSessionsScreenState();
}

List<PrivateSessionViewModel> privateSessions = [];

class _ViewBookedSessionsScreenState extends State<ViewBookedSessionsScreen> {
  String token;
  int lastPage;
  double _currentPosition = 0;
  @override
  void initState() {
    super.initState();
    done = false;
    error = false;
    getPrivateSessionsList(1, '');
  }

  getPrivateSessionsList(int page, String searchText) {
    Provider.of<PrivateSessionListViewModel>(context, listen: false)
        .fetchListBookedPrivateSessions('coach', page, searchText)
        .then((value) {
      sessionListViewModel =
          Provider.of<PrivateSessionListViewModel>(context, listen: false);
      setState(() {
        done = true;
        privateSessions = sessionListViewModel.privateSessions;
        print("private sessions = ${privateSessions.length}");
        lastPage = sessionListViewModel.lastPage;
      });
    }).catchError((err) {
      error = true;
      print('error occurred $err');
    });
  }

  var sessionListViewModel;
  bool done = false;
  bool error = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    done = false;
    error = false;
    getPrivateSessionsList(1, '');
  }

  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    const decorator = DotsDecorator(
      activeColor: Colors.amber,
    );
    return Container(
      color: myBlack,
      padding: EdgeInsets.only(left: 10.w,right: 10.w,top: 10.h),
      child: Stack(children: [
        Column(
          children: [
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                controller: searchText,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15, top: 12),
                  hintText: 'Search..',
                  suffixIcon: Material(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          privateSessions = [];
                          done = false;
                          error = false;
                          getPrivateSessionsList(1, searchText.text);
                        });
                      },
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: PageController(),
                onPageChanged: (index) {
                  setState(() {
                    privateSessions = [];
                    done = false;
                    error = false;
                    _currentPosition = index.toDouble();
                  });
                  getPrivateSessionsList(index + 1, '');
                },
                scrollDirection: Axis.horizontal,
                itemCount: lastPage,
                itemBuilder: (ctx, index) {
                  return ConditionalBuilder(
                    condition: (privateSessions.isEmpty),
                    builder: (context)=>EmptyListError('No Booked Sessions Found'),
                    fallback: (context)=> ListView.builder(
                      shrinkWrap: true,
                      itemCount: privateSessions.length,
                      itemBuilder: (ctx, index) {
                        return myListTile(
                            privateSessions[index], index, token);
                      }),
                  );
                },
              ),
            ),
            if (done)
              DotsIndicator(
                dotsCount: lastPage,
                position: _currentPosition,
                axis: Axis.horizontal,
                decorator: decorator,
                onTap: (pos) {
                  setState(() => _currentPosition = pos);
                },
              ),
          ],
        ),
      ]),
    );
  }

  Widget myListTile(
      PrivateSessionViewModel privateSession, int index, String token) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PrivateSessionDetailsScreen(privateSession)));
        },
        minVerticalPadding: 10,
        leading: CircleAvatar(
          radius: 20,
          child: FlutterLogo(),
        ),
        title: Text(
          privateSession.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Member: ${privateSession.name}',
              style: TextStyle(color: Colors.amber),
            ),
            Text(
              formatDuration(privateSession.duration),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              'Status: ${privateSession.status}',
              style: TextStyle(color: Colors.amber),
            ),
          ],
        ),
        trailing: Column(
          children: [
            Text(
              '\$${privateSession.price}',
              style: TextStyle(color: Colors.white),
            ),

            // I DISABLED THE COACH FROM EDITING OR DELETING THE BOOKED SESSIONS
            // THIS SHOULD BE HANDLED BY THE ADMIN

            // SizedBox(
            //   width: 4,
            // ),
            // Expanded(
            //   child: TextButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //                   EditPrivateSessionForm(privateSession.id)));
            //     },
            //     child: Text(
            //       'Edit',
            //       style: TextStyle(
            //         color: Colors.amber,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: TextButton(
            //     onPressed: () {
            //       Provider.of<PrivateSessionListViewModel>(context,
            //               listen: false)
            //           .deletePrivateSession(privateSession.id)
            //           .then((value) {
            //         setState(() {
            //           privateSessions.remove(privateSession);
            //         });
            //       }).catchError((err) => {print('Failed to delete session')});
            //     },
            //     child: Text('Delete',
            //         style: TextStyle(
            //           fontSize: 15,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.red,
            //         )),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
