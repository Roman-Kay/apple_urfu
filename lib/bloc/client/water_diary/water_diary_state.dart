
part of 'water_diary_bloc.dart';

class WaterDiaryState{}

class WaterDiaryInitialState extends WaterDiaryState{}

class WaterDiaryLoadingState extends WaterDiaryState{}

class WaterDiaryGetState extends WaterDiaryState{
  List<ClientWaterView>? response;
  ClientWaterView? today;
  int dayTarget;
  WaterDiaryGetState(this.response, this.today, this.dayTarget);
}


class WaterDiaryAddState extends WaterDiaryState{
  ClientWaterView? response;
  WaterDiaryAddState(this.response);
}

class WaterDiaryDeleteState extends WaterDiaryState{
  BaseResponse? response;
  WaterDiaryDeleteState(this.response);
}

class WaterDiaryErrorState extends WaterDiaryState{}