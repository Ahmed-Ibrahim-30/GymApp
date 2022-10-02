import 'package:flutter/material.dart';
import 'package:gym_project/common/crowd-meter.dart';
import 'package:gym_project/screens/Events/events-list.dart';
import 'package:gym_project/screens/Supplements/supplement-grid-view.dart';
import 'package:gym_project/screens/about_us.dart';
import 'package:gym_project/screens/admin/branches/branches_list.dart';
import 'package:gym_project/screens/announcements/announcements-screen.dart';
import 'package:gym_project/screens/coach/exercises/create-exercise.dart';
import 'package:gym_project/screens/coach/exercises/exercises_screen.dart';
import 'package:gym_project/screens/coach/groups/create-group.dart';
import 'package:gym_project/screens/coach/groups/view-groups.dart';
import 'package:gym_project/screens/coach/private%20sessions/create-private-session.dart';
import 'package:gym_project/screens/coach/sets/create-set.dart';
import 'package:gym_project/screens/coach/sets/view-sets.dart';
import 'package:gym_project/screens/nutritionist/item-creation-form.dart';
import 'package:gym_project/screens/nutritionist/meal-creation-from.dart';
import 'package:gym_project/screens/nutritionist/nutritionist-members.dart';
import 'package:gym_project/screens/nutritionist/plan-creation-form.dart';
import 'package:gym_project/screens/nutritionist/fitness-summary-creation-form.dart';
import 'package:gym_project/screens/nutritionist/meals-screen.dart';
import 'package:gym_project/screens/nutritionist/plans-screen.dart';
import 'package:gym_project/screens/questions/questions-screen.dart';

import 'package:gym_project/screens/nutritionist/items_screen.dart';

class OthersScreen extends StatelessWidget {
  const OthersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return GridView.count(
      primary: false,
      padding: EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: deviceSize.width < 450
          ? deviceSize.width < 900
              ? 2
              : 3
          : deviceSize.width < 900
              ? 3
              : 4,
      children: [
        Container(
          decoration: new BoxDecoration(
            // color: const Color(0xff181818),
            image: new DecorationImage(
              image: AssetImage('assets/images/others-create.png'),
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.amber,
                                ),
                              )
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                                onPrimary: Colors.black,
                                fixedSize: Size.fromWidth(150),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateFitnessSummaryForm()));
                            },
                            child: Text('Fitness Summary'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                                onPrimary: Colors.black,
                                fixedSize: Size.fromWidth(150),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateItemForm()));
                            },
                            child: Text('Item'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                              onPrimary: Colors.black,
                              fixedSize: Size.fromWidth(150),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateMealForm()));
                            },
                            child: Text('Meal'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                                onPrimary: Colors.black,
                                fixedSize: Size.fromWidth(150),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreatePlanForm()));
                            },
                            child: Text('Plan'),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Center(
              child: Text(
                'Create',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
            // color: const Color(0xff181818),
            image: new DecorationImage(
              image: AssetImage('assets/images/others-inventory.png'),
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.amber,
                                ),
                              )
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                                onPrimary: Colors.black,
                                fixedSize: Size.fromWidth(150),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemsScreen(
                                    false,
                                    includeAppBar: true,
                                  ),
                                ),
                              );
                            },
                            child: Text('All Items'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                                onPrimary: Colors.black,
                                fixedSize: Size.fromWidth(150),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MealsViewScreen(
                                    false,
                                    includeAppBar: true,
                                  ),
                                ),
                              );
                            },
                            child: Text('All Meals'),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Center(
              child: Text(
                'Inventory',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
            // color: const Color(0xff181818),
            image: new DecorationImage(
              image: AssetImage('assets/images/others-crowdmeter.png'),
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.amber,
                                ),
                              )
                            ],
                          ),
                          CrowdMeter(checkedInMembers: 40, totalMembers: 100),
                        ],
                      ),
                    );
                  });
            },
            child: Center(
              child: Text(
                'Crowd Meter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
            // color: const Color(0xff181818),
            image: new DecorationImage(
              image: AssetImage('assets/images/others-announcements.png'),
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnnouncementsScreen()));
            },
            child: Center(
              child: Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
            // color: const Color(0xff181818),
            image: new DecorationImage(
              image: AssetImage('assets/images/others-questions.png'),
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QuestionsScreen()));
            },
            child: Center(
              child: Text(
                'Q&A',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
            // color: const Color(0xff181818),
            image: new DecorationImage(
              image: AssetImage('assets/images/others-supplements.png'),
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SupplementList()));
            },
            child: Center(
              child: Text(
                'Supplements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
            // color: const Color(0xff181818),
            image: new DecorationImage(
              image: AssetImage('assets/images/others-events.png'),
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventListView()));
            },
            child: Center(
              child: Text(
                'Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
            // color: const Color(0xff181818),
            image: new DecorationImage(
              image: AssetImage('assets/images/others-branches.png'),
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BranchesList()));
            },
            child: Center(
              child: Text(
                'Branches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
            // color: const Color(0xff181818),
            image: new DecorationImage(
              image: AssetImage('assets/images/others-aboutus.png'),
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutUs()));
            },
            child: Center(
              child: Text(
                'About us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
