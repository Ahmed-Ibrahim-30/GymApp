import 'package:flutter/material.dart';
import 'package:gym_project/core/presentation/res/assets.dart';
import 'package:gym_project/widget/grid_view_card.dart';

class GridViewScreen extends StatelessWidget {
  const GridViewScreen({Key key}) : super(key: key);
  static final String path = "lib/src/pages/ecommerce/ecommerce5.dart";

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Colors.black,
            ),
            width: double.infinity,
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
                    topRight: Radius.circular(0))),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Equipment",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      SizedBox(
                        height: 40,
                      ),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          controller: TextEditingController(text: 'Search...'),
                          cursorColor: Theme.of(context).primaryColor,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                              suffixIcon: Material(
                                elevation: 2.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(Icons.search),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(26.0),
                sliver: SliverGrid.count(
                  crossAxisCount: deviceSize.width < 450
                      ? deviceSize.width < 900
                          ? 2
                          : 3
                      : deviceSize.width < 900
                          ? 3
                          : 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: <Widget>[
                    GridViewCard(dumbbell, 'Dumbbell', 'Sub Title 1',
                        'Sub Title 2', 'Sub Title 3', 'Sub Title 4', context),
                    GridViewCard(treadmill, 'Treadmill', 'Sub Title 1',
                        'Sub Title 2', 'Sub Title 3', 'Sub Title 4', context),
                    GridViewCard(dumbbell, 'Dumbbell', 'Sub Title 1',
                        'Sub Title 2', 'Sub Title 3', 'Sub Title 4', context),
                    GridViewCard(treadmill, 'Treadmill', 'Sub Title 1',
                        'Sub Title 2', 'Sub Title 3', 'Sub Title 4', context),
                    GridViewCard(dumbbell, 'Dumbbell', 'Sub Title 1',
                        'Sub Title 2', 'Sub Title 3', 'Sub Title 4', context),
                    GridViewCard(treadmill, 'Treadmill', 'Sub Title 1',
                        'Sub Title 2', 'Sub Title 3', 'Sub Title 4', context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
