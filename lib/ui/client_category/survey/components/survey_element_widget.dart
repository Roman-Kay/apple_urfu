import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/models/survey/survey_branching_store/survey_branching_store.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';


class SurveyElementWidget extends StatefulWidget {
  SurveyElementWidget({
    required this.question,
    required this.answers,
    required this.id,
    required this.index,
    required this.item,
    this.isEdit = true,
    Key? key})
      : super(key: key);

  final Question question;
  final int id;
  final int index;
  Set<QuestionItem> answers;
  QuestionItem item;
  bool isEdit;

  @override
  State<SurveyElementWidget> createState() => _SurveyElementWidgetState();
}

class _SurveyElementWidgetState extends State<SurveyElementWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isOpen = true;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.basicwhiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8.r),
                bottom: isOpen ? Radius.zero : Radius.circular(8.r),
              ),
            ),
            child: FormForButton(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8.r),
                bottom: isOpen ? Radius.zero : Radius.circular(8.r),
              ),
              onPressed: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 16.h,
                              bottom: widget.item.answerBall != null ? 0 : 16.h,
                            ),
                            child: SizedBox(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  '${widget.index + 1}.  ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 16.h,
                                bottom: widget.item.answerBall != null ? 0 : 16.h,
                              ),
                              child: Text(
                                widget.question.title ?? "",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                ),
                              ),
                            ),
                          ),
                          Transform.flip(
                            flipY: isOpen,
                            child: Transform.rotate(
                              angle: pi / 2,
                              child: SvgPicture.asset(
                                'assets/images/arrow_black.svg',
                                color: AppColors.darkGreenColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (widget.item.answerBall != null) SizedBox(height: 8.h),
                    if (widget.item.answerBall != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: AppColors.darkGreenColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          child: Row(
                            children: [
                              Text(
                                'ответ:  ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                  color: Color(0xFFAEE5E2),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  widget.item.answerText,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Inter',
                                    color: AppColors.basicwhiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (widget.item.answerBall != null) SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn,
            child: Container(
              color: AppColors.darkGreenColor,
              child: isOpen
                  ? null
                  : FadeTransition(
                opacity: _animation,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.question.pointData!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {

                    return FormForButton(
                      borderRadius: BorderRadius.zero,
                      onPressed: () {
                        if(widget.isEdit){
                          if (widget.question.pointData?[i].text != null && widget.question.pointData?[i].ball != null) {
                            setState(() {
                              widget.item.answerText = widget.question.pointData![i].text!;
                              widget.item.answerBall = widget.question.pointData![i].ball!;
                            });

                            for (var element in widget.answers) {
                              if (element.questionId == widget.item.questionId) {
                                setState(() {
                                  element.answerBall = widget.item.answerBall;
                                  element.answerText = widget.item.answerText;
                                });

                                if (widget.question.coef != null && widget.question.coef!.isNotEmpty) {
                                  widget.question.coef!.forEach((coef) {
                                    if (coef == "s") element.answerBallS = widget.item.answerBall;
                                    if (coef == "d") element.answerBallD = widget.item.answerBall;
                                    if (coef == "t") element.answerBallT = widget.item.answerBall;
                                  });
                                }
                                break;
                              }
                            }

                            setState(() {
                              isOpen = !isOpen;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        color: widget.item.answerText == widget.question.pointData?[i].text ? AppColors.greenColor : AppColors.darkGreenColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                widget.question.pointData?[i].text ?? "",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: widget.item.answerText == widget.question.pointData?[i].text
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontFamily: 'Inter',
                                  color: AppColors.basicwhiteColor,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 12.r,
                              backgroundColor: widget.item.answerText == widget.question.pointData?[i].text
                                  ? AppColors.basicwhiteColor
                                  : Color(0x00000000),
                              child: widget.item.answerText == widget.question.pointData?[i].text
                                  ? SvgPicture.asset(
                                'assets/images/checkmark.svg',
                                height: 16.r,
                                color: AppColors.darkGreenColor,
                              )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}