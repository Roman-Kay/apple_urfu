
part of "client_food_diary_bloc.dart";

abstract class ClientsCardFoodDiaryState{}

class ClientFoodDiaryInitialState extends ClientsCardFoodDiaryState{}

class ClientFoodDiaryLoadingState extends ClientsCardFoodDiaryState{}

class ClientFoodDiaryLoadedState extends ClientsCardFoodDiaryState{
  List<ClientFoodOfDayView>? view;
  ClientFoodDiaryLoadedState(this.view);
}

class ClientFoodDiaryErrorState extends ClientsCardFoodDiaryState{}