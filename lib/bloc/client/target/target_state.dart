
part of 'target_bloc.dart';

class TargetState{}

class TargetInitialState extends TargetState{}

class TargetLoadingState extends TargetState{}

class TargetLoadedState extends TargetState{
  List<ClientTargetsView>? view;
  TargetLoadedState(this.view);
}

class TargetErrorState extends TargetState{}