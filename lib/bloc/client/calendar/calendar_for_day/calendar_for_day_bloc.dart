
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:garnetbook/domain/services/client/calendar/calendar_service.dart';

part 'calendar_for_day_event.dart';
part 'calendar_for_day_state.dart';

class CalendarForDayBloc extends Bloc<CalendarForDayEvent, CalendarForDayState>{
  CalendarForDayBloc() : super(CalendarForDayInitialState()){
    on<CalendarForDayGetEvent>(_getEvent);
  }

  final service = CalendarNetworkService();


  Future<void> _getEvent(CalendarForDayGetEvent event, Emitter<CalendarForDayState> emit) async{
    emit(CalendarForDayLoadingState());

    final response = await service.getCalendarEventForDay(event.day);

    if(response.result){
      emit(CalendarForDayLoadedState(response.value));
    }
    else{
      emit(CalendarForDayErrorState());
    }
  }
}