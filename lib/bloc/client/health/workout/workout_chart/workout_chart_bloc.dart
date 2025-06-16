

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/activity/activity_request.dart';
import 'package:garnetbook/data/models/client/activity/activity_response.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part "workout_chart_event.dart";
part 'workout_chart_state.dart';

class WorkoutChartBloc extends Bloc<WorkoutChartEvent, WorkoutChartState>{
  WorkoutChartBloc() : super(WorkoutChartInitialState()){
    on<WorkoutChartGetEvent>(_get);
  }

  final service = SensorsService();

  Future<void> _get(WorkoutChartGetEvent event, Emitter<WorkoutChartState> emit) async{
    emit(WorkoutChartLoadingState());

    int value = event.dayQuantity == 7 ? 6 : event.dayQuantity;

    String endDate = DateFormat("yyyy-MM-dd").format(event.date);
    String startDate = DateFormat("yyyy-MM-dd").format(event.date.subtract(Duration(days: value)));

    final response = await service.getSensorsActivity(PeriodDateRequest(
        dateStart: startDate, dateEnd: endDate));

    if(response.result){
      emit(WorkoutChartLoadedState(response.value));
    }
    else{
      emit(WorkoutChartErrorState());
    }
  }
}