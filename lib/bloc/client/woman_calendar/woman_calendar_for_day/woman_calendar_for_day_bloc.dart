
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/woman_calendar/woman_calendar_view.dart';
import 'package:garnetbook/domain/services/client/woman_calendar/woman_calendar_service.dart';
import 'package:intl/intl.dart';

part 'woman_calendar_for_day_event.dart';
part 'woman_calendar_for_day_state.dart';

class WomanCalendarForDayBloc extends Bloc<WomanCalendarForDayEvent, WomanCalendarForDayState>{
  WomanCalendarForDayBloc() : super(WomanCalendarForDayInitialState()){
    on<WomanCalendarForDayGetEvent>(_get);
  }

  final service = WomanCalendarService();

  Future<void> _get(WomanCalendarForDayGetEvent event, Emitter<WomanCalendarForDayState> emit) async{
    emit(WomanCalendarForDayLoadingState());

    final response = await service.getWomanCalendarForDay(DateFormat("yyyy-MM-dd").format(event.date));

    if(response.result){
      emit(WomanCalendarForDayLoadedState(response.value));
    }
    else{
      emit(WomanCalendarForDayErrorState());
    }
  }
}