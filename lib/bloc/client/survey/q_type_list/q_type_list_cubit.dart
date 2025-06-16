
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/survey/q_type_view/q_type_view.dart';
import 'package:garnetbook/domain/services/survey/survey_services.dart';

part 'q_type_list_state.dart';

class QTypeListCubit extends Cubit<QTypeListState>{
  QTypeListCubit() : super(QTypeListInitialState());

  final service = SurveyServices();

  check() async{
    emit(QTypeListLoadingState());

    final response = await service.getListOfQTypes();

    if(response.result){
      emit(QTypeListLoadedState(response.value));
    }
    else{
      emit(QTypeListErrorState());
    }
  }
}