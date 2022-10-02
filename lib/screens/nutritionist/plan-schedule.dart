import 'package:flutter/material.dart';
import 'package:gym_project/models/nutritionist/item-plan.dart';
import 'package:gym_project/models/nutritionist/meal-plan.dart';
import 'package:gym_project/models/nutritionist/plan.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:gym_project/viewmodels/nutritionist/plan-view-model.dart';
import 'package:provider/provider.dart';

import '../../widget/global.dart';

class PlanSchedule extends StatefulWidget {
  int id;

  PlanSchedule({this.id = -1});

  @override
  _PlanScheduleState createState() => _PlanScheduleState();
}

class _PlanScheduleState extends State<PlanSchedule> {
  Plan plan = Plan();
  bool finishedLoading = false;

  @override
  void initState() {
    super.initState();

    fetchPlan();
  }

  void fetchPlan() {
    new Future<Plan>.sync(() =>
        Provider.of<PlanViewModel>(context, listen: false).fetchActivePlan(
            widget.id == -1
                ? Provider.of<LoginViewModel>(context, listen: false).roleID
                : widget.id,
            context)).then((Plan value) {
      setState(() {
        if (!finishedLoading) {
          plan = value; //check if it doesn't exist
          finishedLoading = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
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
      appBar: Global.role== "admin" || Global.role == "nutritionist"
              ? AppBar(
                  title: Text(
                    'Diet Plan',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color(0xff181818),
                  iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
                )
              : AppBar(
                  backgroundColor: Colors.black,
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                    preferredSize: new Size(0, 0),
                    child: Container(),
                  ),
                ),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          finishedLoading && plan != null
              ? ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        "https://media.istockphoto.com/photos/arabic-and-middle-eastern-dinner-table-hummus-tabbouleh-salad-salad-picture-id1175505781",
                        fit: BoxFit.fill,
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                      child: Text(
                        plan.title,
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
                        plan.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15.0,
                          fontFamily: 'assets/fonts/ProximaNova-Regular.otf',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (plan.meals
                            .any((element) => element.type == 'breakfast') ||
                        plan.items
                            .any((element) => element.type == 'breakfast'))
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          "Breakfast",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          ),
                        ),
                      ),
                    for (MealPlan meal in plan.meals)
                      if (meal.type == 'breakfast')
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CustomListTileNoTrailing(
                            meal.title,
                            [meal.description],
                          ),
                        ),
                    for (ItemPlan item in plan.items)
                      if (item.type == 'breakfast')
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CustomListTileNoTrailing(
                            item.title,
                            [item.description],
                          ),
                        ),
                    SizedBox(
                      height: 30,
                    ),
                    if (plan.meals.any((element) => element.type == 'lunch') ||
                        plan.items.any((element) => element.type == 'lunch'))
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          "Lunch",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          ),
                        ),
                      ),
                    for (MealPlan meal in plan.meals)
                      if (meal.type == 'lunch')
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CustomListTileNoTrailing(
                            meal.title,
                            [meal.description],
                          ),
                        ),
                    for (ItemPlan item in plan.items)
                      if (item.type == 'lunch')
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CustomListTileNoTrailing(
                            item.title,
                            [item.description],
                          ),
                        ),
                    SizedBox(
                      height: 30,
                    ),
                    if (plan.meals.any((element) => element.type == 'dinner') ||
                        plan.items.any((element) => element.type == 'dinner'))
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          "Dinner",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          ),
                        ),
                      ),
                    for (MealPlan meal in plan.meals)
                      if (meal.type == 'dinner')
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CustomListTileNoTrailing(
                            meal.title,
                            [meal.description],
                          ),
                        ),
                    for (ItemPlan item in plan.items)
                      if (item.type == 'dinner')
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CustomListTileNoTrailing(
                            item.title,
                            [item.description],
                          ),
                        ),
                    SizedBox(
                      height: 30,
                    ),
                    if (plan.meals.any((element) => element.type == 'snack') ||
                        plan.items.any((element) => element.type == 'snack'))
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          "Snack",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          ),
                        ),
                      ),
                    for (MealPlan meal in plan.meals)
                      if (meal.type == 'snack')
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CustomListTileNoTrailing(
                            meal.title,
                            [meal.description],
                          ),
                        ),
                    for (ItemPlan item in plan.items)
                      if (item.type == 'snack')
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CustomListTileNoTrailing(
                            item.title,
                            [item.description],
                          ),
                        ),
                  ],
                )
              : plan != null
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: Text(
                      'No Active Plan',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
        ],
      ),
    );
  }
}

class CustomListTileNoTrailing extends StatefulWidget {
  final String title;
  final List<String> subtitles;

  CustomListTileNoTrailing(this.title, this.subtitles);
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
        minVerticalPadding: 10,
        leading: CircleAvatar(
          radius: 20,
          child: Icon(Icons.food_bank),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (String subtitle in widget.subtitles)
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white54,
                ),
              )
          ],
        ),
      ),
    );
  }
}
