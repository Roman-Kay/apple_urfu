
part of 'water_diary_bloc.dart';

class WaterDiaryEvent{}

class WaterDiaryCheckEvent extends WaterDiaryEvent{
  DateTime date;
  WaterDiaryCheckEvent(this.date);
}
