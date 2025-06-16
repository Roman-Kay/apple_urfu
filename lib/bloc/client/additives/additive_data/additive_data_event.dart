
part of "additive_data_bloc.dart";

class AdditiveDataEvent{}

class AdditiveDataGetEvent extends AdditiveDataEvent{
  int id;
  AdditiveDataGetEvent(this.id);
}

class AdditiveDataInitialEvent extends AdditiveDataEvent{}