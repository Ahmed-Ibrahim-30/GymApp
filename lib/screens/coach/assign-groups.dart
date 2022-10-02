import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gym_project/common/my_list_tile.dart';
import 'package:gym_project/models/user/member_model.dart';
import 'package:gym_project/screens/coach/groups/view-groups.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/style/success-pop-up.dart';
import 'package:gym_project/viewmodels/group-list-view-model.dart';
import 'package:gym_project/viewmodels/groups-view-model.dart';
import 'package:gym_project/widget/form-widget.dart';
import 'package:provider/provider.dart';

GroupViewModel group;
// Map<int, Map<String, Object>> finalGroups = {};
List<GroupViewModel> groups = [];
// Map<int, Map<String, Object>> newGroups = {};
List<Map<String, dynamic>> newGroups = [];
int index = 0;

// ignore: must_be_immutable
class AssignGroupMember extends StatefulWidget {
  Member member;
  AssignGroupMember(this.member);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<AssignGroupMember>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  bool status = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  bool assignGroupstoMember(List<Map<String, dynamic>> groups, int memberId) {
    setState(() {
      Provider.of<GroupListViewModel>(context, listen: false)
          .assignGroups(groups, memberId)
          .then((value) {
        showSuccessMessage(context, 'Groups assigned successfully');
      }).catchError((err) {
        showErrorMessage(context, 'Failed to assign groups');
        print('error occured $err');
      });
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.member);
    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  PageTitle('Assign Groups to Member'),
                  new Container(
                    //height: 1000.0,
                    constraints: new BoxConstraints(minHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),

                    //color: Colors.white,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Padding(
                      //padding: EdgeInsets.only(bottom: 30.0),
                      padding: EdgeInsets.all(30),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FormTitle('Member'),
                          SizedBox(
                            height: 10,
                          ),
                          CustomListTile(
                            '${widget.member.name}',
                            [],
                            iconData: Icons.account_circle,
                            trailing: '',
                          ),
                          FieldTitle('Group'),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: ElevatedButton(
                                        child: Text(
                                          'Choose Groups',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            primary: Colors.amber,
                                            onPrimary: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            )),
                                        onPressed: () async {
                                          // Map<int, Map<String, Object>> result =
                                          List<GroupViewModel> result =
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiProvider(
                                                      providers: [
                                                        ChangeNotifierProvider(
                                                          create: (_) =>
                                                              GroupListViewModel(),
                                                        ),
                                                      ],
                                                      child: ViewGroupsScreen(
                                                          true),
                                                    ),
                                                  ));
                                          setState(() {
                                            if (result != null) groups = result;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // if (newGroups.isNotEmpty)
                          //   for (var values in newGroups.values)
                          //     CustomGroupListTile(values, refresh),
                          if (groups.isNotEmpty)
                            for (group in groups)
                              CustomGroupListTile(group, refresh),
                          SizedBox(height: 10),
                          submitButton(context),
                        ],
                      ),
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

  Container submitButton(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: ElevatedButton(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Submit"),
        ),
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          primary: Color(0xFFFFCE2B),
          onPrimary: Colors.black,
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          minimumSize: Size(100, 30),
        ),
        onPressed: () {
          setState(() {
            _status = true;
            FocusScope.of(context).requestFocus(new FocusNode());
          });
          // for (Map<String, dynamic> g in newGroups) {
          //   print(g);
          // }
          assignGroupstoMember(newGroups, widget.member.id);
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}

class CustomGroupListTile extends StatefulWidget {
  // final Map<String, Object> map;
  final GroupViewModel group;
  final Function() notifyParent;

  CustomGroupListTile(this.group, this.notifyParent);
  @override
  _CustomGroupListTileState createState() => _CustomGroupListTileState();
}

class _CustomGroupListTileState extends State<CustomGroupListTile> {
  DateTime dateTimeChosen;
  bool dateTimeStatus = false;
  refresh() {
    setState(() {});
  }

  // GroupViewModel group;
  // DateTime date;

  @override
  Widget build(BuildContext context) {
    // group = widget.map['group'];
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        minVerticalPadding: 10,
        leading: CircleAvatar(
          radius: 20,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/images/branch.png',
                fit: BoxFit.cover,
              )),
          // child: Image.network(widget.iconData),
        ),
        title: Text(
          widget.group.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dateTimeStatus)
              Text(
                'Date chosen: ${formatDate(dateTimeChosen.toString())}',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.amber,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onTap: () {
                group = null;
                widget.notifyParent();
              },
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
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
                                    'Choose Date',
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
                                    await DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(2020, 3, 5),
                                      maxTime: DateTime(2022, 12, 30),
                                    ).then((value) {
                                      setState(() {
                                        dateTimeChosen = value;
                                        // date = dateTimeChosen;
                                        widget.group.date = dateTimeChosen;
                                        // print(widget.group.date);
                                        // finalGroups[index] = {
                                        //   'group': group,
                                        //   'date': date,
                                        // };
                                        // index++;
                                        newGroups.add({
                                          'group_id': widget.group.id,
                                          'date': widget.group.date.toString(),
                                        });
                                        dateTimeStatus = true;
                                        refresh();
                                        widget.notifyParent();
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
                                    child: new Text(
                                      '${formatDate(dateTimeChosen.toString())}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                if (dateTimeStatus)
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
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
                },
                child: Text(
                  'Choose day',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
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
