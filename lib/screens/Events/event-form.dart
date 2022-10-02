import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/viewmodels/event-view-model.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:provider/provider.dart';
class EventForm extends StatefulWidget {

  final String type;
  final String title ;
  final String price ;
  final int tickets ;
  final String description ;
  final String startTime;
  final String endTime;
  final String date;
  final int id;
  void Function() update;
  void Function() updateSingle;



  EventForm(this.type,this.title,this.description,this.price,this.tickets,this.startTime,this.endTime,this.date,this.id,this.update,this.updateSingle);

  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
class MapScreenState extends State<EventForm>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  bool first = true;
  final FocusNode myFocusNode = FocusNode();

  //Text Controllers
  TextEditingController titleController;
  TextEditingController descriptionController ;
  TextEditingController priceController ;
  TextEditingController ticketsController ;


//Date Picker
  DateTime selectedEDate =  DateTime.now();
  TimeOfDay selectedSTime = TimeOfDay.now();
  TimeOfDay selectedETime = TimeOfDay.now();



  Future<void> _selectSTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedSTime,);
    if (picked != null && picked != selectedSTime)
      setState(() {
        selectedSTime = picked;

      });
  }

  Future<void> _selectETime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedETime,);
    if (picked != null && picked != selectedETime)
      setState(() {
        selectedETime = picked;
      });
  }

  Future<void> _selectEDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedEDate,
        firstDate: DateTime(1998) ,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedEDate)
      setState(() {
        selectedEDate = picked;
        first=false;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController= widget.type=='edit'? new TextEditingController(text: widget.title): new TextEditingController();
    descriptionController = widget.type=='edit'? new TextEditingController(text: widget.description): new TextEditingController();
    priceController = widget.type=='edit'? new TextEditingController(text: widget.price): new TextEditingController();
    ticketsController = widget.type=='edit'? new TextEditingController(text: widget.tickets.toString()): new TextEditingController();
    // selectedEDate = widget.type =="add"? DateTime.now()  :DateTime.parse(widget.date);
    selectedSTime = widget.type =="add"? TimeOfDay.now() :TimeOfDay(hour:int.parse(widget.startTime.split(":")[0]),minute: int.parse(widget.startTime.split(":")[1]));
    selectedETime = widget.type =="add"? TimeOfDay.now() :TimeOfDay(hour:int.parse(widget.endTime.split(":")[0]),minute: int.parse(widget.endTime.split(":")[1]));
  }

  @override
  Widget build(BuildContext context) {
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
                                  child: widget.type=='add'? new Text('Create Event',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                          color: Colors.white)):
                                          new Text('Edit Event',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        //---> topic
                                        'Event Information',
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
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Event Title",
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
                                      controller: descriptionController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Event Description "),
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
                                      controller: priceController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Event Price"),
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
                                        'Numbre Of Tickects',
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
                                      controller: ticketsController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Available number of tickets"),
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
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Date',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width*0.32,),
                                     ElevatedButton(
                                    onPressed: () => _selectEDate(context),
                                    child: Icon(Icons.calendar_today,color: Colors.black,),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                      elevation: MaterialStateProperty.all(0),
    
                                    ),
                                  ),
                                  ],
                                ),
                              ],
                            )),
                        Container(
                          width: 600,
                          //alignment: Alignment.center,
                          padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 10.0),
                            child:
                               first==false? Text("${selectedEDate.toLocal()}".split(' ')[0],style: TextStyle(color: Colors.black,)):
                               Text(widget.date,style: TextStyle(color: Colors.black,)),
                        ),   
    
    
                        Divider(color: Colors.grey, indent: 20, endIndent:  20),

                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Start Time',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width*0.3,),
                                     ElevatedButton(
                                    onPressed: () => _selectSTime(context),
                                    child: Icon(Icons.alarm, color: Colors.black,),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                      elevation: MaterialStateProperty.all(0),
    
                                    ),
                                  ),
                                  ],
                                ),
                              ],
                            )),
                        Container(
                          width: 600,
                          //alignment: Alignment.center,
                          padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 10.0),
                            child:
                              Text("$selectedSTime".substring(10,15),style: TextStyle(color: Colors.black,)),
                              // Text(widget.startTime,style: TextStyle(color: Colors.black,)),
                              
                        ),   
                        Divider(color: Colors.grey, indent: 20, endIndent:  20),
                        
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'End Time',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width*0.3,),
                                     ElevatedButton(
                                    onPressed: () => _selectETime(context),
                                    child: Icon(Icons.alarm, color: Colors.black,),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                      elevation: MaterialStateProperty.all(0),
    
                                    ),
                                  ),
                                  ],
                                ),
                              ],
                            )),
                        Container(
                          width: 600,
                          //alignment: Alignment.center,
                          padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 10.0),
                            child:
                              Text("$selectedETime".substring(10,15),style: TextStyle(color: Colors.black,)),
                              // Text(widget.endTime,style: TextStyle(color: Colors.black,)),
                        ),   
                        Divider(color: Colors.grey, indent: 20, endIndent:  20),
                        
                        
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
                                      child: widget.type == 'add'?new Text("Create"):new Text("Edit"),
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
                                      onPressed: () {
                                        widget.type=='add'?Provider.of<EventViewModel>(context, listen: false).addEvent(titleController.text, descriptionController.text, new DateTime(selectedEDate.year,selectedEDate.month,selectedEDate.day,selectedSTime.hour,selectedSTime.minute), new DateTime(selectedEDate.year,selectedEDate.month,selectedEDate.day,selectedETime.hour,selectedETime.minute), priceController.text, 'New', ticketsController.text,Provider.of<LoginViewModel>(context, listen: false).token):
                                        Provider.of<EventViewModel>(context, listen: false).editEvent(widget.id,titleController.text, descriptionController.text, new DateTime(selectedEDate.year,selectedEDate.month,selectedEDate.day,selectedSTime.hour,selectedSTime.minute), new DateTime(selectedEDate.year,selectedEDate.month,selectedEDate.day,selectedETime.hour,selectedETime.minute), priceController.text, 'New', ticketsController.text,Provider.of<LoginViewModel>(context, listen: false).token);
                                        widget.update();  
                                        widget.updateSingle();
                                        Navigator.pop(context);
                                        final snackbar =SnackBar(
                                          content: widget.type=='add'?Text('Event Added correctly',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),):Text('Event Updated correctly',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                                          backgroundColor: Colors.amber,);
                                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                        setState(() {
                                          _status = true;
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        });
                                      }
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