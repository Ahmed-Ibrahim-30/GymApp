import 'package:conditional_builder/conditional_builder.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/screens/coach/private%20sessions/edit-private-session.dart';
import 'package:gym_project/screens/common/view-private-session-details.dart';
import 'package:gym_project/style/duration.dart';
import 'package:gym_project/viewmodels/private-session-list-view-model.dart';
import 'package:gym_project/viewmodels/private-session-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../widget/global.dart';

class ViewMyPrivateSessionsScreen extends StatefulWidget {
  @override
  _ViewMyPrivateSessionsScreenState createState() =>
      _ViewMyPrivateSessionsScreenState();
}

List<PrivateSessionViewModel> privateSessions = [];

class _ViewMyPrivateSessionsScreenState
    extends State<ViewMyPrivateSessionsScreen> {
  String token;
  int lastPage;
  @override
  void initState() {
    super.initState();
    done = false;
    error = false;
    getPrivateSessionsList(1, '');
  }

  getPrivateSessionsList(int page, String searchText) {
    Provider.of<PrivateSessionListViewModel>(context, listen: false)
        .fetchListMyPrivateSessions(0, searchText)
        .then((value) {
      sessionListViewModel =
          Provider.of<PrivateSessionListViewModel>(context, listen: false);
      setState(() {
        done = true;
        privateSessions = sessionListViewModel.privateSessions;
        lastPage = sessionListViewModel.lastPage;
      });
      // showSuccessMessage(context, 'Loaded successfully!');
    }).catchError((err) {
      error = true;
      print('error occured $err');
      // showErrorMessage(context, 'error! $err');
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
    double width = MediaQuery.of(context).size.width;
    const decorator = DotsDecorator(
      activeColor: Colors.amber,
    );
    return Scaffold(
      backgroundColor: myBlack,
      appBar: Global.role== "member" || Global.role == "admin"
          ? AppBar(
              title: Text(
                'Private Sessions',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xff181818),
              iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(),
            ),
      body: Container(
        color: myBlack,
        padding: EdgeInsetsDirectional.all(10),
        child: Stack(children: [
          Column(
            children: [
              SizedBox(height: 5.h),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
                child: TextFormField(
                  controller: searchText,
                  cursorColor: Theme.of(context).primaryColor,
                  style: TextStyle(color: Colors.black, fontSize: 18.sp),
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
              SizedBox(height: 30.h),
              Expanded(
                child: ConditionalBuilder(
                    condition: done && privateSessions.isEmpty,
                    builder: (context)=>EmptyListError('No Private Sessions Found'),
                  fallback: (context)=>ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: privateSessions.length,
                      itemBuilder: (ctx, index) {
                        return myListTile(
                          privateSessions[index],
                          index,
                          token,
                        );
                      }),
                ),
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
            Text(
              privateSession.coachName,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              formatDuration(privateSession.duration),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              'Price: \$${privateSession.price}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditPrivateSessionForm(privateSession.id)));
              },
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        TextButton(
              onPressed: () {
                Provider.of<PrivateSessionListViewModel>(context, listen: false)
                    .deletePrivateSession(privateSession.id)
                    .then((value) {
                  setState(() {
                    privateSessions.remove(privateSession);
                  });
                }).catchError((err) => {print('Failed to delete session')});
              },
              child: Text('Delete',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
