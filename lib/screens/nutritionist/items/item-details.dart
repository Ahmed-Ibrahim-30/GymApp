import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatelessWidget {
  final _item = {
    'id': 1,
    'title': "Carrot",
    'level': 'green',
    'cal': 28.95,
    'image': "https://www.owimio.com/wp-content/uploads/2021/02/carrot.jpg",
    'nutritionist': 'Amr Fatouh',
  };

  Color mapLevelToColor(String level) {
    if (level == 'red') {
      return Colors.red.shade400;
    } else if (level == 'yellow') {
      return Colors.yellow.shade400;
    } else if (level == 'green') {
      return Colors.green.shade400;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
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
                  _item['image'],
                  fit: BoxFit.cover,
                ),
                height: MediaQuery.of(context).size.height * 0.6,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                    child: Text(
                      _item['title'],
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'assets/fonts/Changa-Bold.ttf',
                      ),
                    ),
                  ),
                  Container(
                    child: Text("${_item['cal']} cal",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 15,
                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                        )),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: RichText(
                  text: TextSpan(
                      text: 'Level: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'assets/fonts/Changa-Bold.ttf',
                      ),
                      children: [
                        TextSpan(
                          text: '${_item['level']}',
                          style: TextStyle(
                            color: mapLevelToColor(_item['level']),
                          ),
                        )
                      ]),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Created By: ${_item['nutritionist']}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  ),
                ),
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
