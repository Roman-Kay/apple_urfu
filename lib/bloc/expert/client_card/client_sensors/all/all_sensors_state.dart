
part of 'all_sensors_bloc.dart';

class AllSensorsState{}

class AllSensorsInitialState extends AllSensorsState{}

class AllSensorsLoadingState extends AllSensorsState{}

class AllSensorsLoadedState extends AllSensorsState{
  int steps;
  int weight;
  int? goalWeight;
  int water;
  int? goalWater;
  double pressure;
  int? pulse;
  String? pressureDate;
  double bloodSugar;
  String? dateBloodSugar;
  int saturation;
  int workout;
  int sleep;
  String? dateSleep;
  String? workoutDate;

  AllSensorsLoadedState({
    required this.steps,
    required this.weight,
    this.goalWeight,
    required this.water,
    this.goalWater,
    required this.pressure,
    this.pulse,
    this.pressureDate,
    required this.saturation,
    required this.workout,
    required this.sleep,
    this.dateSleep,
    required this.bloodSugar,
    this.dateBloodSugar,
    this.workoutDate
});
}

class AllSensorsErrorState extends AllSensorsState{}
