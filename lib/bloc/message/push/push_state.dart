
part of 'push_cubit.dart';

class PushState{}

class PushInitialState extends PushState{}

class PushLoadingState extends PushState{}

class PushLoadedState extends PushState{
  PushListView? view;
  PushLoadedState(this.view);
}

class PushErrorState extends PushState{}