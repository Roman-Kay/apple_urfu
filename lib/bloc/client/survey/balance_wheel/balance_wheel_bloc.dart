import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/balance_wheel/balance_wheel.dart';
import 'package:garnetbook/domain/services/survey/balance_wheel.dart';
import 'package:intl/intl.dart';

part 'balance_wheel_event.dart';
part 'balance_wheel_state.dart';

class BalanceWheelBloc extends Bloc<BalanceWheelEvent, BalanceWheelState>{
  BalanceWheelBloc(): super(BalanceWheelInitialState()){
    on<BalanceWheelGetEvent>(_get);
  }

  final service = BalanceWheelService();

  Future<void> _get(BalanceWheelGetEvent event, Emitter<BalanceWheelState> emit) async{
    emit(BalanceWheelLoadingState());


    //int value = event.dayQuantity == 7 ? 6 : event.dayQuantity;
    //String dateStart = DateFormat("yyyy-MM-dd").format(event.date.subtract(Duration(days: value)));
    String dateEnd = DateFormat("yyyy-MM-dd").format(event.date);

    List<String> categoryList = [
      "карьера",
      "здоровье",
      "друзья",
      "семья",
      "отдых",
      "саморазвитие",
      "деньги",
      "хобби",
    ];


    Map<String, List<BalanceWheel>> list = {
      "карьера": [],
      "здоровье" : [],
      "друзья" : [],
      "семья" : [],
      "отдых" : [],
      "саморазвитие" : [],
      "деньги" : [],
      "хобби" : [],
    };

    bool isError = false;

    for(var element in list.keys.toList()){
      final response = await service.getBalanceWheel(BalanceWheelsRequest(
          categoryName: element,
          dateEnd: dateEnd,
          dateStart: dateEnd
      ));

      if(response.result){
        list[element] = response.value ?? [];
      }
      else{
        isError = true;
        break;
      }
    }



    if(!isError){
      emit(BalanceWheelLoadedState(list));
    }
    else{
      emit(BalanceWheelErrorState());
    }
  }
}