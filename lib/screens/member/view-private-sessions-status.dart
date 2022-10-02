import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/screens/common/view-private-session-details.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/style/duration.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/style/success-pop-up.dart';
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
    getPrivateSessionsList(1, '');
  }

  getPrivateSessionsList(int page, String searchText) {
    Provider.of<PrivateSessionListViewModel>(context, listen: false)
        .fetchListBookedPrivateSessions('member', page, searchText)
        .then((value) {
      sessionListViewModel =
          Provider.of<PrivateSessionListViewModel>(context, listen: false);
      setState(() {
        done = true;
        privateSessions = sessionListViewModel.privateSessions;
        lastPage = sessionListViewModel.lastPage;
      });
    }).catchError((err) {
      error = true;
      print('error occured $err');
    });
  }

  var sessionListViewModel;
  bool done = false;
  bool error = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    const decorator = DotsDecorator(
      activeColor: Colors.amber,
    );
    return SafeArea(
      child: Container(
        color: Colors.black,
        padding: EdgeInsetsDirectional.all(10),
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
                            _currentPosition = 0;
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
                      if (error) {
                        return CustomErrorWidget();
                      } else if (done && privateSessions.isEmpty) {
                        return EmptyListError('No private sessions found');
                      } else if (privateSessions.isEmpty) {
                        return Progress();
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: privateSessions.length,
                            itemBuilder: (ctx, index) {
                              print(privateSessions[index].status);
                              return myListTile(
                                  privateSessions[index], index, token);
                            });
                      }
                    }),
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
      ),
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
            if (privateSession.status == 'booked')
              Text(
                'Date:${formatDateTime(privateSession.dateTime)}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            Text(
              formatDuration(privateSession.duration),
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
        trailing: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
              '\$${privateSession.price}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '${privateSession.status}',
              style: TextStyle(color: Colors.amber),
            ),
              ],
            ),
            if (privateSession.status != 'cancelled')
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => EditPlanForm()));

                    Provider.of<PrivateSessionListViewModel>(context,
                            listen: false)
                        .cancelPrivateSession(privateSession.id)
                        .then((value) {
                      setState(() {
                        showSuccessMessage(
                            context, 'Session cancelled successfully!');
                      });
                    }).catchError((err) {
                      showErrorMessage(context, 'Failed to cancel session!');
                      print('Failed to delete session');
                    });
                  },
                  child: Text('Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
