
part of 'balance_wheel_bloc.dart';

class BalanceWheelEvent{}

class BalanceWheelGetEvent extends BalanceWheelEvent{
  DateTime date;
  BalanceWheelGetEvent(this.date);
}