

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_view_model.dart';
import 'package:garnetbook/domain/services/client/calendar/calendar_service.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState>{
  CalendarCubit() : super(CalendarInitialState());

  final networkServices = CalendarNetworkService();

  check() async{
    emit(CalendarLoadingState());
    final response = await networkServices.getCalendarEvent();

    if(response.result){
      emit(CalendarLoadedState(response.value));
    }else{
      emit(CalendarErrorState());
    }
  }
}