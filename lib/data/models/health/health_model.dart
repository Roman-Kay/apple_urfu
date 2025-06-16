

class UserHealthResponse{
  UserHealthResponse({
  required this.code,
  this.message,
  this.model
});

  int code;
  UserHealthModel? model;
  String? message;
}

class UserHealthModel{
  UserHealthModel({
    this.value,
    this.dateFrom,
    this.dateTo
});
  num? value;
  DateTime? dateFrom;
  DateTime? dateTo;
}

class UserHealthSteps{
  UserHealthSteps({
    this.dateFrom,
    this.dateTo,
    this.distance,
    this.calorie
  });

  num? distance;
  int? calorie;
  DateTime? dateFrom;
  DateTime? dateTo;
}

class UserHealthPressure{
  UserHealthPressure({
    required this.pulse,
    required this.dateFrom,
    required this.dateTo,
    required this.diastolic,
    required this.systolic
  });

  double pulse;
  double diastolic;
  double systolic;
  DateTime dateFrom;
  DateTime dateTo;
}