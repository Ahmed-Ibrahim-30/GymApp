import 'package:flutter/material.dart';
import 'package:gym_project/models/exercise.dart';
import 'package:gym_project/style/duration.dart';
import 'package:gym_project/viewmodels/set-list-view-model.dart';
import 'package:gym_project/viewmodels/set-view-model.dart';
import 'package:gym_project/widget/grid_view_card.dart';
import 'package:provider/provider.dart';

class SetDetailsScreen extends StatefulWidget {
  final int id;

  SetDetailsScreen(this.id);
  @override
  _SetDetailsScreenState createState() => _SetDetailsScreenState();
}

class _SetDetailsScreenState extends State<SetDetailsScreen> {
  SetViewModel _set;

  @override
  void initState() {
    super.initState();
    Provider.of<SetListViewModel>(context, listen: false)
        .fetchSetDetails(widget.id)
        .then((value) {
      setState(() {
        var setListViewModel =
            Provider.of<SetListViewModel>(context, listen: false);
        _set = setListViewModel.set;
      });
    }).catchError((err) {
      print('$err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _set == null
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : SafeArea(
              child: Stack(
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
                          _set.title,
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
                          _set.description,
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
                      if (_set.exercises.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Text(
                            "Exercises",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'assets/fonts/Changa-Bold.ttf',
                            ),
                          ),
                        ),
                      CustomScrollView(
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.all(26.0),
                            sliver: SliverGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              children: <Widget>[
                                for (Exercise exercise in _set.exercises)
                                  GridViewCard(
                                      exercise.image,
                                      exercise.title,
                                      formatDuration(exercise.duration),
                                      '',
                                      '',
                                      '',
                                      context)
                              ],
                            ),
                          ),
                        ],
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

Widget ExerciseGridViewCard(image, title, List<String> subtitles) {
  return Container(
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
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 80,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              )),
          for (var subtitle in subtitles)
            Text(subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black,
                )),
        ],
      ),
    ),
  );
}
