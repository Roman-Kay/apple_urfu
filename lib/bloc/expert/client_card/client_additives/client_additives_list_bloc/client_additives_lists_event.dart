
part of 'client_additives_list_bloc.dart';

class ClientAdditivesListEvent{}

class ClientAdditivesListInitialEvent extends ClientAdditivesListEvent{
  List<AdditiveQueue>? queueList;
  ClientAdditivesListInitialEvent(this.queueList);
}

class ClientAdditivesListGetEvent extends ClientAdditivesListEvent{
  ClientAdditivesView add;
  ClientAdditivesListGetEvent(this.add);
}

class ClientAdditivesListDeleteEvent extends ClientAdditivesListEvent{
  ClientAdditivesView queue;
  ClientAdditivesListDeleteEvent(this.queue);
}