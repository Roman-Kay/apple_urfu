
part of 'pressure_bloc.dart';

class PressureEvent{}

class PressureGetEvent extends PressureEvent{
  DateTime date;
  RequestedValue? value;
  PressureGetEvent(this.date, this.value);
}

class PressureUpdateEvent extends PressureEvent{
  DateTime date;
  RequestedValue? value;
  PressureUpdateEvent(this.date, this.value);
}

class PressuredConnectedEvent extends PressureEvent{
  DateTime date;
  RequestedValue? value;
  PressuredConnectedEvent(this.date, this.value);
}