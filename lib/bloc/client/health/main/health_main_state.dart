
part of 'health_main_cubit.dart';

class HealthMainState{}

class HealthMainInitialState extends HealthMainState{}

class HealthMainLoadingState extends HealthMainState{}

class HealthMainLoadedState extends HealthMainState{
  int steps;

  HealthMainLoadedState(this.steps);
}

class HealthMainErrorState extends HealthMainState{}