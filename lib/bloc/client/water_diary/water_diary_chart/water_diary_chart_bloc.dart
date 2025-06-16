
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/water_diary/water_diary_model.dart';
import 'package:garnetbook/data/models/client/water_diary/water_update_model.dart';
import 'package:garnetbook/domain/services/client/water_diary/water_diary_service.dart';
import 'package:intl/intl.dart';

part "water_diary_chart_event.dart";
part "water_diary_chart_state.dart";

class WaterDiaryChartBloc extends Bloc<WaterDiaryChartEvent, WaterDiaryChartState>{
  WaterDiaryChartBloc() : super(WaterDiaryChartInitialState()){
    on<WaterDiaryChartGetEvent>(_get);
  }

  final networkService = WaterDiaryService();

  Future<void> _get(WaterDiaryChartGetEvent event, Emitter<WaterDiaryChartState> emit) async{
    emit(WaterDiaryChartLoadingState());

    DateTime startedDate = DateTime(event.year, event.month, 1);
    DateTime endedDate = DateTime(event.year, event.month + 1, 1 - 1);

    final response = await networkService.getWaterDiary(ClientWaterRequest(
        dateStart: DateFormat("yyyy-MM-dd").format(startedDate),
        dateEnd: DateFormat("yyyy-MM-dd").format(endedDate)
    ));

    if(response.result){
      emit(WaterDiaryChartLoadedState(response.value));
    }
    else{
      emit(WaterDiaryChartErrorState());
    }
  }
}