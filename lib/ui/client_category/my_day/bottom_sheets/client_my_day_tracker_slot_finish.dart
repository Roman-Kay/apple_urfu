import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_request.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/client/trackers/trackers_service.dart';
import 'package:garnetbook/main.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientMyDayTrackerSlotsFinish extends StatelessWidget {
  const ClientMyDayTrackerSlotsFinish({super.key, required this.isTracker, this.isFull = true, required this.clientTrackerId});
  final bool isTracker;
  final bool isFull;
  final int? clientTrackerId;

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
              Image.asset('assets/images/beautiful_granat.webp'),
              SizedBox(height: 16.h),
              Text(
                isTracker
                    ? isFull == false
                        ? 'Вы завершили трекер, но некоторые дни остались пропущенными.\nПопробуйте еще раз.\nУ Вас обязательно получится!'
                        : 'Вы завершили трекер!'
                    : 'Вы завершили цель!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  height: 17.6.sp / 16.sp,
                  color: AppColors.darkGreenColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 32.h),
              WidgetButton(
                onTap: () async {
                  if (isTracker && clientTrackerId != null) {
                    final service = TrackersService();

                    context.loaderOverlay.show();

                    final response = await service.setTracker(ClientTrackerRequest(trackerStatusId: 4, clientTrackerId: clientTrackerId));

                    if (response.result) {
                      GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.finishTrackerClient);

                      context.loaderOverlay.hide();
                      context.router.maybePop(true);
                    } else {
                      context.loaderOverlay.hide();
                      context.router.maybePop();
                    }
                  } else {
                    context.router.maybePop();
                  }
                },
                color: AppColors.darkGreenColor,
                text: 'Далее'.toUpperCase(),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }
}
