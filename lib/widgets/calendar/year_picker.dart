
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';

class CustomYearPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length);
  }

  CustomYearPicker({required DateTime currentTime, required LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime;
    this.setLeftIndex(0);
    this.setMiddleIndex(this.currentTime.year);
    this.setRightIndex(0);
  }

  @override
  String? leftStringAtIndex(int index) {
    return null;
  }

  @override
  String? middleStringAtIndex(int index) {
    if(index < 1980){
      return null;
    }
    else if (index >= 0 && index < DateTime.now().year + 1) {
      return this.digits(index, 4);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    return null;
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return "";
  }

  @override
  List<int> layoutProportions() {
    return [0, 3, 0];
  }

  @override
  DateTime finalTime() {
    return DateTime(this.currentMiddleIndex());
  }
}