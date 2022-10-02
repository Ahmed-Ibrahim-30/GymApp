import 'package:animations/animations.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/common/my_list_tile_without_counter.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/user/user_model.dart';
import 'package:gym_project/screens/admin/users/create_user.dart';
import 'package:gym_project/screens/admin/users/user_details.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import '../../../widget/global.dart';


class UsersList extends StatefulWidget {
  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> with TickerProviderStateMixin {
  TabController _myTabController;

  @override
  void initState() {
    super.initState();

    _myTabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _myTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit myCubit=AdminCubit.get(context);
        return Scaffold(
          appBar: new AppBar(
            backgroundColor: myBlack,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: new Size(0, 0),
              child: Container(
                child: TabBar(
                    unselectedLabelColor: Colors.amber,
                    labelColor: Colors.amber,
                    indicatorColor: Colors.amber,
                    controller: _myTabController,
                    tabs: [
                      Tab(text: 'Members',),
                      Tab(text: 'Coaches',),
                      Tab(text: 'Nutritionist',)
                    ]),
              ),
            ),
          ),
          body: ConditionalBuilder(
            condition: membersUsers.isNotEmpty || coachesUsers.isNotEmpty ||nutritionistsUsers.isNotEmpty,
            builder: (context){
              return TabBarView(
                controller: _myTabController,
                children: [
                  AllScreen(membersUsers,myCubit),
                  AllScreen(coachesUsers,myCubit),
                  AllScreen(nutritionistsUsers,myCubit),
                ],
              );
            },
            fallback: (context)=>ConditionalBuilder(
              condition: myCubit.isLoadingUser,
              builder: (context){
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3.r,
                    color: Color(0xFFFFCE2B),
                  ),
                );
              },
            ),
          )
        );
      },
    );
  }
}

class AllScreen extends StatelessWidget {
  final users;
  final AdminCubit myCubit;
  final bool showDetails;
  AllScreen(this.users,this.myCubit,{this.showDetails=true});
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
        condition: users.isNotEmpty,
        builder: (context)=>Container(
          color: myBlack,
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h, bottom: 5.h),
          child: ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (ctx,index)=>SizedBox(height: 8.h,),
              itemCount: users.length,
              itemBuilder: (ctx, index) {
                return Container(
                  child: InkWell(
                    onTap: showDetails?(){goToAnotherScreenPush(context, UserProfile(
                      user:
                      users[index].role=="member"?membersUsers[users[index].index]:
                      users[index].role=="coach"?coachesUsers[users[index].index]:
                      nutritionistsUsers[users[index].index]
                      ,adminCubit: myCubit,));}:null,
                    child: Padding(
                      padding: index!=users.length-1?EdgeInsets.zero:EdgeInsets.only(bottom: 10.h),
                      child: CustomListTileWithoutCounter(
                        'assets/images/user_icon.png',
                        users[index].name,
                        users[index].number,
                        users[index].role,
                        users[index].email,
                        isUser: true,
                      ),
                    ),
                  ),
                );
              })
        ),
      fallback: (context)=>Center(
        child: Text(
          "No Users Found !!",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

class AnimationList extends StatelessWidget {
  final users;
  final AdminCubit myCubit;
  final bool showDetails;
  AnimationList(this.users,this.myCubit,{this.showDetails=true});

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final myTween = Tween<Offset>(
    begin: const Offset(-1.0, 0.0),
    end: Offset.zero,
  );
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: users.isNotEmpty,
      builder: (context)=>Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
        child: AnimatedList(
          initialItemCount: users.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return SlideTransition(
              position: animation.drive(myTween),
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 4.h),
                child: InkWell(
                  onTap: showDetails?(){goToAnotherScreenPush(context, UserProfile(user:users[index],adminCubit: myCubit,));}:null,
                  child: CustomListTileWithoutCounter(
                    'assets/images/user_icon.png',
                    users[index].name,
                    users[index].number,
                    users[index].role,
                    users[index].email,
                  ),
                ),
              ),
            );
          },

        ),
      ),
      fallback: (context)=>Center(
        child: Text(
          "No Users Found !!",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);
  //transitionDuration:  Duration(seconds: 1),

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // if (settings.isInitialRoute)
    //   return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    //return new FadeTransition(opacity: animation, child: child);

    // return new RotationTransition(
    //     turns: animation,
    //     child: new ScaleTransition(
    //       scale: animation,
    //       child: new FadeTransition(
    //         opacity: animation,
    //         child: child,
    //       ),
    //     ));

    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.elasticInOut),
      child: child,
    );
  }
}


class MyCustomRoute2<T> extends MaterialPageRoute<T> {
  MyCustomRoute2({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);
  //transitionDuration:  Duration(seconds: 1),

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}//bottom to top

class MyCustomRoute3<T> extends MaterialPageRoute<T> {
  MyCustomRoute3({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);
  //transitionDuration:  Duration(seconds: 1),

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    final tween = Tween(begin: begin, end: end);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: child,
    );
  }
}//bottom to top



