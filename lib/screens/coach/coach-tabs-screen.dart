import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/coach_cubit/coach_cubit.dart';
import 'package:gym_project/screens/admin/classes/create_class.dart';
import 'package:gym_project/screens/coach/home-screen.dart';
import 'package:gym_project/screens/coach/my-classes-screen.dart';
import 'package:gym_project/screens/coach/my-members-screen.dart';
import 'package:gym_project/screens/coach/others-screen.dart';
import 'package:gym_project/screens/coach/private%20sessions/sessions-screen.dart';
import 'package:gym_project/widget/global.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../all_data.dart';
import '../../bloc/coach_cubit/coach_states.dart';
import '../../constants.dart';
import '../../services/supplementary-webservice.dart';
import '../../viewmodels/event-view-model.dart';
import '../../widget/drawer.dart';
import 'home-screen.dart';

class CoachTabsScreen extends StatefulWidget {
  const CoachTabsScreen({Key key}) : super(key: key);
  static bool fetchAllFunction=false;
  @override
  _CoachTabsScreenState createState() => _CoachTabsScreenState();
}

class _CoachTabsScreenState extends State<CoachTabsScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0; // 0 => home page
  TabController _tabController;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  Future<void> getAllSupplementaries() async {
    supplementariesList = await SupplementaryWebService(Global.token).getAllSupplementaries();
  }

  void fetchAllFunction()async{
    if(!CoachTabsScreen.fetchAllFunction){
      await CoachCubit.get(context).fetchUserCoach();
      await CoachCubit.get(context).fetchAllBranches();
      await CoachCubit.get(context).fetchAllEquipments();
      await CoachCubit.get(context).fetchAllClasses();
      await CoachCubit.get(context).fetchAllAnnouncements();
      await CoachCubit.get(context).fetchAllQuestions();
      await getAllSupplementaries();
      await CoachCubit.get(context).fetchAllEvents(context);
      CoachTabsScreen.fetchAllFunction=true;
    }
  }
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    //fetchAllFunction();
    _pages = [
      {
        'page': CoachHomeScreen(),
        'title': 'Homepage',
      },
      {
        'page': MyClassesList(),
        'title': 'My Classes',
      },
      {
        'page': SessionsScreen(_tabController),
        'title': 'My Sessions',
      },
      {
        'page': MyMembersScreen(),
        'title': 'My members',
      },
      {
        'page': OthersScreen(),
        'title': 'Others',
      },
    ];
    super.initState();
  }

  String name = Global.username;
  String email = Global.email;
  var _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoachCubit,CoachStates>(
      listener: (context,state){},
      builder: (context,state){
        CoachCubit coachCubit=CoachCubit.get(context);
        return Scaffold(
          floatingActionButton: _selectedIndex==1?FloatingActionButton.extended(
            onPressed: () {
              goToAnotherScreenPush(context, CreateClassForm(coachCubit: coachCubit,));
            },
            isExtended: false,
            icon: Icon(Icons.add, size: 25),
            label: Container(),
          ):SizedBox(),
          extendBody: true,
          appBar: AppBar(
            title: Text(
              _pages[_selectedIndex]['title'],
              style: TextStyle(color: myYellow2, fontWeight: FontWeight.bold),
            ),
            backgroundColor: myBlack,
            elevation: 0.0,
            bottom: _selectedIndex == 2 ? TabBar(
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.white,
              controller: _tabController,
              tabs: [
                Tab(
                  text: "Session Types",
                ),
                Tab(
                  text: "Booked Sessions",
                ),
              ],
            )
                : null,
          ),
          drawer: MyDrawer(name,email),
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 900),
            transitionBuilder: (child,animation,secondaryAnimation){
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child:_pages[_selectedIndex]['page'],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            color: HexColor("E2DCC8"),
            height: 40.h,
            buttonBackgroundColor: HexColor("F8B400"),
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            index: _selectedIndex,
            animationDuration: Duration(milliseconds: 600),
            key: _bottomNavigationKey,
            items: <Widget>[
              Icon(Icons.home, size: 26.sp),
              Icon(Icons.class_, size: 26.sp),
              Icon(Icons.business, size: 26.sp),
              Icon(Icons.people, size: 26.sp),
              Icon(Icons.view_list, size: 26.sp),
            ],
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}
