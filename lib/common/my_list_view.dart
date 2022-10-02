import 'package:flutter/material.dart';

import 'my_list_tile.dart';

// ignore: must_be_immutable
class MyListView extends StatefulWidget {
  IconData iconData = Icons.ac_unit;
  String title = 'Title';
  String subtitle1 = 'Subtitle 1';
  String subtitle2 = 'Subtitle 2';
  String subtitle3 = 'Subtitle 3';

  MyListView(
      {this.iconData,
      this.title,
      this.subtitle1,
      this.subtitle2,
      this.subtitle3});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  final List<dynamic> users = [
    {
      'name': 'Osama',
      'branch': 'Branch 1',
      "photo":
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
    },
    {
      'name': 'Abdo',
      'branch': 'Branch 2',
      "photo":
          'https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
    }
  ];

  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsetsDirectional.all(10),
      child: Column(
        children: [
          Material(
              elevation: 5.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                controller: TextEditingController(text: 'Search...'),
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                    suffixIcon: Material(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(Icons.search),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              )),
          SizedBox(height: 20),
          ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (ctx, index) {
                return CustomListTile(
                    widget.title, ['sub 1', 'sub 2', 'sub 3']);
              }),
        ],
      ),
    );
  }
}
