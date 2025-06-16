
part of "client_water_diary_bloc.dart";

class ClientsCardWaterDiaryState{}

class ClientsCardWaterDiaryInitialState extends ClientsCardWaterDiaryState{}

class ClientsCardWaterDiaryLoadingState extends ClientsCardWaterDiaryState{}

class ClientsCardWaterDiaryLoadedState extends ClientsCardWaterDiaryState{
  List<ClientWaterOfDayView>? view;
  ClientsCardWaterDiaryLoadedState(this.view);
}

class ClientsCardWaterDiaryErrorState extends ClientsCardWaterDiaryState{}