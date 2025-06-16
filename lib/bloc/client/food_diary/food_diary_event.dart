
part of 'food_diary_bloc.dart';

class FoodDiaryEvent{}

class FoodDiaryGetEvent extends FoodDiaryEvent{
  DateTime date;
  FoodDiaryGetEvent(this.date);
}
