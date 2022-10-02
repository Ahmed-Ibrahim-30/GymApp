import 'package:flutter/material.dart';
import 'package:gym_project/common/my-list-tile-without-trailing.dart';
import 'package:gym_project/common/my_list_tile.dart';
import 'package:gym_project/widget/grid_view_card.dart';

class PlanDetailsScreen extends StatelessWidget {
  var _group = {
    'id': 3,
    'description':
        "Numquam consequatur doloribus dolores impedit aut. Corrupti dolores et ut debitis. Unde doloremque quos ullam fuga. Et et soluta hic error quae esse qui.",
    'title': "Group 1",
    'coach_id': 3,
    'created_at': "2021-09-14 08:29:18",
    'updated_at': "2021-09-14 08:29:18",
    'sets': [
      {
        'id': 2,
        'title': "Set 1",
        'description':
            "Quod quia sint tempora ut et aut qui. Architecto exercitationem qui autem ducimus ducimus ea.",
        ' coach_id': 3,
        'created_at': "2021-09-14 08:29:15",
        'updated_at': "2021-09-14 08:29:15",
        'pivot': {
          'group_id': 3,
          'set_id': 2,
          'created_at': "2021-09-14 08:29:27",
          'updated_at': "2021-09-14 08:29:27",
        },
      },
      {
        'id': 7,
        'title': "Set 2",
        'description': "description",
        'coach_id': 3,
        'created_at': "2021-09-14 08:29:16",
        'updated_at': "2021-09-14 08:29:16",
        'pivot': {
          'group_id': 3,
          'set_id': 7,
          'created_at': "2021-09-14 08:29:28",
          'updated_at': "2021-09-14 08:29:28",
        },
      },
    ],
    'exercises': [
      {
        'id': 15,
        'description':
            "Doloremque nemo ut labore. Perferendis vel ipsum laborum facere sit saepe corporis et. Non perspiciatis iste quia voluptatem. Qui a dolorum qui eius aspernatur.",
        'duration': "12:38",
        'gif': "https://www.connelly.org/maiores-vitae-enim-omnis-et-cumque",
        'cal_burnt': 21.82,
        'title': "Exercise 1",
        'reps': 5,
        'image':
            "https://media.istockphoto.com/photos/kettlebell-and-medicine-ball-in-the-gym-equipment-for-functional-picture-id1153479113?k=20&m=1153479113&s=612x612&w=0&h=wLZnQE2GPjXJFYVpygKlNK5iyD8THMyPOGG4qFGr3xE=",
        'coach_id': 3,
        'created_at': "2021-09-14 08:29:13",
        'updated_at': "2021-09-14 08:29:13",
        'pivot': {
          'group_id': 3,
          'exercise_id': 15,
          'created_at': "2021-09-14 08:29:26",
          'updated_at': "2021-09-14 08:29:26",
        },
      },
    ],
  };
  String formatDuration(String duration) {
    String finalDuration = 'Duration: ';
    String hours = duration.substring(0, 2);
    if (hours != '00') {
      if (hours[0] == '0') {
        finalDuration += '${hours[1]}h';
      } else {
        finalDuration += '${hours}h';
      }
    }
    String minutes = duration.substring(3, 5);
    if (minutes != '00') {
      if (minutes[0] == '0') {
        finalDuration += ' ${minutes[1]}m';
      } else {
        finalDuration += ' ${minutes}m';
      }
    }
    if (duration.length == 8) {
      String seconds = duration.substring(6);
      if (seconds != '00') {
        if (seconds[0] == '0') {
          finalDuration += ' ${seconds[1]}s';
        } else {
          finalDuration += ' ${seconds}s';
        }
      }
    }
    return finalDuration;
  }

  @override
  Widget build(BuildContext context) {
    for (Map<String, Object> set in _group['sets']) {
      print(set['title']);
      print(set['description']);
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
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
              Container(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                child: Text(
                  _group['title'],
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
                  _group['description'],
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "Exercises",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  ),
                ),
              ),
              for (Map<String, Object> exercise in _group['exercises'])
                CustomListTileNoTrailing(
                  exercise['title'],
                  [
                    formatDuration(exercise['duration']),
                    '${exercise['cal_burnt']} cal'
                  ],
                ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "Sets",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  ),
                ),
              ),
              for (Map<String, Object> set in _group['sets'])
                CustomListTileNoTrailing(
                  set['title'],
                  [set['description']],
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
    );
  }
}
