import 'package:flutter/material.dart';

class CrowdMeter extends StatelessWidget {
  const CrowdMeter({
    Key key,
    @required this.checkedInMembers,
    @required this.totalMembers,
  }) : super(key: key);

  final int checkedInMembers;
  final int totalMembers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        // Text(
        //   'CROWD METER',
        //   style: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //     fontFamily: 'Changa',
        //     color: Colors.white,
        //   ),
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: checkedInMembers / totalMembers,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Current Members: $checkedInMembers',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
