
part of "client_steps_bloc.dart";

abstract class ClientStepsEvent{}

class ClientStepsGetEvent extends ClientStepsEvent{
  int id;
  int month;
  int year;
  ClientStepsGetEvent(this.id, this.month, this.year);
}

class ClientStepsInitialEvent extends ClientStepsEvent{}