import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/user/member_model.dart';
import 'package:gym_project/screens/admin/classes/class_arguments.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../helping-widgets/create-form-widgets.dart';
//TODO you must show
class EditClass extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
class MapScreenState extends State<EditClass>
    with SingleTickerProviderStateMixin {
  static List<Member> membersList = [];
  void getMembers() async {
    // membersList = await Provider.of<MembersViewModel>(context, listen: false)
      //  .fetchMembers();
  }

  Future attachMembersLoop(int id) {
    // _selectedMembers.forEach((element) async {
    //   await Provider.of<ClassesListViewModel>(context, listen: false)
    //       .attachMembers(element.id, id.toString());
    // });

    //TODO attach member to class
  }

  final _items = membersList
      .map((member) => MultiSelectItem<Member>(member, member.id.toString()))
      .toList();
  List<dynamic> _selectedMembers = [];

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ClassesArguments;

    bool value = false;
    int val = -1;
    String date = "";
    getMembers();
    _selectDate(BuildContext context) async {
      final DateTime selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
      );
      if (selected != null && selected != selectedDate)
        setState(() {
          selectedDate = selected;
        });
    }

    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //Screen Header
                  new Container(
                    height: 100.0,
                    color: Color(0xFF181818), //background color
                    child: new Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: new Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xFFFFCE2B),
                                  size: 22.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                //-->header
                                child: new Text('Edit Class',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        fontFamily:
                                            'assets/fonts/Changa-Bold.ttf',
                                        color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Form
                  new Container(
                    constraints: new BoxConstraints(minHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //Form heading
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        //---> topic
                                        'Class Information',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status
                                          ? _getEditIcon()
                                          : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          field('Title', args.title, titleController),
                          field('Description', args.description,
                              descriptionController),
                          field(
                              'price', args.price.toString(), priceController),
                          field('Duration', args.duration.toString(),
                              durationController),
                          field('Link', args.link, linkController),
                          field('Level', args.level, levelController),
                          field('Capacity', args.capacity.toString(),
                              capacityController),
                          //Date picker
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Date ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                    color: Color(0xFFFFCE2B),
                                    child: Text("Choose Date"),
                                    //focusNode: !_status,
                                  ),
                                  Text(
                                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                                ],
                              )),
                          //member picker
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Edit Members',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, right: 20, left: 20),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                MultiSelectBottomSheetField(
                                  initialChildSize: 0.4,
                                  listType: MultiSelectListType.CHIP,
                                  searchable: true,
                                  buttonText: Text(
                                    "Choose Members",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  title: Text("Members"),
                                  items: _items,
                                  onConfirm: (values) {
                                    _selectedMembers = values;
                                  },
                                  chipDisplay: MultiSelectChipDisplay(
                                    onTap: (value) {
                                      setState(() {
                                        _selectedMembers.remove(value);
                                      });
                                    },
                                    chipColor: Colors.black.withAlpha(200),
                                    textStyle: TextStyle(color: Colors.white),
                                    scroll: true,
                                  ),
                                ),
                                _selectedMembers == null ||
                                        _selectedMembers.isEmpty
                                    ? Container(
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Selected Members",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ))
                                    : Container(),
                              ],
                            ),
                          ),
                          !_status ? _getActionButtons(args) : new Container(),
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

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons(ClassesArguments args) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 90.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Save"),
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    primary: Color(0xFFFFCE2B),
                    onPrimary: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    _status = true;
                    // Future.wait([
                    //   attachMembersLoop(args.id),
                    //   Provider.of<ClassesListViewModel>(context, listen: false)
                    //       .fetchUpdateClasses(
                    //           args.id.toString(),
                    //           descriptionController.text,
                    //           titleController.text,
                    //           linkController.text,
                    //           levelController.text,
                    //           int.parse(capacityController.text),
                    //           double.parse(priceController.text),
                    //           double.parse(durationController.text),
                    //           selectedDate.toString()),
                    // ]);

                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.popUntil(
                        context, ModalRoute.withName("/class-list"));
                  });
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Cancel"),
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    primary: Color(0xFFFFCE2B),
                    onPrimary: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Color(0xFFFFCE2B),
        radius: 20.0,
        child: new Icon(
          Icons.edit,
          color: Colors.black,
          size: 23.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
