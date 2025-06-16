
part of 'client_trackers_bloc.dart';

class ClientCardTrackersEvent{}

class ClientCardTrackersGetEvent extends ClientCardTrackersEvent{
  ClientCardTrackersGetEvent(this.id);
  int id;
}

class ClientCardTrackersInitialEvent extends ClientCardTrackersEvent{}