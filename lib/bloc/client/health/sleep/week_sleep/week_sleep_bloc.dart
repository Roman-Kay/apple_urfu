import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:intl/intl.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';

part 'week_sleep_state.dart';
part 'week_sleep_event.dart';

class WeekSleepBloc extends Bloc<WeekSleepEvent, WeekSleepState>{
  WeekSleepBloc() : super(WeekSleepInitialState()){
    on<WeekSleepGetEvent>(_get);
  }

  final service = SensorsService();

  Future<void> _get(WeekSleepGetEvent event, Emitter<WeekSleepState> emit) async {
    emit(WeekSleepLoadingState());

    int value = event.dayQuantity == 7 ? 6 : event.dayQuantity;

    final response = await service.getSensorsForDay(ClientSensorDayRequest(
      clientId: event.clientId,
      healthSensorId: 5,
      dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
      dateStart: DateFormat("yyyy-MM-dd").format(event.date.subtract(Duration(days: value))),
    ));


    if (response.result) {
      emit(WeekSleepLoadedState(response.value?.clientSensors));
    }
    else{
      emit(WeekSleepErrorState());
    }
  }
}
