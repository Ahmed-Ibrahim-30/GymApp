import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/common/crowd-meter.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/coach/exercises/exercises_screen.dart';
import 'package:gym_project/screens/coach/groups/view-groups.dart';
import 'package:gym_project/screens/coach/sets/view-sets.dart';

// final otherPaths = [
//   '/coach/schedule',
//   '/announcements',
//   '/questions',
//   '/supplements',
//   '/events',
//   '/branches-list',
//   '/about-us'
// ];

class OthersScreen extends StatefulWidget {
  const OthersScreen({Key key}) : super(key: key);

  @override
  OthersScreenState createState() => OthersScreenState();
}

class OthersScreenState extends State<OthersScreen> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final titles = [
      "Create",
      "Inventory",
      "Schedule",
      "Crowd Meter",
      "Announcements",
      'Q&A',
      "Supplements",
      "Events",
      "Branches",
      "About Us",
    ];
    final gridImagePaths = [
      'assets/images/others-create.png',
      'assets/images/others-inventory.png',
      'assets/images/others-schedule.png',
      'assets/images/others-crowdmeter.png',
      'assets/images/others-announcements.png',
      'assets/images/others-questions.png',
      'assets/images/others-supplements.png',
      'assets/images/event.jpeg',
      'assets/images/others-branches.png',
      'assets/images/equipment1.jpg'
    ];
    final otherPaths = [
      '/create-pop-up',
      '/inventory-pop-up',
      '/coach/schedule',
      '/crowd-meter',
      '/announcements',
      '/questions',
      '/supplements',
      '/events',
      '/branches-list',
      '/about-us'
    ];

    return Container(
      color: myBlack,
      child: GridView.count(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 10.h,
        crossAxisCount: deviceSize.width < 450
            ? deviceSize.width < 900
                ? 2
                : 3
            : deviceSize.width < 900
                ? 3
                : 4,
        children: [
          for (int i = 0; i < titles.length; i++)
            othersTile(gridImagePaths[i], titles[i], otherPaths[i], context)
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
Container othersTile(
    String imagePath, String tileName, String onPress, BuildContext context) {
  return Container(
    decoration: new BoxDecoration(
      // color: const Color(0xff181818),
      image: new DecorationImage(
        image: AssetImage('$imagePath'),
        colorFilter: new ColorFilter.mode(
          Colors.black.withOpacity(0.4),
          BlendMode.dstATop,
        ),
        fit: BoxFit.cover,
      ),
    ),
    child: TextButton(
      onPressed: () {
        if (onPress == '/create-pop-up') {
          createPopUp(context);
        } else if (onPress == '/inventory-pop-up') {
          inventoryPopUp(context);
        } else if (onPress == '/crowd-meter') {
          crowdMeter(context);
        } else if (onPress != null) {
          Navigator.pushNamed(context, onPress);
        }
      },
      child: Center(
        child: Text(
          tileName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ),
    ),
  );
}

Padding popUpButton(String routeName, String buttonText, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.amber,
        onPrimary: Colors.black,
        fixedSize: Size.fromWidth(150),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Text(buttonText),
    ),
  );
}

Future<dynamic> createPopUp(BuildContext context) {
  final creationPaths = [
    '/exercises/create',
    '/sets/create',
    '/groups/create',
    '/create-class',
    '/sessions/create',
  ];
  final creationButtonNames = [
    'Exercise',
    'Set',
    'Group',
    'Class',
    'Private Session'
  ];
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
              for (int i = 0; i < creationButtonNames.length; i++)
                popUpButton(creationPaths[i], creationButtonNames[i], context)
            ],
          ),
        );
      });
}

Future<dynamic> inventoryPopUp(BuildContext context) {
  final inventoryButtonNames = [
    'All Exercises',
    'All Sets',
    'All Groups',
  ];
  final inventoryPaths = [
    ExercisesScreen.viewingRouteName,
    ViewSetsScreen.viewingRouteName,
    ViewGroupsScreen.viewingRouteName,
  ];
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
              for (int i = 0; i < inventoryButtonNames.length; i++)
                popUpButton(inventoryPaths[i], inventoryButtonNames[i], context)
            ],
          ),
        );
      });
}

Future<dynamic> crowdMeter(BuildContext context) {
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
}
