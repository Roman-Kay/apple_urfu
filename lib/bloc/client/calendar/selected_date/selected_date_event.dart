
part of "selected_date_bloc.dart";


class SelectedDateEvent{}

class SelectedDateGetEvent extends SelectedDateEvent{
  DateTime date;
  SelectedDateGetEvent(this.date);
}