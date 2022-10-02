import 'package:flutter/material.dart';
import 'package:gym_project/viewmodels/fitness-summary-list-view-model.dart';
import 'package:gym_project/viewmodels/fitness-summary-view-model.dart';
import 'package:gym_project/widget/custom-back-button-2.dart';
import 'package:provider/provider.dart';

class FitnessSummaryScreen extends StatefulWidget {
  final id;

  FitnessSummaryScreen(this.id);

  @override
  _FitnessSummaryScreenState createState() => _FitnessSummaryScreenState();
}

class _FitnessSummaryScreenState extends State<FitnessSummaryScreen> {
  FitnessSummaryViewModel fitnessSummary;
  void initState() {
    super.initState();
    getFitnessSummary();
  }

  refresh() {
    setState(() {});
  }

  String startDate;

  String endDate;

  bool done = false;

  bool error = false;

  var fitnessSummaryViewModel;

  getFitnessSummary() {
    Provider.of<FitnessSummaryListViewModel>(context, listen: false)
        .fetchFitnessSummary(widget.id)
        .then((value) {
      fitnessSummaryViewModel =
          Provider.of<FitnessSummaryListViewModel>(context, listen: false);
      setState(() {
        done = true;
        fitnessSummary = fitnessSummaryViewModel.fitnessSummary;
      });
    }).catchError((err) {
      error = true;
      print('error occured $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
              )),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff181818),
          iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
        ),
        backgroundColor: Colors.black,
        body: error
            ? SafeArea(
                child: Center(
                    child: Text('An error occurred',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ))),
              )
            : fitnessSummary == null
                ? SafeArea(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : SafeArea(
                    child: myGridView(context, fitnessSummary),
                  ),
      ),
    );
  }

  Widget myGridView(context, FitnessSummaryViewModel fitSum) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          width: double.infinity,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 35, top: 50),
                  child: Text('Fitness \nSummary',
                      style: TextStyle(fontSize: 40, color: Colors.white)),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: GridView.count(
                    padding: const EdgeInsets.all(26.0),
                    crossAxisCount: deviceSize.width < 450
                        ? deviceSize.width < 900
                            ? 2
                            : 3
                        : deviceSize.width < 900
                            ? 3
                            : 4,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    shrinkWrap: true,
                    children: [
                      GridViewCard(Icons.water, 'Weight', 'Range: 0 - 250',
                          'Value: ${fitSum.weight}'),
                      GridViewCard(Icons.water, 'SMM', 'Range: 0 - 100',
                          'Value: ${fitSum.SMM}'),
                      GridViewCard(Icons.water, 'BMI', 'Range: 0 - 100',
                          'Value: ${fitSum.BMI}'),
                      GridViewCard(Icons.water, 'Muscle Ratio',
                          'Range: 0 - 100', 'Value: ${fitSum.muscleRatio}'),
                      GridViewCard(Icons.water, 'Height', 'Range: 0 - 250',
                          'Value: ${fitSum.height}'),
                      GridViewCard(Icons.water, 'Fat Ratio', 'Range: 0 - 100',
                          'Value: ${fitSum.fatRatio}'),
                      GridViewCard(Icons.water, 'Protein', 'Range: 0 - 100',
                          'Value: ${fitSum.protein}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 230, bottom: 20),
          width: 220,
          height: 190,
          decoration: BoxDecoration(
            color: Color(0xFFFFCE2B),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(190),
                bottomLeft: Radius.circular(290),
                bottomRight: Radius.circular(160),
                topRight: Radius.circular(0)),
          ),
        ),
      ]),
    ));
  }

  Widget GridViewCard(image, title, subTitle1, subTitle2) {
    return Container(
      height: 200,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(image),
            SizedBox(
              height: 5,
            ),
            Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                )),
            Text(subTitle1,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.black,
                )),
            Text(subTitle2,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
