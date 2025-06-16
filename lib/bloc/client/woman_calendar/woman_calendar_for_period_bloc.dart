import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/woman_calendar/woman_calendar_response.dart';
import 'package:garnetbook/domain/services/client/woman_calendar/woman_calendar_service.dart';


part 'woman_calendar_for_period_event.dart';
part 'woman_calendar_for_period_state.dart';

class  WomanCalendarForPeriodBloc extends Bloc<WomanCalendarForPeriodEvent, WomanCalendarForPeriodState>{
  WomanCalendarForPeriodBloc() : super(WomanCalendarForPeriodInitialState()){
    on<WomanCalendarForPeriodGetEvent>(_get);
  }

  final service = WomanCalendarService();

  Future<void> _get(WomanCalendarForPeriodGetEvent event, Emitter<WomanCalendarForPeriodState> emit) async{
    emit(WomanCalendarForPeriodLoadingState());

    final response = await service.getWomanCalendarForMonth(event.date);

    if(response.result){
      emit(WomanCalendarForPeriodLoadedState(response.value));
    }
    else{
      emit(WomanCalendarForPeriodErrorState());
    }
  }
}