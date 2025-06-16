
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/library/library_categories_model.dart';
import 'package:garnetbook/domain/services/client/library/library_services.dart';

part 'categorises_state.dart';

class LibraryCategorisesCubit extends Cubit<LibraryCategorisesState>{
  LibraryCategorisesCubit() : super(LibraryCategorisesInitialState());

  final networkService = LibraryNetworkServices();

  check() async{
    emit(LibraryCategorisesLoadingState());

    final response = await networkService.getCategories();

    if(response.result){
      emit(LibraryCategorisesLoadedState(response.value));
    }
    else{
      emit(LibraryCategorisesErrorState());
    }
  }
}