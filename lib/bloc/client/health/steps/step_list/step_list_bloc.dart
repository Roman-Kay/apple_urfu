
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/health/health_service.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

part 'step_list_state.dart';
part 'step_list_event.dart';

class StepListBloc extends Bloc<StepListEvent, StepListState>{
  StepListBloc() : super(StepListInitialState()){
    on<StepListGetEvent>(_get);
  }

  HealthService healthService = HealthService();
  HealthServiceController healthController = HealthServiceController();
  Health health = Health();
  final service = SensorsService();

  Future<void> _get(StepListGetEvent event, Emitter<StepListState> emit) async{
    emit(StepListLoadingState());

    DateTime startedDate = DateTime(event.selectedYear, event.selectedMonth, 1);
    DateTime endedDate = DateTime(event.selectedYear, event.selectedMonth + 1, 1 - 1);

    final response = await service.getSensorsForDay(ClientSensorDayRequest(
        clientId: event.clientId,
        healthSensorId: 1,
        dateStart: DateFormat("yyyy-MM-dd").format(startedDate),
        dateEnd: DateFormat("yyyy-MM-dd").format(endedDate)
    ));

    if(response.result){
      emit(StepListLoadedState(response.value?.clientSensors));
    }
    else{
      emit(StepListErrorState());
    }
  }
}