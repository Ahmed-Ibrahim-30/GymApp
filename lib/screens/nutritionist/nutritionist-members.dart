import 'package:flutter/material.dart';
import 'package:gym_project/models/user/member_model.dart';
import 'package:gym_project/models/nutritionist/plan.dart';
import 'package:gym_project/screens/coach/assign-groups.dart';
import 'package:gym_project/screens/nutritionist/plan-schedule.dart';
import 'package:gym_project/screens/nutritionist/plans-screen.dart';
import 'package:gym_project/screens/nutritionist/view-plans-details-screen.dart';
import 'package:gym_project/viewmodels/nutritionist/plan-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';

class NutritionistMembersScreen extends StatefulWidget {
  @override
  _NutritionistMembersScreenState createState() =>
      _NutritionistMembersScreenState();
}

class _NutritionistMembersScreenState extends State<NutritionistMembersScreen> {
  final length = 12;
  List<Member> members = [];
  bool loading = false;

  void fetchPlan(int id) {
    new Future<Plan>.sync(() =>
        Provider.of<PlanViewModel>(context, listen: false)
            .fetchActivePlan(id, context)).then((Plan value) {
      setState(() {
        loading = false;

        if (value != null) //should load member profile?
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlansDetailsScreen(
                  selectedPlan: value,
                  includeAppBar: true,
                ),
              ));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMembersList();
  }

  String duration = "2 months";
  bool done = false;
  bool error = false;
  var membersViewModel;

  getMembersList() {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: !loading
          ? ListView(
              children: [
                SizedBox(height: 20),
                error
                    ? CustomErrorWidget()
                    : done && members.isEmpty
                        ? EmptyListError('No members found.')
                        : members.isEmpty
                            ? Progress()
                            : loadMembersList(context),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  ListView loadMembersList(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: members.length,
        itemBuilder: (ctx, index) {
          return myListTile(
            members[index],
            index,
            context,
          );
        });
  }

  Widget myListTile(Member member, int index, BuildContext context) {
    print(member.id);
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          loading = true;
          fetchPlan(member.id);
          //setState(() {});
        },
        minVerticalPadding: 10,
        leading: CircleAvatar(
          radius: 20,
          child: Icon(Icons.note),
        ),
        title: Text(
          member.name,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              child: Text(
                'Active',
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
                      builder: (context) => PlanSchedule(id: member.id),
                    ));
              },
            ),
            SizedBox(
              width: 15,
            ),
            TextButton(
              child: Text(
                'Assign',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              onPressed: () async {
                assignPlanPopUp();
              },
            ),
            SizedBox(
              width: 15,
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              onPressed: () {
                myPopUp();
              },
            ),
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  void deletePlan(BuildContext context, int index) {
    new Future<bool>.sync(() =>
        Provider.of<PlanViewModel>(context, listen: false)
            .deleteActivePlan(members[index].id, context)).then((value) => () {
          refresh();
        });
  }

  void assignPlan(
      BuildContext context, int index, int planID, String duration) {
    new Future<bool>.sync(() =>
        Provider.of<PlanViewModel>(context, listen: false).assignActivePlan(
            members[index].id, context, planID, duration)).then((value) => () {
          refresh();
        });
  }

  Future<Widget> myPopUp() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xff181818),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    deletePlan(context, index);
                    Navigator.pop(context);
                  },
                  child: Text("Confirm"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                ),
              ],
            ),
          );
        });
  }

  Future<Widget> assignPlanPopUp() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: "Enter Duration"),
                  onChanged: (value) {
                    duration = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Plan result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlansViewScreen(true),
                        ));

                    assignPlan(context, index, result.id, duration); //duration!
                    Navigator.pop(context);
                  },
                  child: Text("Choose Plan"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                ),
              ],
            ),
          );
        });
  }
}
