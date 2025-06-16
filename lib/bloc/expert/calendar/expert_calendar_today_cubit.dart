
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:garnetbook/domain/services/client/calendar/calendar_service.dart';
import 'package:intl/intl.dart';

part 'expert_calendar_today_state.dart';

class ExpertCalendarTodayCubit extends Cubit<ExpertCalendarTodayState>{
  ExpertCalendarTodayCubit() : super(ExpertCalendarTodayInitialState());

  final service = CalendarNetworkService();

  check() async{
    emit(ExpertCalendarTodayLoadingState());
    final response = await service.getCalendarEventForDay(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    if(response.result){
     emit(ExpertCalendarTodayLoadedState(response.value));
    }
    else{
     emit(ExpertCalendarTodayErrorState());
    }
  }
}