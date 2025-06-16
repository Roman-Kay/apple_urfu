
part of "subscribe_bloc.dart";

class SubscribeEvent{}

class SubscribeGetEvent extends SubscribeEvent{
  int stepId;
  SubscribeGetEvent(this.stepId);
}

class SubscribeNewEvent extends SubscribeEvent{}