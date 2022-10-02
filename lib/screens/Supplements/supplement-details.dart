import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/Supplements/supplement-form.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:gym_project/viewmodels/supplementary-view-model.dart';
import 'package:provider/provider.dart';
import '../../widget/global.dart';

class SupplementDetailsScreen extends StatefulWidget {
  final String title;
  final int price;
  final String image;
  final String description;
  final int id;

  SupplementDetailsScreen(
      this.id, this.title, this.description, this.image, this.price);

  @override
  _SupplementDetailsScreenState createState() =>
      _SupplementDetailsScreenState();
}

class _SupplementDetailsScreenState extends State<SupplementDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<SupplementaryViewModel>(context, listen: false)
        .getSupplementaryById(widget.id,
            Global.token);
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    var supplement = Provider.of<SupplementaryViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Global.role == 'admin'
          ? Container(
              child: FloatingActionButton(
                onPressed: () {
                  //Navigator.pushNamed(context, '/edit-supplement');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SupplementForm(
                                type: 'edit',
                                title: supplement.supplementary.title,
                                id: supplement.supplementary.id,
                                description:
                                    supplement.supplementary.description,
                                price: supplement.supplementary.price,
                                picture: widget.image,
                              )));
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
          : Global.role == 'member'
              ? Container(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color(0xff181818),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xff181818)),
                          ),
                          content: Text(
                            "Booking Done\n\nPlease receive your order from your branch",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'assets/fonts/Changa-Bold.ttf',
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
                      'Request Now !',
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
      floatingActionButtonLocation: Global.role == 'admin'
              ? FloatingActionButtonLocation.miniEndFloat
              : FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Container(
                width: isWideScreen ? 900 : double.infinity,
                child: ListView(
                  // shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      color: Color(0xff181818),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {

                              Navigator.pop(context);
                            },
                            child: new Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFFFFCE2B),
                              size: 22.0,
                            ),
                          ),
                          //-->header
                          Text('Supplement Info',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0.sp,
                                  fontFamily: 'sans-serif-light',
                                  color: Colors.white)),
                          InkWell(
                            onTap: () async {
                              await Provider.of<SupplementaryViewModel>(context,
                                      listen: false)
                                  .deleteSupplementary(this.widget.id, Global.token);
                              final snackbar = SnackBar(
                                content: Text(
                                  'Supplement Deleted correctly',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                backgroundColor: Colors.amber,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              Navigator.pop(context);
                            },
                            child: Global.role == 'admin'
                                    ? new Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 22.0,
                                      )
                                    : Container(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Image.asset(
                        'assets/images/supp.jpg',
                        fit: BoxFit.cover,
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20.0.w, right: 20.0.w, top: 10.0.h, bottom: 10.h),
                            child: Text(
                              supplement.supplementary.title,
                              style: TextStyle(
                                fontSize: 24.0.sp,
                                color: myYellow2,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Text("${supplement.supplementary.price.toString()}\$",
                              style: TextStyle(
                                color: myTealLight,
                                fontSize: 20.0.sp,
                                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                              )),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0.w, vertical: 10.0.h),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text("Description",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'assets/fonts/Changa-Bold.ttf',
                            ))),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        supplement.supplementary.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15.0,
                          fontFamily: 'assets/fonts/ProximaNova-Regular.otf',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
