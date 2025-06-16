
part of "weight_bloc.dart";

class WeightEvent{}

class WeightGetEvent extends WeightEvent{
  int dayQuantity;
  DateTime date;
  WeightGetEvent(this.dayQuantity, this.date);
}

class WeightUpdateEvent extends WeightEvent{
  int dayQuantity;
  DateTime date;
  WeightUpdateEvent(this.dayQuantity, this.date);
}

class WeightConnectedEvent extends WeightEvent{
  int dayQuantity;
  DateTime date;
  WeightConnectedEvent(this.dayQuantity, this.date);
}
