
part of 'balance_wheel_bloc.dart';

class BalanceWheelState{}

class BalanceWheelInitialState extends BalanceWheelState{}

class BalanceWheelLoadingState extends BalanceWheelState{}

class BalanceWheelLoadedState extends BalanceWheelState{
  Map<String, List<BalanceWheel>> view;
  BalanceWheelLoadedState(this.view);
}

class BalanceWheelErrorState extends BalanceWheelState{}