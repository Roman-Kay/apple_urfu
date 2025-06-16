
part of "step_list_bloc.dart";

class StepListState{}

class StepListInitialState extends StepListState{}

class StepListLoadingState extends StepListState{}

class StepListLoadedState extends StepListState{
  List<ClientSensorsView>? stepsList;
  StepListLoadedState(this.stepsList);
}

class StepListErrorState extends StepListState{}

class StepListNotConnectedState extends StepListState{}

