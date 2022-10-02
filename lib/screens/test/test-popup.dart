import 'package:flutter/material.dart';

// import 'my_list_view.dart';

class TestPopUp extends StatefulWidget {
  const TestPopUp({Key key}) : super(key: key);

  @override
  _TestPopUpState createState() => _TestPopUpState();
}

class _TestPopUpState extends State<TestPopUp> {
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
                        child: Text('Admin'),
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
                        child: Text('Coach'),
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
                        child: Text('Member'),
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
                          //       builder: (context) => Scaffold(
                          //             body: MyListView(),
                          //           )),
                          // );
                        },
                        child: Text('Nutritionist'),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
