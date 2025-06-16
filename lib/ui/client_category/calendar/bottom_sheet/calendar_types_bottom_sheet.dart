import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';


class CalendarTypesBottomSheet extends StatefulWidget {
  const CalendarTypesBottomSheet({super.key, required this.list, required this.selectedList});

  final List<String> list;
  final List<String> selectedList;

  @override
  State<CalendarTypesBottomSheet> createState() => _CalendarTypesBottomSheetState();
}

class _CalendarTypesBottomSheetState extends State<CalendarTypesBottomSheet> {
  List<String> selectedList = [];
  List<String> list = [];
  List<String> googleCalendarsList = [];

  @override
  void initState() {
    getList();
    super.initState();
  }

  getList(){
    if(mounted){
      setState(() {
        selectedList = widget.selectedList;
      });

      widget.list.forEach((element){
        if(element.contains("@")){
          setState(() {
            googleCalendarsList.add(element);
          });
        }
        else{
          setState(() {
            list.add(element);
          });
        }
      });

      if(list.isNotEmpty){
        list.sort((a, b) => a.compareTo(b));
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.basicwhiteColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.limeColor,
          ),
          SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 610.h,
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Text(
                            "Мои календари",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                                color: AppColors.vivaMagentaColor,
                                fontSize: 14.sp
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index){

                            return FormForButton(
                              borderRadius: BorderRadius.zero,
                              onPressed: (){
                                setState(() {
                                  if(selectedList.contains(list[index])){
                                    selectedList.remove(list[index]);
                                  }
                                  else{
                                    selectedList.add(list[index]);
                                  }
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        list[index],
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.darkGreenColor,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 12.r,
                                      backgroundColor: selectedList.contains(list[index]) ? AppColors.vivaMagentaColor : AppColors.limeColor,
                                      child: !selectedList.contains(list[index])
                                          ? const SizedBox()
                                          : Center(
                                        child: SvgPicture.asset(
                                          'assets/images/checkmark.svg',
                                          color: AppColors.basicwhiteColor,
                                          height: 16.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Visibility(
                          visible: googleCalendarsList.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 18.h),
                              Container(
                                height: 1.h,
                                decoration: BoxDecoration(
                                    gradient: AppColors.gradientTurquoise2Reverse
                                ),
                              ),
                              SizedBox(height: 18.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: Text(
                                  "Подписки google календарей",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Inter",
                                      color: AppColors.vivaMagentaColor,
                                      fontSize: 14.sp
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: googleCalendarsList.length,
                                itemBuilder: (context, index){

                                  return FormForButton(
                                    borderRadius: BorderRadius.zero,
                                    onPressed: (){
                                      setState(() {
                                        if(selectedList.contains(googleCalendarsList[index])){
                                          selectedList.remove(googleCalendarsList[index]);
                                        }
                                        else{
                                          selectedList.add(googleCalendarsList[index]);
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              googleCalendarsList[index],
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.darkGreenColor,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 12.r,
                                            backgroundColor: selectedList.contains(googleCalendarsList[index]) ? AppColors.vivaMagentaColor : AppColors.limeColor,
                                            child: !selectedList.contains(googleCalendarsList[index])
                                                ? const SizedBox()
                                                : Center(
                                              child: SvgPicture.asset(
                                                'assets/images/checkmark.svg',
                                                color: AppColors.basicwhiteColor,
                                                height: 16.h,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: WidgetButton(
                            onTap: () async {
                              final storage = SharedPreferenceData.getInstance();
                              String userCalendar = selectedList.join(";");

                              await storage.setItem(SharedPreferenceData.selectedCalendar, userCalendar);
                              context.router.maybePop(selectedList);
                            },
                            color: AppColors.darkGreenColor,
                            child: Text(
                              'применить'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                                color: AppColors.basicwhiteColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
