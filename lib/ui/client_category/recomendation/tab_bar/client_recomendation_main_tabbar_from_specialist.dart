import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/recommendation/recommendation_cubit.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_models.dart';
import 'package:garnetbook/data/repository/recommendation_repository.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/status_color.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:intl/intl.dart';

class ItemAnimationModel {
  List<ClientRecommendationShortView> view;
  bool isOpen;
  String expertName;
  int expertId;
  DateTime date;
  bool isUpdate;

  ItemAnimationModel({
    required this.view,
    required this.expertName,
    required this.expertId,
    required this.date,
    required this.isUpdate,
    this.isOpen = false
  });
}

class ClientRecommendationMainTabBarFromSpecialist extends StatefulWidget {
  const ClientRecommendationMainTabBarFromSpecialist({super.key});

  @override
  State<ClientRecommendationMainTabBarFromSpecialist> createState() => _ClientRecommendationMainTabBarFromSpecialistState();
}

class _ClientRecommendationMainTabBarFromSpecialistState extends State<ClientRecommendationMainTabBarFromSpecialist> with AutomaticKeepAliveClientMixin {
  List<ItemAnimationModel> list = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<RecommendationCubit, RecommendationState>(builder: (context, state) {
      if (state is RecommendationLoadedState) {
        getList(state.view);

        if (list.isNotEmpty) {
          return RefreshIndicator(
            color: AppColors.darkGreenColor,
            onRefresh: () {
              context.read<RecommendationCubit>().check();
              return Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final recommendation = list[index];

                return SpecialistRecommendationItem(
                  recommendation: recommendation,
                  index: index,
                  length: list.length,
                );
              },
            ),
          );
        }
        else {
          return RefreshIndicator(
            color: AppColors.darkGreenColor,
            onRefresh: () {
              context.read<RecommendationCubit>().check();
              return Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: Center(
                    child: Text(
                      "Данные отсутствуют",
                      style: TextStyle(
                          color: AppColors.darkGreenColor,
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
      else if (state is RecommendationLoadingState) {
        return SizedBox(
            height: MediaQuery.of(context).size.height / 1.6,
            child: ProgressIndicatorWidget()
        );
      }
      else if (state is RecommendationErrorState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.9,
          child: ErrorWithReload(
            callback: () {
              context.read<RecommendationCubit>().check();
            },
          ),
        );
      }
      return Container();
    });
  }

  getList(ClientRecommendationsResponse? view) {
    list.clear();

    if (view != null && view.recommendations != null && view.recommendations!.isNotEmpty) {
      view.recommendations!.forEach((element) {
        if (element.expertId != null && element.create != null && element.expertFirstName != null) {
          DateTime newDate = DateTime.parse(element.create!);

          if (list.isNotEmpty) {
            bool isExist = list.any((item) => item.expertId == element.expertId);

            if (isExist) {
              for (var item in list) {
                if(item.isUpdate == false && element.update != null){
                  item.isUpdate = true;
                }
                if (item.expertId == element.expertId) {
                  item.view.add(element);

                  if(item.date.difference(newDate).inDays.isNegative){
                    item.date = newDate;
                  }
                  break;
                }
              }
            }
            else {
              list.add(ItemAnimationModel(
                  view: [element],
                  date: newDate,
                  isUpdate: element.update != null,
                  expertName: element.expertFirstName!,
                  expertId: element.expertId!));
            }
          }
          else {
            list.add(ItemAnimationModel(
                view: [element],
                date: newDate,
                isUpdate: element.update != null,
                expertName: element.expertFirstName!,
                expertId: element.expertId!));
          }
        }
      });
    }

    if(list.isNotEmpty){
      list.forEach((element){
        if(element.view.isNotEmpty){
          element.view.sort((a, b) {
            DateTime aDate = a.update != null ? DateTime.parse(a.update!) : DateTime.parse(a.create!);
            DateTime bDate = b.update != null ? DateTime.parse(b.update!) : DateTime.parse(b.create!);
            return bDate.compareTo(aDate);
          });
        }
      });

      list.sort((a, b) => b.date.compareTo(a.date));
    }
  }
}

class SpecialistRecommendationItem extends StatefulWidget {
  const SpecialistRecommendationItem({
    required this.recommendation,
    required this.index,
    required this.length,
    Key? key})
    : super(key: key);

  final ItemAnimationModel recommendation;
  final int index;
  final int length;

  @override
  State<SpecialistRecommendationItem> createState() => _SpecialistRecommendationItemState();
}

class _SpecialistRecommendationItemState extends State<SpecialistRecommendationItem> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  RecommendationRepository repository = RecommendationRepository();

  @override
  void initState() {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 14.w,
          right: 14.w,
          top: widget.index == 0 ? 20.h : 12.h,
          bottom: widget.index + 1 == widget.length ? 350.h : 0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: AnimatedSize(
            duration: Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.basicwhiteColor,
              ),
              width: double.infinity,
              child: FormForButton(
                borderRadius: BorderRadius.zero,
                onPressed: () {
                  setState(() {
                    widget.recommendation.isOpen = !widget.recommendation.isOpen;
                  });
                },
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Назначена: " + DateFormat('d MMMM yyyy', 'ru_RU').format(widget.recommendation.date),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  fontFamily: 'Inter',
                                  color: AppColors.vivaMagentaColor,
                                ),
                              ),
                              const Spacer(),
                              CircleAvatar(
                                radius: 4.r,
                                backgroundColor: widget.recommendation.isUpdate ? AppColors.redColor : StatusColor().getTrackerStatusColor(widget.recommendation.view.last.recommendationStatus?.name),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                widget.recommendation.isUpdate ? "ИЗМЕНЕНА" : widget.recommendation.view.last.recommendationStatus?.name?.toUpperCase() ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  fontFamily: 'Inter',
                                  color: widget.recommendation.isUpdate ? AppColors.redColor : StatusColor().getTrackerStatusColor(
                                      widget.recommendation.view.last.recommendationStatus?.name),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.recommendation.expertName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenSecondaryColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5.h),
                                    if (widget.recommendation.view.first.expertPosition != null)
                                      Text(
                                        widget.recommendation.view.first.expertPosition ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          fontFamily: 'Inter',
                                          color: AppColors.darkGreenSecondaryColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Transform.flip(
                                flipY: widget.recommendation.isOpen,
                                child: Transform.rotate(
                                  angle: pi / 2,
                                  child: SvgPicture.asset(
                                    'assets/images/arrow_black.svg',
                                    color: AppColors.darkGreenColor,
                                    height: 24.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: !widget.recommendation.isOpen
                          ? null
                          : FadeTransition(
                              opacity: _animation,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                child: Column(
                                  children: [
                                    for (var itemSpecialistRecommendation in widget.recommendation.view)
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 24.h),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.r),
                                          clipBehavior: Clip.hardEdge,
                                          child: Container(
                                            height: 64.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: AppColors.darkGreenColor,
                                              image: DecorationImage(
                                                  image: AssetImage(repository.getButtons(itemSpecialistRecommendation.recommendationType?.name).imageName),
                                                  fit: BoxFit.cover
                                              ),
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                            child: FormForButton(
                                              borderRadius: BorderRadius.circular(4.r),
                                              onPressed: () {
                                                if (itemSpecialistRecommendation.recommendationType?.name != null && itemSpecialistRecommendation.recommendationId != null) {
                                                  context.router.push(
                                                    ClientRecommendationWatchRoute(
                                                      name: itemSpecialistRecommendation.recommendationType!.name!,
                                                      id: itemSpecialistRecommendation.recommendationId!
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Stack(
                                                alignment: Alignment.centerRight,
                                                children: [
                                                  Container(
                                                    height: 64.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8.r),
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight,
                                                        colors: [
                                                          AppColors.basicblackColor.withOpacity(0.6),
                                                          AppColors.basicblackColor.withOpacity(0),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  if(itemSpecialistRecommendation.update != null)
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                                                        margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: AppColors.redColor),
                                                          borderRadius: BorderRadius.circular(8.r),
                                                            gradient: LinearGradient(
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                              colors: [
                                                                AppColors.basicblackColor.withOpacity(0.6),
                                                                AppColors.basicblackColor.withOpacity(0.2),
                                                              ],
                                                            ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 10,
                                                              offset: Offset(0, 2),
                                                              color: AppColors.basicblackColor.withOpacity(0.1)
                                                            )
                                                          ]
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/images/update_icon.svg',
                                                              width: 12,
                                                              height: 12,
                                                            ),
                                                            SizedBox(width: 5.w),
                                                            Text(
                                                                itemSpecialistRecommendation.update != null ? "Изменено: ${DateFormat('d MMMM yyyy', 'ru_RU').format(DateTime.parse(itemSpecialistRecommendation.update!))}" : "" ,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: AppColors.basicwhiteColor,
                                                                fontSize: 12.sp,
                                                                fontFamily: "Inter"
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 14.w).copyWith(bottom: 5.h),
                                                    child: Align(
                                                      alignment: Alignment.bottomLeft,
                                                      child: Text(
                                                        itemSpecialistRecommendation.recommendationType?.name ?? "",
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: AppColors.basicwhiteColor,
                                                          fontSize: 20.sp,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    // Center(
                                    //   child: Padding(
                                    //     padding: EdgeInsets.only(bottom: 24.h),
                                    //     child: GestureDetector(
                                    //       onTap: () {
                                    //         if (itemSpecialistRecommendation.recommendationType?.name != null) {
                                    //           context.router.push(ClientRecommendationWatchRoute(
                                    //               name: itemSpecialistRecommendation.recommendationType!.name!,
                                    //               image: itemSpecialistRecommendation.file?.fileBase64,
                                    //               desc: itemSpecialistRecommendation.recommendationDesc));
                                    //         }
                                    //       },
                                    //       child: SizedBox(
                                    //         height: 80.h,
                                    //         child: Image.asset(
                                    //           RecommendationRepository()
                                    //               .getButtons(itemSpecialistRecommendation.recommendationType?.name)
                                    //               .imageName,
                                    //           width: 350.w,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(height: (32 - 24).h),
                                    // WidgetButton(
                                    //   onTap: () {},
                                    //   text: 'Уточнить у специалиста'.toUpperCase(),
                                    //   color: AppColors.darkGreenColor,
                                    // ),
                                    SizedBox(height: (24 - 8).h),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
