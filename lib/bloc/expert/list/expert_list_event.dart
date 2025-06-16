
part of 'expert_list_bloc.dart';

class ExpertListEvent{}

class ExpertListAllEvent extends ExpertListEvent{
  int page;
  ExpertListAllEvent(this.page);
}
