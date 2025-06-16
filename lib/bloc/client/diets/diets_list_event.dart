
part of 'diets_list_bloc.dart';

class DietsListEvent{}

class DietsListGetEvent extends DietsListEvent{}

class DietsListExpertGetEvent extends DietsListEvent{
  int clientId;
  DietsListExpertGetEvent(this.clientId);
}

class DietsListInitialEvent extends DietsListEvent{}