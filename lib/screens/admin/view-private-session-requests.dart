import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gym_project/screens/common/view-private-session-details.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/style/success-pop-up.dart';
import 'package:gym_project/viewmodels/private-session-list-view-model.dart';
import 'package:gym_project/viewmodels/private-session-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';
import '../../all_data.dart';
import '../../widget/global.dart';

class ViewPrivateSessionRequestsScreen extends StatefulWidget {
  @override
  _ViewPrivateSessionRequestsScreenState createState() =>
      _ViewPrivateSessionRequestsScreenState();
}



class _ViewPrivateSessionRequestsScreenState extends State<ViewPrivateSessionRequestsScreen> {
  String token=Global.token;
  int lastPage;

  void initState() {
    super.initState();
    done = false;
    error = false;
    getPrivateSessionsList(1, '');
    _currentPosition = 0;
  }

  refresh() {
    setState(() {});
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    done = false;
    error = false;
    getPrivateSessionsList(1, '');
  }

  double _currentPosition;
  var sessionListViewModel;
  bool done = false;
  bool error = false;
  DateTime dateTimeChosen;
  bool dateTimeStatus = false;

  getPrivateSessionsList(int page, String searchText) {
    Provider.of<PrivateSessionListViewModel>(context, listen: false)
        .fetchListRequestedPrivateSessions(page, searchText)
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

  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const decorator = DotsDecorator(
      activeColor: Colors.amber,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sessions",
          style: TextStyle(
              color: Colors.white, fontFamily: "assets/fonts/Changa-Bold.ttf"),
        ),
        backgroundColor: Colors.black, //Color(0xff181818),
        iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          padding: EdgeInsetsDirectional.all(10),
          child: Column(
            children: [
              Material(
                              elevation: 5.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: TextFormField(
                                  
                                  controller: searchText,
                                  cursorColor: Theme.of(context).primaryColor,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  decoration: InputDecoration(
                                    hintText: 'Search..',
                                    suffixIcon: Material(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
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
                      print('index is $index');
                      if (error) {
                        return CustomErrorWidget();
                      } else if (done && privateSessions.isEmpty) {
                        return EmptyListError('No Private Sessions Found');
                      } else if (privateSessions.isEmpty) {
                        return Progress();
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: privateSessions.length,
                            itemBuilder: (ctx, index) {
                              return myListTile(
                                privateSessions[index],
                                index,
                                token,
                              );
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
        ),
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
              builder: (context) => PrivateSessionDetailsScreen(privateSession),
            ),
          );
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
              'Member: ${privateSession.memberName}',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(
                  child: Text('Accept'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.amber,
                                        ),
                                      )
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      'Choose Date and Time',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await DatePicker.showDateTimePicker(
                                        context,
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 3, 5),
                                        maxTime: DateTime(2022, 12, 30),
                                      ).then((value) {
                                        setState(() {
                                          dateTimeChosen = value;
                                          privateSession.dateTime =
                                              dateTimeChosen;
                                          dateTimeStatus = true;
                                          refresh();
                                        });
                                      });
                                    },
                                    child: Text('Choose',
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber,
                                      onPrimary: Colors.black,
                                    ),
                                  ),
                                  if (dateTimeStatus)
                                    Center(
                                      child: new Text(
                                        'You chose',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  if (dateTimeStatus)
                                    Center(
                                      // '${DateFormat.yMd().format(DateTime.now())} ${DateFormat.Hms().format(DateTime.now())}'
                                      child: new Text(
                                        '${formatDateTime(dateTimeChosen.toString())}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  if (dateTimeStatus)
                                    ElevatedButton(
                                      onPressed: () {
                                        Provider.of<PrivateSessionListViewModel>(
                                                context,
                                                listen: false)
                                            .acceptPrivateSession(
                                                privateSession)
                                            .then((value) {
                                          Navigator.pop(context);
                                          showSuccessMessage(context,
                                              'Accepted successfully.');
                                        }).catchError((err) {
                                          print('$err');
                                          showErrorMessage(
                                              context, 'Failed to accept');
                                        });
                                      },
                                      child: Text('Submit',
                                          style: TextStyle(fontSize: 16)),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.amber,
                                        onPrimary: Colors.black,
                                      ),
                                    )
                                ],
                              ),
                            );
                          });
                        });
                  }),
            ),
            SizedBox(height: 6),
            Expanded(
              child: ElevatedButton(
                  child: Text('Reject'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                  onPressed: () {
                    Provider.of<PrivateSessionListViewModel>(context,
                            listen: false)
                        .rejectPrivateSession(privateSession)
                        .then((value) {
                      showSuccessMessage(context, 'Rejected successfully.');
                    }).catchError((err) {
                      print('$err');
                      showErrorMessage(context, 'Failed to accept');
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
