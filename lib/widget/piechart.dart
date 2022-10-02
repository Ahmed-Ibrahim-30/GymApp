import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pie_chart/pie_chart.dart';

class FinancesPieChart extends StatelessWidget {
  const FinancesPieChart({
    Key key,
    @required this.dataMap,
  }) : super(key: key);

  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 900;

    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: isWide ? 200 : MediaQuery.of(context).size.width / 3.2,
          colorList: [Colors.white, Colors.amber],
          initialAngleInDegree: 0,
          chartType: ChartType.disc,
          ringStrokeWidth: 32,
          centerText: "",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            //legendShape: _BoxShape.circle,
            legendTextStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: true,
            decimalPlaces: 0,
          ),
        ),
      ),
    );
  }
}
