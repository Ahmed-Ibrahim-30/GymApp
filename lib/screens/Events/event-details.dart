import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/screens/Events/event-form.dart';
import 'package:gym_project/viewmodels/event-view-model.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../widget/global.dart';

class EventDetailsScreen extends StatefulWidget {
  String title;
  String price;
  String date;
  String startTime;
  String endTime;
  int tickets;
  String description;
  int id;
  void Function() update;
  Event currentEvent;

  EventDetailsScreen(this.id, this.title, this.price, this.tickets, this.date,
      this.startTime, this.endTime, this.description, this.update);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  String formatDateTime(String DateTime) {
    //2021-09-13 14:13:51
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    String year = DateTime.substring(0, 4);
    String month = DateTime.substring(5, 7);
    String day = DateTime.substring(8, 10);
    String time = DateTime.substring(11, 16);
    return '$day ${months[int.parse(month) - 1]} $year $time';
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: myBlack,
      appBar: AppBar(
        backgroundColor: myBlack,
        elevation: 0.0,
        leading: backButton(context: context),
        centerTitle: true,
        title: Text('Event Info',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: 'sans-serif-light',
                color: Colors.white)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: InkWell(
              onTap: () {
                Provider.of<EventViewModel>(context,
                    listen: false)
                    .deleteEvent(
                    this.widget.id,
                    Global.token);
                final snackbar = SnackBar(
                  content: Text(
                    'Event Deleted correctly',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp),
                  ),
                  backgroundColor: Colors.amber,
                );
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackbar);
                widget.update();
                Navigator.pop(context);
              },
              child: Global.role == 'admin'
                  ? new Icon(
                Icons.delete,
                color: Colors.red,
                size: 22.0.sp,
              )
                  : Container(),
            ),
          ),
        ],
      ),
      floatingActionButton: Global.role == 'admin'
              ? Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventForm(
                                    'edit',
                                    widget.title,
                                    widget.description,
                                    widget.price,
                                    widget.tickets,
                                    widget.startTime,
                                    widget.endTime,
                                    widget.date,
                                    widget.id,
                                    widget.update,
                                    updateSingle)));
                      }
                    },
                    isExtended: false,
                    child: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: MediaQuery.of(context).size.width * 0.1,
                )
              : widget.tickets > 0
                  ? Container(
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Provider.of<EventViewModel>(context, listen: false)
                              .registerEvent(
                                  this.widget.id,
                                  Global.token);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Color(0xff181818),
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xff181818)),
                              ),
                              content: widget.price == "Free" ||
                                      widget.price == 'free' ||
                                      widget.price == '0'
                                  ? Text(
                                      "Booking Done.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily:
                                            'assets/fonts/Changa-Bold.ttf',
                                        fontSize: 18,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      "Booking Done\n\nPlease get your ticket from your branch.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily:
                                            'assets/fonts/Changa-Bold.ttf',
                                        fontSize: 18,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  color: Colors.amber,
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        isExtended: true,
                        label: Text(
                          'Book Now !',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.075,
                      width: MediaQuery.of(context).size.width * 0.45,
                    )
                  : Container(),
      floatingActionButtonLocation: Global.role== 'admin'
              ? FloatingActionButtonLocation.miniEndFloat
              : FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Container(
          width: isWideScreen ? 900 : double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
            child: ListView(
              // shrinkWrap: true,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    image: DecorationImage(
                      image: AssetImage('assets/images/event.jpeg'),
                      fit: BoxFit.cover,
                    )
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                SizedBox(height: 20.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 10.0.h, bottom: 10.h),
                        child: Text(
                          this.widget.title.length > 15
                              ? '${this.widget.title.substring(0, 15)}...'
                              : this.widget.title,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 30.0.sp,
                            color: myYellow2,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(this.widget.price + ' \$',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0.sp,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          )),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0.w, vertical: 10.0.h),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              this.widget.date,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                color: myTealLight,
                                fontWeight: FontWeight.w500,
                                fontFamily:
                                    'assets/fonts/Changa-Bold.ttf',
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Text(
                                "${widget.startTime} TO ${widget.endTime}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Text("${widget.tickets} ticket",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          )),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 7),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0.w, vertical: 10.0.h),
                    child: Text("Description",
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          color: myYellow2,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                        ))),
                Container(
                  padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15.0.sp,
                      fontFamily: 'assets/fonts/ProximaNova-Regular.otf',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateSingle() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<EventViewModel>(context, listen: false).getEventById(
          widget.id, Global.token);

      setState(() {
        widget.currentEvent =
            Provider.of<EventViewModel>(context, listen: false).currentevent;
        widget.title = widget.currentEvent.title;
        widget.price = widget.currentEvent.price;
        widget.tickets = widget.currentEvent.ticketsAvailable;
        widget.description = widget.currentEvent.description;
        widget.date =
            formatDateTime(widget.currentEvent.startTime).substring(0, 11);
        widget.startTime =
            formatDateTime(widget.currentEvent.startTime).substring(12);
        widget.endTime = widget.currentEvent.endTime.substring(11, 16);
      });
    });
  }
}
