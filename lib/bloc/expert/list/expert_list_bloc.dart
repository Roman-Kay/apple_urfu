
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/expert/list/expert_list.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:garnetbook/domain/services/expert/list/expert_list_data_service.dart';
import 'package:get_it/get_it.dart';


part 'expert_list_state.dart';
part 'expert_list_event.dart';

class ExpertListBloc extends Bloc<ExpertListEvent, ExpertListState> {
  ExpertListBloc() : super(ExpertListInitialState()){
    on<ExpertListAllEvent>(_getAll);
  }

  final service = ExpertListDataService();
  final client = GetIt.I.get<ApiClientProvider>().client;
  static const _pageSize = 10;
  int page = 0;

  Future<void> _getAll(ExpertListAllEvent event, Emitter<ExpertListState> emit) async{
    final lastListingState = state;
    try {
      final newItems = await client.getExpertList(event.page, _pageSize);

      bool isLastPage = false;

      if(newItems.totalPage != null){
        isLastPage = newItems.totalPage! == event.page;
      }

      final nextPageKey = isLastPage ? null : event.page + 1;

      emit(ExpertListState(
        error: null,
        nextPageKey: nextPageKey,
        isLastPage: isLastPage,
        totalElement: newItems.totalElement ?? 0,
        itemList: event.page == 0
            ? newItems.expertCardList ?? []
            : [...lastListingState.itemList ?? [], ...newItems.expertCardList ?? []],
      ));
    } catch (e) {
      emit(ExpertListState(
          error: e,
          nextPageKey: lastListingState.nextPageKey,
          itemList: lastListingState.itemList));
    }
  }

}