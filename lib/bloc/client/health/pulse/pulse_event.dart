
part of "pulse_bloc.dart";

class PulseEvent{}

class PulseGetEvent extends PulseEvent{
  DateTime date;
  PulseGetEvent(this.date);
}
