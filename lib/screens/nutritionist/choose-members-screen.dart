import 'package:flutter/material.dart';
import 'package:gym_project/models/user/member_model.dart';
import 'package:gym_project/screens/common/ProfilePage.dart';
import 'package:gym_project/widget/custom-back-button-2.dart';
import 'package:gym_project/widget/loading-widgets.dart';

class ChooseMembersScreen extends StatefulWidget {
  bool isSelectionTime = false;

  ChooseMembersScreen(this.isSelectionTime);
  @override
  _ChooseMembersScreenState createState() => _ChooseMembersScreenState();

  static int whoIsSelected = -1;
}

class _ChooseMembersScreenState extends State<ChooseMembersScreen> {
  List<Member> members = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMembersList();
  }

  bool done = false;
  bool error = false;
  var membersViewModel;

  getMembersList() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          padding: EdgeInsetsDirectional.all(10),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        CustomBackButton2(),
                        Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          //-->header
                          child: new Text('My Members',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    error
                        ? CustomErrorWidget()
                        : done && members.isEmpty
                            ? EmptyListError('No members found.')
                            : members.isEmpty
                                ? Progress()
                                : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: members.length,
                                    itemBuilder: (ctx, index) {
                                      return myListTile(members[index].name,
                                          index, widget.isSelectionTime);
                                    }),
                  ],
                ),
              ),
              if (ChooseMembersScreen.whoIsSelected != -1)
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFFCE2B),
                            onPrimary: Colors.black,
                          ),
                          child: Text('Submit'),
                          onPressed: () {
                            Navigator.pop(context,
                                members[ChooseMembersScreen.whoIsSelected]);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFFCE2B),
                              onPrimary: Colors.black),
                          child: Text('Cancel'),
                          onPressed: () {
                            setState(() {
                              ChooseMembersScreen.whoIsSelected = -1;
                            });
                          },
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myListTile(String title, int index, bool selectionTime) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        color: ChooseMembersScreen.whoIsSelected == index
            ? Colors.white24
            : Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          if (!selectionTime) {
            Navigator.pushNamed(context, '/user-details');
          } else {
            setState(() {
              ChooseMembersScreen.whoIsSelected = index;
            });
          }
        },
        selected: ChooseMembersScreen.whoIsSelected == index,
        minVerticalPadding: 10,
        leading: CircleAvatar(
          radius: 20,
          child: Icon(Icons.note),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectionTime)
              TextButton(
                child: Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                },
              ),
          ],
        ),
      ),
    );
  }
}
