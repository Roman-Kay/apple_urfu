
part of "trackers_cubit.dart";

class TrackersState{}

class TrackersInitialState extends TrackersState{}

class TrackersLoadingState extends TrackersState{}

class TrackersLoadedState extends TrackersState{
  List<ClientTrackerView>? view;
  TrackersLoadedState(this.view);
}

class TrackersErrorState extends TrackersState{}