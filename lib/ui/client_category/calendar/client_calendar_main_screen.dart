import 'dart:collection';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_cubit.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_for_day/calendar_for_day_bloc.dart';
import 'package:garnetbook/bloc/client/calendar/selected_date/selected_date_bloc.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_view_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/ui/client_category/calendar/bottom_sheet/calendar_types_bottom_sheet.dart';
import 'package:garnetbook/ui/client_category/calendar/tab_bar/client_calendar_tabbar_events.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/calendar/calendar_week_item.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ClientCalendarMainScreen extends StatefulWidget {
  const ClientCalendarMainScreen({super.key});

  @override
  State<ClientCalendarMainScreen> createState() => _ClientCalendarMainScreenState();
}

class _ClientCalendarMainScreenState extends State<ClientCalendarMainScreen> {
  final storage = SharedPreferenceData.getInstance();
  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  List<Calendar> _calendars = [];
  List<String> selectedCalendars = [];

  int currentYear = DateTime.now().year + 1;
  int startingYear = DateTime.now().year - 1;
  Map yearMapWithMonth = {};

  int selectedMonth = (DateTime.now().year - (DateTime.now().year - 1)) * 12 + DateTime.now().month - 1;
  List<Map<int, List>> listOfMapMonth = [];
  List listOfYear = [];
  Set<UnmodifiableListView<Event>> _calendarEvents = {};

  FixedExtentScrollController _scrollControllerMonth =
      FixedExtentScrollController(initialItem: (DateTime.now().year - (DateTime.now().year - 1)) * 12 + DateTime.now().month - 1);

  @override
  void initState() {
    getSelectedCalendars();
    _retrieveCalendars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double itemWidthMonth = MediaQuery.of(context).size.width / 3;

    List yearList = List.generate((currentYear - startingYear) + 1, (index) {
      setState(() {
        yearMapWithMonth[startingYear + index] = List.generate(12, (month) {
          return {
            DateTime(startingYear + index).month + month: List.generate(
              DateTime(startingYear + index, DateTime(startingYear + index).month + month + 1, 0).day,
              (day) => day + 1,
            ),
          };
        });
      });
    });

    yearMapWithMonth.values.forEach((list) {
      listOfMapMonth.addAll(list);
    });
    yearMapWithMonth.keys.forEach(
      (year) => listOfYear.add(year),
    );

    return Scaffold(
      body: BlocBuilder<SelectedDateBloc, SelectedDateState>(builder: (context, selectedDate) {
        return BlocBuilder<CalendarCubit, CalendarState>(builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.gradientTurquoiseReverse,
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  RefreshIndicator(
                    color: AppColors.darkGreenColor,
                    onRefresh: () {
                      context.read<CalendarCubit>().check();
                      context.read<CalendarForDayBloc>().add(CalendarForDayGetEvent(DateFormat("yyyy-MM-dd").format(selectedDate.date)));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView(
                      children: [
                        SizedBox(height: 56.h + 30.h),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              width: 352.w,
                              decoration: BoxDecoration(
                                color: AppColors.basicwhiteColor,
                                border: Border.all(
                                  color: AppColors.lightGreenColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 65.h - (24.h + 14.h) + (24.h + 14.h) * MediaQuery.of(context).textScaleFactor,
                                    child: Center(
                                      child: RotatedBox(
                                        quarterTurns: -1,
                                        child: ListWheelScrollView(
                                          diameterRatio: 100,
                                          useMagnifier: true,
                                          onSelectedItemChanged: (m) {
                                            setState(() => selectedMonth = m);
                                            _retrieveCalendarEvents();
                                          },
                                          controller: _scrollControllerMonth,
                                          physics: const FixedExtentScrollPhysics(),
                                          children: List.generate(
                                            listOfMapMonth.length,
                                            (m) => RotatedBox(
                                              quarterTurns: 1,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 8.h),
                                                  GestureDetector(
                                                    onTap: m == selectedMonth
                                                        ? null
                                                        : () {
                                                            _scrollControllerMonth.animateToItem(
                                                              m,
                                                              duration: Duration(milliseconds: 100),
                                                              curve: Curves.ease,
                                                            );
                                                            _retrieveCalendarEvents();
                                                          },
                                                    child: AnimatedDefaultTextStyle(
                                                      duration: Duration(milliseconds: 150),
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          // берем если выбранный месяц полное название из index == 0 иначе не полное 1
                                                          CalendarStorage.nameMonth[listOfMapMonth[m].keys.toList().first]
                                                              ?[m == selectedMonth ? 0 : 1],
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: m == selectedMonth ? 24.h : 20.h,
                                                        fontFamily: 'Inter',
                                                        color: m == selectedMonth ? AppColors.darkGreenColor : AppColors.grey50Color,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    // выбраный месяц мы делем на 12 без остатка тем самам получаем нужный индекс года
                                                    m == selectedMonth ? listOfYear[m ~/ 12].toString() : '',
                                                    style: TextStyle(
                                                      height: 1.1,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 14.h,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.darkGreenColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          itemExtent: itemWidthMonth,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Wrap(
                                        spacing: 4.w,
                                        children: [
                                          CalendarWeekItem(text: 'Пн'),
                                          CalendarWeekItem(text: 'Вт'),
                                          CalendarWeekItem(text: 'Ср'),
                                          CalendarWeekItem(text: 'Чт'),
                                          CalendarWeekItem(text: 'Пт'),
                                          CalendarWeekItem(text: 'Сб'),
                                          CalendarWeekItem(text: 'Вс'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Wrap(
                                      spacing: 4.w,
                                      runSpacing: 2.h,
                                      children: listOfMapMonth[selectedMonth].values.toList().first.map((day) {
                                        DateTime dateTimeItem = DateTime.parse(
                                          '${listOfYear[selectedMonth ~/ 12]}-${(selectedMonth % 12 + 1).toString().length == 1 ? '0' : ''}${selectedMonth % 12 + 1}-${day <= 9 ? '0' : ''}$day',
                                        );

                                        int sumEvents = 0;
                                        List<DateTime> events = [];

                                        if (state is CalendarLoadedState && state.view != null && state.view!.isNotEmpty) {
                                          state.view!.forEach((element) {
                                            if (element.eventDate != null) {
                                              DateTime newDate = DateTime.parse(element.eventDate!);

                                              if (newDate.day == dateTimeItem.day &&
                                                  newDate.month == dateTimeItem.month &&
                                                  newDate.year == dateTimeItem.year) {
                                                events.add(newDate);
                                              }
                                            }
                                          });

                                          if (events.isNotEmpty) {
                                            sumEvents = events.length;
                                          }
                                        }

                                        if (_calendarEvents.isNotEmpty) {
                                          _calendarEvents.forEach((element) {
                                            if (element.isNotEmpty) {
                                              element.forEach((item) {
                                                if (item.start?.year == dateTimeItem.year &&
                                                    item.start?.month == dateTimeItem.month &&
                                                    item.start?.day == dateTimeItem.day) {
                                                  events.add(dateTimeItem);
                                                }
                                              });
                                            }
                                          });
                                        }

                                        if (events.isNotEmpty) {
                                          sumEvents = events.length;
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            context.read<SelectedDateBloc>().add(SelectedDateGetEvent(dateTimeItem));
                                            context
                                                .read<CalendarForDayBloc>()
                                                .add(CalendarForDayGetEvent(DateFormat("yyyy-MM-dd").format(dateTimeItem)));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: day == 1
                                                  // если день первый смотрим какой по счету это день недели и у множаем на отступ слева
                                                  ? (dateTimeItem.weekday - 1) * 50.w
                                                  : 0,
                                            ),
                                            child: selectedDate.date.day == dateTimeItem.day &&
                                                    selectedDate.date.month == dateTimeItem.month &&
                                                    selectedDate.date.year == dateTimeItem.year
                                                ? ChosenItem('$day', sumEvents)
                                                : DateTime.now().year == dateTimeItem.year &&
                                                        DateTime.now().month == dateTimeItem.month &&
                                                        DateTime.now().day == dateTimeItem.day
                                                    ? TodayItem('$day', sumEvents)
                                                    : StandartItem('$day', sumEvents),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        BlocBuilder<CalendarForDayBloc, CalendarForDayState>(
                          builder: (context, state) {
                            if (state is CalendarForDayLoadedState) {
                              List<Event> list = getDeviceEvent(selectedDate.date);
                              List<EventView> newList = getList(state.view?.events, list);

                              return ClientCalendarTabBarEvents(
                                chosenDate: selectedDate.date,
                                list: newList,
                              );
                            } else if (state is CalendarForDayErrorState) {
                              return SizedBox(
                                height: 200,
                                child: Center(
                                  child: ErrorWithReload(callback: () {
                                    String newDate = DateFormat("yyyy-MM-dd").format(selectedDate.date);
                                    context.read<CalendarForDayBloc>().add(CalendarForDayGetEvent(newDate));
                                  }),
                                ),
                              );
                            }
                            return SizedBox(
                              height: 200,
                              child: Center(child: ProgressIndicatorWidget()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    color: AppColors.basicwhiteColor,
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientTurquoise,
                      ),
                      child: Stack(
                        children: [
                          Visibility(
                            visible: _calendars.isNotEmpty,
                            child: Positioned(
                              right: 20,
                              top: 5,
                              bottom: 5,
                              child: InkWell(
                                onTap: () {
                                  List<String> calendarsName = [];

                                  _calendars.forEach((element) {
                                    if (element.name != null && !calendarsName.contains(element.name)) {
                                      calendarsName.add(element.name!);
                                    }
                                  });

                                  showModalBottomSheet(
                                    useSafeArea: true,
                                    backgroundColor: AppColors.basicwhiteColor,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) => ModalSheet(
                                      title: 'Список календарей',
                                      content: CalendarTypesBottomSheet(
                                        list: calendarsName,
                                        selectedList: selectedCalendars,
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value != null && value.isNotEmpty) {
                                      setState(() {
                                        selectedCalendars = value;
                                      });
                                      _retrieveCalendarEvents();
                                    }
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/images/plus.svg',
                                  color: AppColors.darkGreenColor,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Календарь',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                                fontFamily: 'Inter',
                                color: AppColors.darkGreenColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }

  getSelectedCalendars() async {
    final selectedCalendarsString = await storage.getItem(SharedPreferenceData.selectedCalendar);

    if (selectedCalendars != "") {
      setState(() {
        selectedCalendars = selectedCalendarsString.split(";").toList();
      });
    }
  }

  List<EventView> getList(List<EventView>? eventList, List<Event> devicesEvents) {
    List<EventView> list = [];

    if (eventList != null && eventList.isNotEmpty) {
      eventList.forEach((element) {
        if (element.eventDate != null) {
          list.add(element);
        }
      });
    }

    if (devicesEvents.isNotEmpty) {
      devicesEvents.forEach((element) {
        if (element.start != null && element.title != null) {
          list.add(EventView(
            eventDate: DateTime(element.start!.year, element.start!.month, element.start!.day).toString(),
            eventName: element.title,
            id: -1,
          ));
        }
      });
    }

    if (list.isNotEmpty) {
      list.sort((a, b) {
        DateTime aDate = DateTime.parse(a.eventDate!);
        DateTime bDate = DateTime.parse(b.eventDate!);

        return aDate.compareTo(bDate);
      });
    }

    return list;
  }

  List<Event> getDeviceEvent(DateTime dateTimeItem) {
    List<Event> deviceEvents = [];

    if (_calendarEvents.isNotEmpty) {
      _calendarEvents.forEach((element) {
        if (element.isNotEmpty) {
          element.forEach((item) {
            if (item.start?.year == dateTimeItem.year && item.start?.month == dateTimeItem.month && item.start?.day == dateTimeItem.day) {
              deviceEvents.add(item);
            }
          });
        }
      });
    }

    return deviceEvents;
  }

  void _retrieveCalendarEvents() async {
    _calendarEvents.clear();

    if (_calendars.isNotEmpty && selectedCalendars.isNotEmpty) {
      int selectedYear = listOfYear[selectedMonth ~/ 12];
      int newMonth = ((selectedMonth + 1) % 12) == 0 ? 12 : ((selectedMonth + 1) % 12);
      final startDate = DateTime(selectedYear, newMonth, 1);
      final endDate = DateTime(selectedYear, newMonth + 1, 1);

      _calendars.forEach((element) {
        selectedCalendars.forEach((item) async {
          if (element.name == item) {
            final calEvents =
                await _deviceCalendarPlugin.retrieveEvents(element.id, RetrieveEventsParams(startDate: startDate, endDate: endDate));
            if (calEvents.data != null) {
              setState(() {
                _calendarEvents.add(calEvents.data!);
              });
            }
          }
        });
      });
    }
  }

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();

      if (permissionsGranted.isSuccess && (permissionsGranted.data == null || permissionsGranted.data == false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || permissionsGranted.data == null || permissionsGranted.data == false) {}
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult.data as List<Calendar>;
      });

      if (_calendars.isNotEmpty && selectedCalendars.isNotEmpty) {
        int selectedYear = listOfYear[selectedMonth ~/ 12];
        int newMonth = ((selectedMonth + 1) % 12) == 0 ? 12 : ((selectedMonth + 1) % 12);
        final startDate = DateTime(selectedYear, newMonth, 1);
        final endDate = DateTime(selectedYear, newMonth + 1, 1);

        _calendars.forEach((element) {
          selectedCalendars.forEach((item) async {
            if (element.name == item) {
              final calEvents =
                  await _deviceCalendarPlugin.retrieveEvents(element.id, RetrieveEventsParams(startDate: startDate, endDate: endDate));
              if (calEvents.data != null) {
                _calendarEvents.add(calEvents.data!);
              }
            }
          });
        });
      }
    } catch (e) {
      debugPrint('RETRIEVE_CALENDARS: $e');
    }
  }

  Widget StandartItem(text, int sumEvents) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.w),
      child: Container(
        width: 46.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: AppColors.basicwhiteColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 7.w),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreenColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4.w),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sumEvents >= 1
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey50Color,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 3
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey50Color,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 2
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey50Color,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 5
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey50Color,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 4
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey50Color,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget TodayItem(text, int sumEvents) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.w),
      child: Container(
        width: 46.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: AppColors.basicwhiteColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.seaColor,
            width: 0.5,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 6.5.w),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreenColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 3.5.w),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sumEvents >= 1
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey10Color,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 3
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey10Color,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 2
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey10Color,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 5
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey10Color,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 4
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.grey10Color,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ChosenItem(text, int sumEvents) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.w),
      child: Container(
        width: 46.w,
        height: 42.w,
        decoration: BoxDecoration(
          gradient: AppColors.gradientTurquoiseReverse,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.seaColor,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 6.w),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreenColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 3.w),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sumEvents >= 1
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.greenColor,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 3
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.redColor,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 2
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.orangeColor,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 5
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.redColor,
                            ),
                          )
                        : const SizedBox(),
                    sumEvents >= 4
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: AppColors.greenColor,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
