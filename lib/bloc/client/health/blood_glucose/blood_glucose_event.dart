
part of "blood_glucose_bloc.dart";


class BloodGlucoseEvent{}

class BloodGlucoseGetEvent extends BloodGlucoseEvent{
  DateTime date;
  RequestedValue? value;
  BloodGlucoseGetEvent(this.date, this.value);
}

class BloodGlucoseUpdateEvent extends BloodGlucoseEvent{
  DateTime date;
  RequestedValue? value;
  BloodGlucoseUpdateEvent(this.date, this.value);
}

class BloodGlucoseConnectedEvent extends BloodGlucoseEvent{
  DateTime date;
  RequestedValue? value;
  BloodGlucoseConnectedEvent(this.date, this.value);
}