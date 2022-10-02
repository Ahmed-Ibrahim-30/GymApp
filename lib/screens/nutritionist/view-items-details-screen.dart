import 'package:flutter/material.dart';
import 'package:gym_project/models/nutritionist/item.dart';
import '../../widget/global.dart';

class ItemsDetailsScreen extends StatefulWidget {
  final Item item;

  ItemsDetailsScreen({@required this.item});

  @override
  _ItemsDetailsScreenState createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  Color mapLevelToColor(String level) {
    if (level == 'red') {
      return Colors.red.shade800;
    } else if (level == 'yellow') {
      return Colors.yellow.shade700;
    } else if (level == 'green') {
      return Colors.green.shade800;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      floatingActionButton: Global.role == "admin" || Global.role == "nutritionist"
              ? Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit-item');
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
              : Container(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  child: Image.network(
                    widget.item.image,
                    fit: BoxFit.cover,
                  ),
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: isWideScreen ? 900 : double.infinity,
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.title,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Calories: ${widget.item.cal}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                              text: 'Level: ',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              children: [
                                TextSpan(
                                  text: '${widget.item.level}',
                                  style: TextStyle(
                                    color: mapLevelToColor(widget.item.level),
                                  ),
                                )
                              ]),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Description: ${widget.item.description}',
                          style: TextStyle(fontSize: 18),
                        ),
                        // SizedBox(height: 10),
                        // Text(
                        //   'Created By: ${_item['nutritionist']}',
                        //   style: TextStyle(fontSize: 18),
                        // ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
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
