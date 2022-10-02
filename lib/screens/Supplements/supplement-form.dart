import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:gym_project/viewmodels/supplementary-view-model.dart';
import 'package:provider/provider.dart';

class SupplementForm extends StatefulWidget {
  final String type;
  final int id;
  final String title;
  final String description;
  final int price;
  final String picture;
  SupplementForm({
    this.id,
    this.title,
    this.description,
    this.price,
    this.picture,
    this.type,
  });
  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
class MapScreenState extends State<SupplementForm>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  //Text Controllers
  TextEditingController _titleController = TextEditingController(text: "");
  TextEditingController _descriptionController =
      TextEditingController(text: "");
  TextEditingController _priceController = TextEditingController(text: "");
  TextEditingController _pictureController = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pictureController.text = "";
    /*if (widget.type == 'add') {
      _titleController.text = "";
      _descriptionController.text = "";
      _priceController.text = "";
    }*/
    if (widget.type == 'edit') {
      _titleController.text = widget.title;
      _descriptionController.text = widget.description;
      _priceController.text = widget.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var token = Provider.of<LoginViewModel>(context).token;
    return SafeArea(
      child: new Scaffold(
        body: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 100.0,
                    color: Color(0xFF181818), //background color
                    child: new Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                  child: new Text('Create Supplement',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0,
                                          fontFamily:
                                              'assets/fonts/Changa-Bold.ttf',
                                          color: Colors.white)),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
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
                                        'Supplement Information',
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
                                  )
                                ],
                              )),
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
                                        'Title',
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
                                  new Flexible(
                                    child: new TextField(
                                      controller: _titleController,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Supplement Title",
                                      ),
                                    ),
                                  ),
                                ],
                              )),
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
                                        'Description ',
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
                                  new Flexible(
                                    child: new TextField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Enter Supplement Description "),
                                    ),
                                  ),
                                ],
                              )),
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
                                        'Price',
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
                                  new Flexible(
                                    child: new TextField(
                                      controller: _priceController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Supplement Price"),
                                    ),
                                  ),
                                ],
                              )),
                          // Padding(
                          //     padding: EdgeInsets.only(
                          //         left: 25.0, right: 25.0, top: 25.0),
                          //     child: new Row(
                          //       mainAxisSize: MainAxisSize.max,
                          //       children: <Widget>[
                          //         new Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: <Widget>[
                          //             new Text(
                          //               'Picture',
                          //               style: TextStyle(
                          //                 fontSize: 16.0,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Colors.black,
                          //               ),
                          //             ),
                          //             SizedBox(
                          //               width:
                          //                   MediaQuery.of(context).size.width *
                          //                       0.32,
                          //             ),
                          //             ElevatedButton(
                          //               onPressed: () => {},
                          //               child: Icon(
                          //                 Icons.camera_alt,
                          //                 color: Colors.black,
                          //               ),
                          //               style: ButtonStyle(
                          //                 backgroundColor:
                          //                     MaterialStateProperty.all(
                          //                         Colors.transparent),
                          //                 elevation:
                          //                     MaterialStateProperty.all(0),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     )),
                          // Container(
                          //   width: 600,
                          //   //alignment: Alignment.center,
                          //   padding: EdgeInsets.only(
                          //       left: 25.0, right: 25.0, top: 10.0),
                          //   child: Text("Browse a photo",
                          //       style: TextStyle(
                          //         color: Colors.black54,
                          //       )),
                          // ),
                          // l
                          Padding(
                            padding: EdgeInsets.only(
                                left: 95.0, bottom: 0, right: 95.0, top: 50.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Container(
                                        child: new ElevatedButton(
                                      child: widget.type == 'add'
                                          ? new Text("Create")
                                          : new Text("Edit"),
                                      style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                          ),
                                          primary: Color(0xFFFFCE2B),
                                          onPrimary: Colors.black,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      onPressed: () async {
                                        setState(() {
                                          _status = true;
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        });
                                        if (widget.type == 'add') {
                                          await Provider.of<
                                                      SupplementaryViewModel>(
                                                  context,
                                                  listen: false)
                                              .addSupplementary(
                                                  _titleController.text,
                                                  _descriptionController.text,
                                                  int.parse(
                                                      _priceController.text),
                                                  "picture",
                                                  token);
                                        } else {
                                          await Provider.of<
                                                      SupplementaryViewModel>(
                                                  context,
                                                  listen: false)
                                              .editSupplementary(
                                                  widget.id,
                                                  _titleController.text,
                                                  _descriptionController.text,
                                                  int.parse(
                                                      _priceController.text),
                                                  "picture",
                                                  token);
                                          await Provider.of<
                                                      SupplementaryViewModel>(
                                                  context,
                                                  listen: false)
                                              .getSupplementaryById(
                                                  widget.id, token);
                                          /*await Provider.of<
                                                      SupplementaryViewModel>(
                                                  context,
                                                  listen: false)
                                              .getAllSupplementaries(token);*/
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    )),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            ),
                          ),
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
}
