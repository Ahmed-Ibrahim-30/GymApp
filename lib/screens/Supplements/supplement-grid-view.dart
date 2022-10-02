import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/coach_cubit/coach_cubit.dart';
import 'package:gym_project/bloc/coach_cubit/coach_states.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/core/presentation/res/assets.dart';
import 'package:gym_project/models/supplementary.dart';
import 'package:gym_project/screens/Supplements/supplement-card.dart';
import 'package:gym_project/screens/Supplements/supplement-form.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:gym_project/viewmodels/supplementary-view-model.dart';
import 'package:provider/provider.dart';
import '../../all_data.dart';
import '../../widget/global.dart';

class SupplementList extends StatefulWidget {
  List<Supplementary> allSupplements = [];
  @override
  _SupplementListState createState() => _SupplementListState();
}

class _SupplementListState extends State<SupplementList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getAllSupplements();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return BlocConsumer<CoachCubit,CoachStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: myBlack,
            elevation: 0.0,
            leading: backButton(context: context),
            title: Text("Supplements",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
          backgroundColor: myBlack,
            floatingActionButton: Global.role == 'admin'
                ? Container(
              child: FloatingActionButton.extended(
                onPressed: () {
                  //Navigator.pushNamed(context, '/create-supplement');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SupplementForm(
                            type: 'add',
                          )));
                },
                isExtended: false,
                label: Icon(Icons.add),
              ),
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 0.1,
            )
                : Container(),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndFloat,
            body: CustomScrollView(
              slivers: <Widget>[
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
                      for (int index = 0;
                      index < supplementariesList.length;
                      index++)
                        SupplementCard(
                          dumbbell,
                          supplementariesList[index].title,
                          supplementariesList[index].price,
                          context,
                          supplementariesList[index].id,
                          supplementariesList[index].description,
                        )
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> getAllSupplements() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        widget.allSupplements =
            Provider.of<SupplementaryViewModel>(context, listen: false)
                .supplemetaries;
      });
    });
  }
}
