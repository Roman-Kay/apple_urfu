
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/library/library_model.dart';
import 'package:garnetbook/domain/services/client/library/library_services.dart';

part "article_event.dart";
part "article_state.dart";

class LibraryArticleBloc extends Bloc<LibraryArticleEvent, LibraryArticleState>{
  LibraryArticleBloc() : super(LibraryArticleInitialState()){
    on<LibraryArticleGetEvent>(_get);
  }

  final networkService = LibraryNetworkServices();

  Future<void> _get(LibraryArticleGetEvent event, Emitter<LibraryArticleState> emit) async{
    emit(LibraryArticleLoadingState());

    final response = await networkService.getArticleByCategory(event.id);

    if(response.result){
      emit(LibraryArticleLoadedState(response.value));
    }
    else{
      emit(LibraryArticleErrorState());
    }
  }
}