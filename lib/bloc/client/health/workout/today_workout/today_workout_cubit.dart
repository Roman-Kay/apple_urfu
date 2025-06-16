
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/activity/activity_request.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';

part 'today_workout_state.dart';

class TodayWorkoutCubit extends Cubit<TodayWorkoutState>{
  TodayWorkoutCubit() : super(TodayWorkoutInitialState());

  final service = SensorsService();

  check() async{
    emit(TodayWorkoutLoadingState());

    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());

    final response = await service.getSensorsActivity(PeriodDateRequest(
      dateEnd: date, dateStart: date
    ));

    if(response.result){
      Map<String, double> activityList = {};
      DateTime? date;
      int fullCalories = 0;

      if(response.value != null && response.value!.isNotEmpty){
        response.value?.forEach((element) {
          if(element.activity?.name != null && element.calories != null){
            String name = element.activity!.name!;
            double calories = element.calories!.toDouble();

            if(activityList.containsKey(name)){
              double currentVale = activityList[name] ?? 0;
              activityList.update(name, (value) => currentVale + calories, ifAbsent: () => currentVale + calories);
            }
            else{
              activityList.putIfAbsent(name, () => calories);
            }
          }
        });

        if(response.value?.last.create != null){
          date = DateTime.parse(response.value!.last.create!);
        }
      }

      if(activityList.isNotEmpty){
        activityList.forEach((key, value) {
          fullCalories = fullCalories + value.toInt();
        });
      }

      emit(TodayWorkoutLoadedState(fullCalories, date));
    }
    else{
      emit(TodayWorkoutErrorState());
    }
  }
}