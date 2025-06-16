
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/client/water_diary/water_diary_model.dart';
import 'package:garnetbook/data/models/client/water_diary/water_update_model.dart';
import 'package:garnetbook/domain/services/client/water_diary/water_diary_service.dart';
import 'package:intl/intl.dart';


part 'water_diary_state.dart';
part 'water_diary_event.dart';

class WaterDiaryBloc extends Bloc<WaterDiaryEvent, WaterDiaryState>{
  WaterDiaryBloc() : super(WaterDiaryInitialState()){
    on<WaterDiaryCheckEvent>(_checkWaterDiary);
  }

  final networkService = WaterDiaryService();

  Future<void> _checkWaterDiary(WaterDiaryCheckEvent event, Emitter<WaterDiaryState> emit) async{
    emit(WaterDiaryLoadingState());

    final response = await networkService.getWaterDiary(ClientWaterRequest(
      dateEnd: DateFormat("yyyy-MM-dd").format(event.date),
      dateStart:  DateFormat("yyyy-MM-dd").format(event.date)
    ));

    if(response.result == true){
      DateTime today = event.date;

      if(response.value != null && response.value!.isNotEmpty){
        ClientWaterView? todayWater;

        for(var element in response.value!){
          if(element.update != null){
            DateTime temp = DateTime.parse(element.update!);
            if(temp.day == today.day && temp.month == today.month && temp.year == today.year){
              todayWater = element;
              break;
            }
          }
          else if(element.update != null){
            DateTime temp = DateTime.parse(element.update!);
            if(temp.day == today.day && temp.month == today.month && temp.year == today.year){

              todayWater = element;
              break;
            }
          }
        }

        int dayTarget = response.value?.last.dayNorm ?? 2000;

       if(todayWater != null){
         emit(WaterDiaryGetState(response.value, todayWater, dayTarget));
       }
       else{
         emit(WaterDiaryGetState(response.value, null, dayTarget));
       }
      }
      else{
        emit(WaterDiaryGetState(response.value, null, 2000));
      }
    }
    else{
      emit(WaterDiaryErrorState());
    }
  }

}