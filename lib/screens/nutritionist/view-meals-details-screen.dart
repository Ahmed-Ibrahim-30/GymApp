import 'package:flutter/material.dart';
import 'package:gym_project/models/nutritionist/item-meal.dart';
import 'package:gym_project/models/nutritionist/item.dart';
import 'package:gym_project/models/nutritionist/meal.dart';
import 'package:gym_project/screens/nutritionist/view-items-details-screen.dart';
import '../../widget/global.dart';

class MealsDetailsScreen extends StatelessWidget {
  String role = 'nutritionist';
  Meal selectedMeal;
  MealsDetailsScreen(this.selectedMeal, {this.role});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      floatingActionButton: Global.role== "admin" || Global.role == "nutritionist"
              ? Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit-meal');
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
                  decoration: BoxDecoration(color: Colors.white),
                  child: Image.asset(
                    'images/meal_image.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: isWideScreen ? 900 : double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                            child: Text(
                              selectedMeal.title,
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Text(
                              "Items",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          for (ItemMeal item in selectedMeal.items)
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: CustomListTileNoTrailing(
                                item.title,
                                [
                                  'Has ${item.cal} calories',
                                  'Level: ${item.level}',
                                  'Quantity: ${item.quantity}',
                                ],
                                selectedItem: item,
                              ),
                            ),
                        ]),
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

class CustomListTileNoTrailing extends StatefulWidget {
  final String title;
  final List<String> subtitles;
  final ItemMeal selectedItem;

  CustomListTileNoTrailing(this.title, this.subtitles, {this.selectedItem});
  @override
  _CustomListTileNoTrailingState createState() =>
      _CustomListTileNoTrailingState();
}

class _CustomListTileNoTrailingState extends State<CustomListTileNoTrailing> {
  @override
  Widget build(BuildContext context) {
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
                  builder: (context) => ItemsDetailsScreen(
                      item: Item(
                          image: widget.selectedItem.image,
                          description: widget.selectedItem.description,
                          title: widget.selectedItem.title,
                          cal: widget.selectedItem.cal,
                          level: widget.selectedItem.level,
                          nutritionistID: widget.selectedItem
                              .nutritionistID)))); //supply Item here
        },
        minVerticalPadding: 10,
        leading: CircleAvatar(
          radius: 20,
          child: FlutterLogo(),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (String subtitle in widget.subtitles)
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}
