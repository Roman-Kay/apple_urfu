

part of 'target_bloc.dart';

class TargetEvent{}

class TargetSetEvent extends TargetEvent{
  String height;
  String weight;
  TargetSetEvent(this.height, this.weight);
}

class TargetCheckEvent extends TargetEvent{}