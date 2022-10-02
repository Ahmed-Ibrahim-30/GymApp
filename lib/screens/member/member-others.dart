import 'package:flutter/material.dart';
import 'package:gym_project/common/crowd-meter.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/Events/events-list.dart';
import 'package:gym_project/screens/Supplements/supplement-grid-view.dart';
import 'package:gym_project/screens/admin/branches/branches_list.dart';

import 'package:gym_project/screens/announcements/announcements-screen.dart';

import 'package:gym_project/screens/coach/exercises/exercises_screen.dart';

import 'package:gym_project/screens/coach/groups/view-groups.dart';

import 'package:gym_project/screens/coach/sets/view-sets.dart';
import 'package:gym_project/screens/questions/questions-screen.dart';
import 'package:gym_project/viewmodels/set-list-view-model.dart';
import 'package:provider/provider.dart';

class MemberOthers extends StatelessWidget {
  const MemberOthers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Container(
      color: myBlack,
      child: GridView.count(
        physics: BouncingScrollPhysics(),
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
          //inventory
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
                                      // builder: (context) => MultiProvider(
                                      //   providers: [
                                      //     ChangeNotifierProvider(
                                      //       create: (_) =>
                                      //           ExerciseListViewModel(),
                                      //     ),
                                      //   ],
                                      //   child: ExercisesScreen(false),
                                      // ),
                                      builder: (context) =>
                                          ExercisesScreen(false),
                                    ));
                              },
                              child: Text('All Exercises'),
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
                                        builder: (context) => MultiProvider(
                                              providers: [
                                                ChangeNotifierProvider(
                                                  create: (_) =>
                                                      SetListViewModel(),
                                                ),
                                              ],
                                              child: ViewSetsScreen(false),
                                            )));
                              },
                              child: Text('All Sets'),
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
                                        builder: (context) =>
                                            ViewGroupsScreen(false)));
                              },
                              child: Text('All Groups'),
                            ),
                            SizedBox(
                              height: 10,
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
          //crowd meter
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
          //announcement
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
          //Q&A
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
          //supplements
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
          //events
          Container(
            decoration: new BoxDecoration(
              // color: const Color(0xff181818),
              image: new DecorationImage(
                image: AssetImage('assets/images/event.jpeg',),
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
          //branches
          Container(
            decoration: new BoxDecoration(
              // color: const Color(0xff181818),
              image: new DecorationImage(
                image: AssetImage('assets/images/equipment1.jpg'),
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
          //classes
          Container(
            decoration: new BoxDecoration(
              // color: const Color(0xff181818),
              image: new DecorationImage(
                image: AssetImage('assets/images/branch2.jpg'),
                colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.dstATop,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/class-list');
              },
              child: Center(
                child: Text(
                  'Classes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          ),
          //memberships
          Container(
            decoration: new BoxDecoration(
              // color: const Color(0xff181818),
              image: new DecorationImage(
                image: AssetImage('assets/images/membership-others.jpg'),
                colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.dstATop,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/memberships-list');
              },
              child: Center(
                child: Text(
                  'Memberships',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          ),
          //private sessions
          Container(
            decoration: new BoxDecoration(
              // color: const Color(0xff181818),
              image: new DecorationImage(
                image: AssetImage('assets/images/session.jpg'),
                colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.dstATop,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sessions');
              },
              child: Center(
                child: Text(
                  'Private Sessions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
