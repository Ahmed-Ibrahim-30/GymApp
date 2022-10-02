import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';

class PieChartSample3 extends StatefulWidget {
  PieChartSample3({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State{
  int touchedIndex = 0;
  Color myBlack=Color(0xff181818);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit adminCubit=AdminCubit.get(context);

        return AspectRatio(
          aspectRatio: 1.0,
          child: Card(
            color: myBlack,
            child: AspectRatio(
              aspectRatio: 1,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex =
                                      pieTouchResponse.touchedSection.touchedSectionIndex;
                                });
                              }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 0,
                          sections: showingSections()),
                    ),
                  ),
                  SizedBox(height: 8.h,),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.amber,radius: 7.r,),
                            SizedBox(height: 5.h,),
                            CircleAvatar(
                              backgroundColor: Colors.orange,radius: 7.r,),
                            SizedBox(height: 5.h,),
                            CircleAvatar(
                              backgroundColor: const Color(0xff0293ee),radius: 7.r,),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Coaches',style: GoogleFonts.poppins(
                                fontSize:14.sp,fontWeight:FontWeight.w500,color: Colors.white
                            ),),
                            Text('Members',style: GoogleFonts.poppins(
                                fontSize:14.sp,fontWeight:FontWeight.w500,color: Colors.white
                            ),),
                            Text(' Nutritionists',style: GoogleFonts.poppins(
                                fontSize:14.sp,fontWeight:FontWeight.w500,color: Colors.white
                            ),)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0.sp : 16.0.sp;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      int allUsers=membersUsers.length+coachesUsers.length+nutritionistsUsers.length;
      int num1 ;
      int num2;
      int num3;
      if(allUsers==0){
        num1=num2=num3=0;
      }
      else{
        num1 = ((nutritionistsUsers.length/allUsers)*100).round();
        num2= ((coachesUsers.length/allUsers)*100).round();
        num3 = ((membersUsers.length/allUsers)*100).round();
      }
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: nutritionistsUsers.length.toDouble(),
            title: "${num1}%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/images/nutritionist.svg',
              size: widgetSize,
              borderColor: const Color(0xff0293ee),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.amber,
            value: coachesUsers.length.toDouble(),
            title: "${num2}%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/images/coach.svg',
              size: widgetSize,
              borderColor: const Color(0xfff8b250),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.orange,
            value: membersUsers.length.toDouble(),
            title: "${num3}%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/images/person.svg',
              size: widgetSize,
              borderColor: Colors.orange,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw 'Oh no';
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
      this.svgAsset, {
        Key key,
        @required this.size,
        @required this.borderColor,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}