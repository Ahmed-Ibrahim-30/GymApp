import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/screens/Supplements/supplement-details.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:gym_project/viewmodels/supplementary-view-model.dart';
import 'package:provider/provider.dart';
import '../../widget/global.dart';

class SupplementCard extends StatefulWidget {
  final String title;
  final int price;
  final String image;
  final String description;
  final int id;

  SupplementCard(
      this.image, this.title, this.price, context, this.id, this.description);
  @override
  _SupplementCardState createState() => _SupplementCardState();
}

class _SupplementCardState extends State<SupplementCard> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    //SupplementCard(image, title, price, context,id,description) {
    return Visibility(
      visible: isVisible,
      child: GestureDetector(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 6.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage(widget.image)),
                SizedBox(
                  height: 5,
                ),
                FittedBox(
                  child: Text(widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.black,
                      )),
                ),
                !(widget.price == 0)
                    ? Text(widget.price.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ))
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Provider.of<SupplementaryViewModel>(context, listen: false)
                        .deleteSupplementary(
                            widget.id,
                            Global.token);
                    setState(() {
                      isVisible = false;
                    });
                  },
                  child: Global.role == 'admin'
                          ? new Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25.0,
                            )
                          : Container(),
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          await Provider.of<SupplementaryViewModel>(context, listen: false)
              .getSupplementaryById(widget.id,
                  Global.token);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SupplementDetailsScreen(
                      widget.id,
                      widget.title,
                      widget.description,
                      widget.image,
                      widget.price)));
        },
      ),
    );
  }
}
