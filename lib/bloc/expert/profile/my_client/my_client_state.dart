
part of 'my_client_cubit.dart';

class MyClientState{}

class MyClientInitialState extends MyClientState{}

class MyClientLoadingState extends MyClientState{}

class MyClientLoadedState extends MyClientState{
  List<ExpertClientsView>? view;
  MyClientLoadedState(this.view);
}

class MyClientErrorState extends MyClientState{}