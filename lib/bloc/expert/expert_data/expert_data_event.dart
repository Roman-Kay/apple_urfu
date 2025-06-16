
part of "expert_data_bloc.dart";

class ExpertDataEvent{}

class ExpertDataGetEvent extends ExpertDataEvent{
  int expertId;
  ExpertDataGetEvent(this.expertId);
}