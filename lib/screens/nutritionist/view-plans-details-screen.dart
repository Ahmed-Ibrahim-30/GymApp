import 'package:flutter/material.dart';
import 'package:gym_project/common/my-list-tile-without-trailing.dart';
import 'package:gym_project/models/nutritionist/item-plan.dart';
import 'package:gym_project/models/nutritionist/meal-plan.dart';
import 'package:gym_project/models/nutritionist/plan.dart';
import '../../widget/global.dart';

class PlansDetailsScreen extends StatelessWidget {
  String role = 'nutritionist';
  Plan selectedPlan;
  bool includeAppBar = false;
  PlansDetailsScreen(
      {this.selectedPlan, this.role, this.includeAppBar = false});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: Global.role == "admin" || Global.role == "nutritionist"
              ? (includeAppBar
                  ? AppBar(
                      title: Text(
                        'Plan Details',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xff181818),
                      iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
                    )
                  : null)
              : (includeAppBar
                  ? AppBar(
                      backgroundColor: Colors.black,
                      automaticallyImplyLeading: false,
                      bottom: PreferredSize(
                        preferredSize: new Size(0, 0),
                        child: Container(),
                      ),
                    )
                  : null),
      floatingActionButton: Global.role == "admin" || Global.role == "nutritionist"
              ? Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit-plan');
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
            if (selectedPlan != null)
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    child: Image.network(
                      "https://media.istockphoto.com/photos/kettlebell-and-medicine-ball-in-the-gym-equipment-for-functional-picture-id1153479113?k=20&m=1153479113&s=612x612&w=0&h=wLZnQE2GPjXJFYVpygKlNK5iyD8THMyPOGG4qFGr3xE=",
                      fit: BoxFit.fill,
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
                              selectedPlan.title,
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              selectedPlan.description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15.0,
                                fontFamily:
                                    'assets/fonts/ProximaNova-Regular.otf',
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
                          for (ItemPlan item in selectedPlan.items)
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: CustomListTileNoTrailing(
                                item.title,
                                [
                                  '${item.cal} cal',
                                  'level ${item.level}',
                                ],
                              ),
                            ),
                          for (MealPlan meal in selectedPlan.meals)
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: CustomListTileNoTrailing(
                                meal.title,
                                [meal.description],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
