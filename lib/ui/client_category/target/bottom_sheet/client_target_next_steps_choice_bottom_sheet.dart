import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';


class ClientTargetNextStepsChoiceBottomSheet extends StatefulWidget {
  const ClientTargetNextStepsChoiceBottomSheet({super.key, required this.nextStep});
  final List<NextStep>? nextStep;

  @override
  State<ClientTargetNextStepsChoiceBottomSheet> createState() => _ClientTargetNextStepsChoiceBottomSheetState();
}

class _ClientTargetNextStepsChoiceBottomSheetState extends State<ClientTargetNextStepsChoiceBottomSheet> {
  List<NextStep> stepList = [];
  NextStep? setTarget;

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.limeColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              if(stepList.isNotEmpty)
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: stepList.length,
                      itemBuilder: (context, index){
                        final item = stepList[index];

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if(item == setTarget){
                                    setTarget = null;
                                  }
                                  else{
                                    setTarget = item;
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item.type == "message"
                                            ? item.message ?? ""
                                            : item.title ?? "",
                                        style: TextStyle(
                                          fontWeight: item == setTarget
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: 16.sp,
                                          fontFamily: 'Inter',
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  CircleAvatar(
                                    radius: 12.w,
                                    backgroundColor: AppColors.lightGreenColor,
                                    child: item == setTarget
                                        ? SizedBox(
                                        width: 16.w,
                                        height: 16.h,
                                        child: Icon(
                                          Icons.check,
                                          size: 16.h,
                                          color: AppColors.darkGreenColor,
                                        ))
                                        : SizedBox(),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: WidgetButton(
                            onTap: () {
                              context.router.maybePop();
                            },
                            color: AppColors.lightGreenColor,
                            child: Text(
                              'отмена'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                                color: AppColors.darkGreenColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          child: WidgetButton(
                            onTap: () async{
                              if(setTarget != null){
                                if(setTarget?.message != null && setTarget!.message!.contains("нализ")){
                                  context.router.maybePop(
                                      NextStep(
                                          type: "analysis",
                                          title: setTarget?.title,
                                          message: setTarget?.message,
                                          id: setTarget?.id
                                      )
                                  );
                                }
                                else if(setTarget?.message != null && setTarget!.message!.contains("пециалист")){
                                  context.router.maybePop(
                                      NextStep(
                                        type: "specialist",
                                        title: setTarget?.title,
                                        message: setTarget?.message,
                                        id: setTarget?.id
                                      )
                                  );
                                }
                                else{
                                  context.router.maybePop(setTarget);
                                }
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Выберите значение',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            boxShadow: true,
                            color: AppColors.darkGreenColor,
                            child: Text(
                              'применить'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                                color: AppColors.basicwhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              if(stepList.isEmpty)
                Center(
                  child: Text(
                    "Данные скоро появятся",
                    style: TextStyle(
                        color: AppColors.darkGreenColor,
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }

  check(){
    if(widget.nextStep != null && widget.nextStep!.isNotEmpty){
      widget.nextStep?.forEach((element){
        if(element.type != null && element.id != null && element.title != null){
          stepList.add(element);
        }
      });
    }
  }
}
