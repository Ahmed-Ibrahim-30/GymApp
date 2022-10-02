import 'package:flutter/material.dart';

class CreationPopUp extends StatefulWidget {
  const CreationPopUp({Key key}) : super(key: key);

  @override
  _CreationPopUpState createState() => _CreationPopUpState();
}

class _CreationPopUpState extends State<CreationPopUp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber)),
        child: Text('Create'),
        onPressed: () {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                            fixedSize: Size.fromWidth(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => Scaffold(
                          //             body: MyListView(),
                          //           )),
                          // );
                        },
                        child: Text('Exercises'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                            fixedSize: Size.fromWidth(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => MyListView()),
                          // );
                        },
                        child: Text('Sets'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                            fixedSize: Size.fromWidth(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => MyListView()),
                          // );
                        },
                        child: Text('Classes'),
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
