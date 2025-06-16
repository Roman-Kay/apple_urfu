
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';

part "subscribe_event.dart";
part 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState>{
  SubscribeBloc() : super(SubscribeInitialState()){
    on<SubscribeGetEvent>(_get);
    on<SubscribeNewEvent>(_new);
  }

  final service = SurveyServices();

  Future<void> _new(SubscribeNewEvent event, Emitter<SubscribeState> emit) async{
   emit(SubscribeInitialState());
  }

  Future<void> _get(SubscribeGetEvent event, Emitter<SubscribeState> emit) async{
    emit(SubscribeLoadingState());

    final response = await service.getSubscribe(event.stepId);

    if(response.result){
      emit(SubscribeLoadedState(response.value));
    }
    else{
      emit(SubscribeErrorState());
    }

  }
}