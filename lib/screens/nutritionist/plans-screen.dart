import 'package:flutter/material.dart';
import 'package:gym_project/models/nutritionist/plan.dart';
import 'package:gym_project/models/nutritionist/plans.dart';
import 'package:gym_project/screens/nutritionist/plan-creation-form.dart';
import 'package:gym_project/screens/nutritionist/view-plans-details-screen.dart';
import 'package:gym_project/viewmodels/nutritionist/plan-view-model.dart';
import 'package:provider/provider.dart';
import '../../widget/global.dart';

class PlansViewScreen extends StatefulWidget {
  bool isSelectionTime = false;

  PlansViewScreen(this.isSelectionTime);
  @override
  _PlansViewScreenState createState() => _PlansViewScreenState();

  static int whoIsSelected = -1;
}

void deletePlan(BuildContext context, int planID, Function refresh) {
  new Future<bool>.sync(() => Provider.of<PlanViewModel>(context, listen: false)
      .deletePlan(context, planID)).then((value) => refresh());
}

class _PlansViewScreenState extends State<PlansViewScreen> {
  bool finishedLoading = false;
  Plans plans = Plans(data: []);
  TextEditingController controller = TextEditingController();
  int currentPage = 1;
  ScrollController scrollController = ScrollController();

  void fetchPlans(String searchText, int currentPage) {
    new Future<Plans>.sync(() =>
        Provider.of<PlanViewModel>(context, listen: false).fetchPlans(context,
            searchText: searchText,
            currentPage: currentPage)).then((Plans value) {
      setState(() {
        if (!finishedLoading) {
          if (currentPage == 1)
            plans = value;
          else
            plans.data.addAll(value.data);
          finishedLoading = true;
        }
      });
    });
  }

  void refresh() {
    setState(() {
      finishedLoading = false;
      fetchPlans(controller.text, currentPage);
    });
  }

  @override
  void initState() {
    super.initState();

    fetchPlans('', 1);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<PlanViewModel>(context);
    return Scaffold(
      appBar: AppBar(
            title: Text(
              "Diet Plans",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "assets/fonts/Changa-Bold.ttf"),
            ),
            backgroundColor: Colors.black, //Color(0xff181818),
            iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),),
      floatingActionButton: Global.role == "admin" || Global.role == "nutritionist"
              ? Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-plan');
                    },
                    isExtended: false,
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: MediaQuery.of(context).size.width * 0.1,
                )
              : Container(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top:10),
              child: true
                  ? ListView(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: plans.data.length,
                            itemBuilder: (ctx, index) {
                              return myListTile(
                                  plans.data[index].title,
                                  'Description: ' +
                                      plans.data[index].description,
                                  index,
                                  widget.isSelectionTime,
                                  plans.data[index],
                                  context);
                            }),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            if (PlansViewScreen.whoIsSelected != -1)
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFFCE2B)),
                        child: Text('Submit'),
                        onPressed: () {
                          if (widget.isSelectionTime) {
                            Navigator.pop(context,
                                plans.data[PlansViewScreen.whoIsSelected]);
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFFCE2B), elevation: 10),
                        child: Text('Cancel'),
                        onPressed: () {
                          setState(() {
                            PlansViewScreen.whoIsSelected = -1;
                          });
                        },
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget myListTile(String title, String description, int index,
      bool selectionTime, Plan plan, BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        color: PlansViewScreen.whoIsSelected == index
            ? Colors.white24
            : Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            if (selectionTime)
              PlansViewScreen.whoIsSelected = index;
            else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlansDetailsScreen(
                        selectedPlan: plan, role: 'nutritionist'),
                  ));
            }
          });
        },
        selected: PlansViewScreen.whoIsSelected == index,
        minVerticalPadding: 10,
        leading: CircleAvatar(
          radius: 20,
          child: Icon(Icons.note),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              description,
              style: TextStyle(color: Colors.white24),
            ),
            if (selectionTime)
              TextButton(
                child: Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlansDetailsScreen(
                            selectedPlan: plan, role: 'nutritionist'),
                      ));
                },
              ),
          ],
        ),
        trailing: !selectionTime
            ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        CreatePlanForm.editingRouteName,
                        arguments: plan.id,
                      );
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      deletePlan(context, plan.id, refresh);
                    },
                    child: Text('Delete',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
