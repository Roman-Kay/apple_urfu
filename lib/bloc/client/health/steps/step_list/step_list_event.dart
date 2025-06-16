
part of "step_list_bloc.dart";

class StepListEvent{}

class StepListGetEvent extends StepListEvent{
  int selectedMonth;
  int selectedYear;
  int? clientId;
  StepListGetEvent(this.selectedMonth, this.selectedYear, this.clientId);
}