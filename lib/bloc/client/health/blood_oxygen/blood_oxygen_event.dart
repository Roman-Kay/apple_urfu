
part of "blood_oxygen_bloc.dart";

class BloodOxygenEvent{}

class BloodOxygenGetEvent extends BloodOxygenEvent{
  DateTime date;
  RequestedValue? value;
  BloodOxygenGetEvent(this.date, this.value);
}

class BloodOxygenUpdateEvent extends BloodOxygenEvent{
  DateTime date;
  RequestedValue? value;
  BloodOxygenUpdateEvent(this.date, this.value);
}

class BloodOxygenConnectedEvent extends BloodOxygenEvent{
  DateTime date;
  RequestedValue? value;
  BloodOxygenConnectedEvent(this.date, this.value);
}