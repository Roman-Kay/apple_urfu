
part of 'diets_full_data_bloc.dart';

class DietsFullDataEvent{}

class DietsFullDataGetEvent extends DietsFullDataEvent{
  int id;
  DietsFullDataGetEvent(this.id);
}

class DietsFullDataInitialEvent extends DietsFullDataEvent{}