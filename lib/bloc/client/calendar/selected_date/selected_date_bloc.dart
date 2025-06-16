
import 'package:flutter_bloc/flutter_bloc.dart';

part 'selected_date_event.dart';
part 'selected_date_state.dart';

class SelectedDateBloc extends Bloc<SelectedDateEvent, SelectedDateState>{
  SelectedDateBloc() : super(SelectedDateState(DateTime.now())){
    on<SelectedDateGetEvent>(_get);
  }

  Future<void> _get(SelectedDateGetEvent event, Emitter<SelectedDateState> emit) async{
    emit(SelectedDateState(event.date));
  }
}