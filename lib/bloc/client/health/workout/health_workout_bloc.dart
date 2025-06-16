
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/activity/activity_request.dart';
import 'package:garnetbook/data/models/client/activity/activity_response.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part 'health_workout_event.dart';
part 'health_workout_state.dart';

class HealthWorkoutBloc extends Bloc<HealthWorkoutEvent, HealthWorkoutState>{
  HealthWorkoutBloc() : super(HealthWorkoutInitialState()){
    on<HealthWorkoutCheckEvent>(_check);
    on<HealthWorkoutGetForExpertEvent>(_checkForExpert);
  }


  final service = SensorsService();

  Future<void> _check(HealthWorkoutCheckEvent event, Emitter<HealthWorkoutState> emit) async{
    emit(HealthWorkoutLoadingState());

    String startDate = DateFormat("yyyy-MM-dd").format(event.startDate);
    final response = await service.getSensorsActivity(PeriodDateRequest(
        dateStart: startDate, dateEnd: startDate));

    DateTime? date;

    if(response.result){
      if(response.value != null && response.value!.isNotEmpty){
        if(response.value?.last.create != null){
          date = DateTime.parse(response.value!.last.create!);
        }
      }

      emit(HealthWorkoutLoadedState(response.value, date));
    }
    else{
      emit(HealthWorkoutErrorState());
    }

  }


  Future<void> _checkForExpert(HealthWorkoutGetForExpertEvent event, Emitter<HealthWorkoutState> emit) async{
    emit(HealthWorkoutLoadingState());

    int value = event.dayQuantity == 7 ? 6 : event.dayQuantity;

    final response = await service.getSensorsActivityForExpert(
        event.id, PeriodDateRequest(
        dateStart: DateFormat("yyyy-MM-dd").format(event.startDate.subtract(Duration(days: value))),
        dateEnd: DateFormat("yyyy-MM-dd").format(event.startDate)
    ));

    DateTime? date;

    if(response.result){
      if(response.value != null && response.value!.isNotEmpty){

        if(response.value?.last.create != null){
          date = DateTime.parse(response.value!.last.create!);
        }
      }

      emit(HealthWorkoutLoadedState(response.value, date));
    }
    else{
      emit(HealthWorkoutErrorState());
    }

  }
}