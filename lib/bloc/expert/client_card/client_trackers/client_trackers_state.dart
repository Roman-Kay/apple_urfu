
part of 'client_trackers_bloc.dart';

class ClientCardTrackersState{}

class ClientCardTrackersInitialState extends ClientCardTrackersState{}

class ClientCardTrackersLoadingState extends ClientCardTrackersState{}

class ClientCardTrackersLoadedState extends ClientCardTrackersState{
  List<ClientTrackerView>? view;
  ClientCardTrackersLoadedState(this.view);
}

class ClientCardTrackersErrorState extends ClientCardTrackersState{}