import 'package:flutter/material.dart';
import 'package:gym_project/widget/global.dart';

Future<dynamic> showErrorMessage(BuildContext context, String message) {
  String role = Global.role;
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
              Text(
                'Failure',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Center(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
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
                  if (role == 'admin') {
                    Navigator.pushReplacementNamed(
                      context,
                      '/admin/util',
                    );
                  } else if (role == 'coach') {
                    Navigator.pushReplacementNamed(
                      context,
                      '/coach/util',
                    );
                  } else if (role == 'nutritionist') {
                    Navigator.pushReplacementNamed(
                        context, '/nutritionist/util');
                  } else if (role == 'member') {
                    Navigator.pushReplacementNamed(context, '/member/util');
                  }
                },
                child: Text('Go to homepage'),
              ),
            ],
          ),
        );
      });
}
